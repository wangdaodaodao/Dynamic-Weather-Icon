/*
 * dytianqi - 动态天气图标插件
 * 
 * 作者: [王导导]
 * 版本: 1.0.1
 * 创建时间: 2024-09-06 14:30:34
 * 最后修改: 2024-09-07 11:34:04
 * 版权所有 © 2024 [com.wangdaodao.dytianqi]. 保留所有权利。
 *
 */

// 导入必要的框架
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000
@import WeatherKit;
#else
@interface WFWeatherService : NSObject
@end
#endif

// 声明 SBIcon 类，用于访问应用图标的属性
@interface SBIcon : NSObject
@property (nonatomic, readonly) NSString *applicationBundleID;
@end

// 声明 SBIconView 类，用于自定义应用图标视图
@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon *icon;
@end

// 为 SBIconView 添加分类，用于天气相关的属性和方法
@interface SBIconView (Weather) <CLLocationManagerDelegate>
@property (nonatomic, retain) UILabel *temperatureLabel;
@property (nonatomic, retain) UIImageView *weatherIconView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) WFCurrentWeather *cachedWeather;
@property (nonatomic, retain) NSDate *lastUpdateTime;
- (void)updateWeatherInfo;
- (NSTimeInterval)getUpdateInterval;
- (void)scheduleNextUpdate;
- (BOOL)isWeatherDataDifferent:(WFCurrentWeather *)newWeather;
- (void)fetchRealTimeWeather:(void (^)(WFCurrentWeather *weather, NSError *error))completion;
- (void)updateUIWithWeather:(WFCurrentWeather *)weather isCached:(BOOL)isCached;
- (void)updateCacheWithWeather:(WFCurrentWeather *)weather;
- (UIImage *)weatherIconForCondition:(WFWeatherCondition)condition 
                         temperature:(double)temperature 
                         currentDate:(NSDate *)currentDate 
                             sunrise:(NSDate *)sunrise 
                              sunset:(NSDate *)sunset;
- (BOOL)isNightTime:(NSDate *)currentDate sunrise:(NSDate *)sunrise sunset:(NSDate *)sunset;
@end

// 开始对 SBIconView 类进行 Hook
%hook SBIconView

// 添加新的属性
%property (nonatomic, retain) UILabel *temperatureLabel;
%property (nonatomic, retain) UIImageView *weatherIconView;
%property (nonatomic, retain) CLLocationManager *locationManager;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000
%property (nonatomic, retain) WFCurrentWeather *cachedWeather;
#endif

%property (nonatomic, retain) NSDate *lastUpdateTime;

// Hook initWithContentType: 方法，用于初始化天气图标
- (id)initWithContentType:(unsigned long long)arg1 {
    self = %orig;
    if (self) {
        if ([self.icon.applicationBundleID isEqualToString:@"com.apple.weather"]) {
            if (@available(iOS 16.0, *)) {
                // iOS 16+ 的初始化代码
                [self setupWeatherUI];
                [self initializeLocationManager];
                [self updateWeatherInfo];
            }
        }
    }
    return self;
}

%new
- (void)setupWeatherUI {
    if (@available(iOS 16.0, *)) {
        // 创建并配置温度标签
        self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
        self.temperatureLabel.textAlignment = NSTextAlignmentCenter;
        self.temperatureLabel.font = [UIFont boldSystemFontOfSize:12];
        self.temperatureLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.temperatureLabel];
        
        // 创建并配置天气图标视图
        self.weatherIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height - 20)];
        self.weatherIconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.weatherIconView];
    }
}

%new
- (void)initializeLocationManager {
    if (@available(iOS 16.0, *)) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = (id<CLLocationManagerDelegate>)self;
        [self.locationManager requestWhenInUseAuthorization];
    }
}

%new
- (NSTimeInterval)getUpdateInterval {
    if (@available(iOS 16.0, *)) {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:now];
        
        if (hour >= 23 || hour < 6) {
            return 3600; // 深夜 23:00-5:59，更新间隔为 1 小时
        } else {
            return 1800; // 其他时间 6:00-22:59，更新间隔为 30 分钟
        }
    }
    return 0;
}

%new
- (void)scheduleNextUpdate {
    if (@available(iOS 16.0, *)) {
        // 安排下一次更新
        NSTimeInterval interval = [self getUpdateInterval];
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(updateWeatherInfo)
                                       userInfo:nil
                                        repeats:NO];
    }
}

%new
- (void)updateWeatherInfo {
    if (@available(iOS 16.0, *)) {
        // iOS 16+ 的天气更新逻辑
        [self fetchRealTimeWeather:^(WFCurrentWeather *newWeather, NSError *error) {
            if (error) {
                NSLog(@"获取天气数据失败: %@", error);
                if (self.cachedWeather) {
                    [self updateUIWithWeather:self.cachedWeather isCached:YES];
                }
            } else if ([self isWeatherDataDifferent:newWeather]) {
                [self updateUIWithWeather:newWeather isCached:NO];
                [self updateCacheWithWeather:newWeather];
            }
            
            [self scheduleNextUpdate];
        }];
    }
}

%new
- (BOOL)isWeatherDataDifferent:(WFCurrentWeather *)newWeather {
    if (@available(iOS 16.0, *)) {
        // 检查新的天气数据是否与缓存的数据有显著差异
        NSTimeInterval timeSinceLastUpdate = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
        NSTimeInterval updateThreshold = [self getUpdateInterval];
        
        if (timeSinceLastUpdate >= updateThreshold) {
            return YES;
        }
        
        BOOL temperatureDifferent = fabs(newWeather.temperature.value - self.cachedWeather.temperature.value) > 1.0;
        BOOL conditionDifferent = newWeather.condition != self.cachedWeather.condition;
        
        return temperatureDifferent || conditionDifferent;
    }
    return NO;
}

%new
- (void)fetchRealTimeWeather:(void (^)(WFCurrentWeather *weather, NSError *error))completion {
    if (@available(iOS 16.0, *)) {
        [self.locationManager requestLocation];
        // 假设位置更新成功后会调用 locationManager:didUpdateLocations: 方法
        // 在那里继续获取天气数据并调用 completion
    }
}

%new
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (@available(iOS 16.0, *)) {
        CLLocation *location = locations.lastObject;
        if (location) {
            WFWeatherService *weatherService = [WFWeatherService sharedService];
            [weatherService getCurrentWeatherForLocation:location
                                             temperature:WFTemperatureUnitCelsius
                                             completion:^(WFCurrentWeather * _Nullable weather, NSError * _Nullable error) {
                if (weather) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateUIWithWeather:weather isCached:NO];
                        [self updateCacheWithWeather:weather];
                    });
                } else {
                    NSLog(@"天气获取错误: %@", error);
                }
            }];
        }
    }
}

%new
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (@available(iOS 16.0, *)) {
        NSLog(@"位置获取错误: %@", error);
    }
}

%new
- (void)updateUIWithWeather:(WFCurrentWeather *)weather isCached:(BOOL)isCached {
    if (@available(iOS 16.0, *)) {
        // 检查是否触发彩蛋条件
        BOOL isEasterEgg = (weather.condition == WFWeatherConditionClear && weather.temperature.value > 40.0);
        
        // 更新温度标签
        self.temperatureLabel.text = isEasterEgg ? @"热辣" : [NSString stringWithFormat:@"%.1f°", weather.temperature.value];
        
        // 更新天气图标
        self.weatherIconView.image = [self weatherIconForCondition:weather.condition 
                                                        temperature:weather.temperature.value 
                                                        currentDate:[NSDate date] 
                                                            sunrise:weather.dayForecast.sunrise 
                                                             sunset:weather.dayForecast.sunset];
    }
}

%new
- (void)updateCacheWithWeather:(WFCurrentWeather *)weather {
    if (@available(iOS 16.0, *)) {
        self.cachedWeather = weather;
        self.lastUpdateTime = [NSDate date];
    }
}

%new
- (UIImage *)weatherIconForCondition:(WFWeatherCondition)condition 
                         temperature:(double)temperature 
                         currentDate:(NSDate *)currentDate 
                             sunrise:(NSDate *)sunrise 
                              sunset:(NSDate *)sunset {
    if (@available(iOS 16.0, *)) {
        NSString *iconName;
        BOOL isNight = [self isNightTime:currentDate sunrise:sunrise sunset:sunset];
        
        // 检查是否触发彩蛋条件
        if (condition == WFWeatherConditionClear && temperature > 40.0) {
            iconName = @"easter_egg_hot";
        } else {
            switch (condition) {
                case WFWeatherConditionClear:
                    iconName = isNight ? @"clear_night" : @"sunny";
                    break;
                case WFWeatherConditionCloudy:
                    iconName = @"cloudy";
                    break;
                case WFWeatherConditionMostlyCloudy:
                    iconName = isNight ? @"mostly_cloudy_night" : @"mostly_cloudy";
                    break;
                case WFWeatherConditionPartlyCloudy:
                    iconName = isNight ? @"partly_cloudy_night" : @"partly_cloudy";
                    break;
                case WFWeatherConditionRain:
                    iconName = @"rainy";
                    break;
                case WFWeatherConditionDrizzle:
                    iconName = @"drizzle";
                    break;
                case WFWeatherConditionSnow:
                    iconName = @"snowy";
                    break;
                case WFWeatherConditionSleet:
                    iconName = @"sleet";
                    break;
                case WFWeatherConditionWintryMix:
                    iconName = @"rain_and_snow";
                    break;
                case WFWeatherConditionThunderstorms:
                    iconName = @"thunderstorm";
                    break;
                case WFWeatherConditionFog:
                    iconName = isNight ? @"fog_night" : @"fog";
                    break;
                case WFWeatherConditionWindy:
                    iconName = @"windy";
                    break;
                default:
                    iconName = @"unknown";
                    break;
            }
        }
        
        // 从插件的资源包中加载图标
        NSBundle *tweakBundle = [NSBundle bundleWithPath:@"/Library/MobileSubstrate/DynamicLibraries/dytianqi.bundle"];
        NSString *iconPath = [tweakBundle pathForResource:iconName ofType:@"png" inDirectory:@"WeatherIcons"];
        UIImage *icon = [UIImage imageWithContentsOfFile:iconPath];
        
        // 如果找不到特定图标，使用默认图标
        if (!icon) {
            NSLog(@"警告: 无法找到图标 %@，使用默认图标", iconName);
            iconPath = [tweakBundle pathForResource:@"unknown" ofType:@"png" inDirectory:@"WeatherIcons"];
            icon = [UIImage imageWithContentsOfFile:iconPath];
        }
        
        return icon;
    }
    return nil;
}

%new
- (BOOL)isNightTime:(NSDate *)currentDate sunrise:(NSDate *)sunrise sunset:(NSDate *)sunset {
    if (@available(iOS 16.0, *)) {
        // 判断当前是否为夜晚
        return ([currentDate compare:sunset] == NSOrderedDescending || [currentDate compare:sunrise] == NSOrderedAscending);
    }
    return NO;
}

%end


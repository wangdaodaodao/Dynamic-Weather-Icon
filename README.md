# 动态天气图标 / Dynamic Weather Icon

[中文](#动态天气图标) | [English](#dynamic-weather-icon)

---

<div style="background-color: #FFCCCC; border: 3px solid #FF0000; padding: 10px; margin: 10px 0;">
<h2 style="color: #FF0000; text-align: center;">⚠️ 警告 / WARNING ⚠️</h2>

<p style="font-size: 18px; font-weight: bold; text-align: center;">
[中文] 该插件目前还未经过充分测试，请谨慎使用。<br>
[English] This tweak has not been thoroughly tested yet. Use with caution.
</p>
</div>

---

# 动态天气图标

## 简介

动态天气图标是一个为 iOS 设备开发的越狱插件，可以在天气应用图标上显示实时天气信息。该插件支持 iOS 15.0 及以上版本，但完整功能需要 iOS 16.0+。

## 功能特点

 * 1. 智能更新天气信息，深夜（23:00-5:59）降低更新频率至每小时一次（仅iOS 16+）
 * 2. 在天气应用图标上显示实时温度，精确到小数点后一位（仅iOS 16+）
 * 3. 使用自定义图标显示当前天气状况，根据日出日落时间区分白天和夜晚（仅iOS 16+）
 * 4. 特殊彩蛋：晴天且温度超过40°C时显示"热辣"（仅iOS 16+）
 * 5. 使用 Objective-C 和 Logos 语法编写，适用于越狱设备
 * 6. 通过 Hook 系统的 SBIconView 类来动态修改天气应用图标（仅iOS 16+）
 * 7. 利用 CoreLocation 获取设备精确位置，实现本地化天气信息（仅iOS 16+）
 * 8. 集成 WeatherKit 框架获取实时天气数据，支持多种天气条件（仅iOS 16+）
 * 9. 实现智能缓存机制，仅在天气数据发生显著变化时更新UI（仅iOS 16+）
 * 10. 自定义天气图标资源存储在插件的 bundle 中，支持多种天气状况（仅iOS 16+）
 * 11. 实现错误处理机制，在获取位置或天气数据失败时使用缓存数据（仅iOS 16+）
 * 12. 支持iOS 16.0及以上版本，利用最新的WeatherKit API

## 系统要求

- iOS 15.0 或更高版本（完整功能需要 iOS 16.0+）
- 已越狱的设备

## 安装

1. 将 dytianqi.deb 文件添加到您喜欢的包管理器中（如 Cydia、Sileo 等）
2. 安装插件
3. 重启设备 SpringBoard

## 配置

本插件无需额外配置，安装后即可使用。

## 注意事项

- 该插件需要访问您的位置以获取准确的天气信息
- WeatherKit 功能仅在 iOS 16+ 设备上可用

## 作者

王导导

## 版权

© 2024 [com.wangdaodao.dytianqi]. 保留所有权利。

## 许可证

[在此处添加许可证信息]

## 支持

如有任何问题或建议，请联系：[添加联系方式]

---

# Dynamic Weather Icon

## Introduction

Dynamic Weather Icon is a jailbreak tweak developed for iOS devices that displays real-time weather information on the Weather app icon. This tweak supports iOS 15.0 and above, but full functionality requires iOS 16.0+.

## Features

- Display real-time temperature on the Weather app icon (accurate to one decimal place)
- Use custom icons to show current weather conditions
- Distinguish between day and night icons based on sunrise and sunset times
- Smart weather information updates with reduced frequency at night
- Special easter egg: displays "Hot" when it's sunny and temperature exceeds 40°C
- Custom icons for various weather conditions
- Implement smart caching mechanism for optimized performance

## System Requirements

- iOS 15.0 or higher (full functionality requires iOS 16.0+)
- Jailbroken device

## Installation

1. Add the dytianqi.deb file to your preferred package manager (e.g., Cydia, Sileo, etc.)
2. Install the tweak
3. Respring your device

## Configuration

This tweak requires no additional configuration. It works right after installation.

## Notes

- This tweak requires access to your location for accurate weather information
- WeatherKit functionality is only available on iOS 16+ devices

## Author

Wang Dao Dao

## Copyright

© 2024 [com.wangdaodao.dytianqi]. All rights reserved.

## License

[Add license information here]

## Support

For any issues or suggestions, please contact: [Add contact information]

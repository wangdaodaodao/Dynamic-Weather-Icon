ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
SYSROOT = $(THEOS)/sdks/iPhoneOS.sdk


THEOS_IGNORE_CYDIASUBSTRATE = 1
THEOS_PACKAGE_SCHEME = rootless
THEOS_PLATFORM_LFLAGS += -v

THEOS_PLATFORM_DEB_COMPRESSION_TYPE = gzip
THEOS_PLATFORM_DEB_COMPRESSION_LEVEL = 9
THEOS_USE_NEW_ABI = 0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = dytianqi

dytianqi_FILES = Tweak.x
dytianqi_CFLAGS = -fobjc-arc
dytianqi_FRAMEWORKS = UIKit CoreLocation
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
dytianqi_FRAMEWORKS += WeatherKit
endif

dytianqi_CFLAGS += -F/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks

include $(THEOS_MAKE_PATH)/tweak.mk
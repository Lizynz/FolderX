export ARCHS = arm64 arm64e
GO_EASY_ON_ME = 1
PACKAGE_VERSION = 2.0

TARGET = iphone:clang:14.5
THEOS_LAYOUT_DIR_NAME = layout-rootless
THEOS_PACKAGE_SCHEME = rootless

export SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FolderX

FolderX_OBJCCFLAGS = \
    -isystem /Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/usr/include/c++/v1 \
    -Wno-cpp \
    -Wno-vla-cxx-extension

$(TWEAK_NAME)_FILES = $(wildcard *.xm *.m)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation SpringBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += folderx
include $(THEOS_MAKE_PATH)/aggregate.mk

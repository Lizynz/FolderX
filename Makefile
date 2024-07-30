#DEBUG = 0

ROOTLESS ?= 0

ifeq ($(ROOTLESS),1)
	TARGET = iphone:clang:14.5
	THEOS_LAYOUT_DIR_NAME = layout-rootless
	THEOS_PACKAGE_SCHEME = rootless
else
	TARGET = iphone:clang:14.5
endif

GO_EASY_ON_ME = 1

PACKAGE_VERSION = 1.1.2

export SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FolderX

$(TWEAK_NAME)_FILES = $(wildcard *.xm *.m)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation SpringBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += folderx
include $(THEOS_MAKE_PATH)/aggregate.mk

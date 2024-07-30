export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FolderX

FolderX_FILES = $(wildcard *.m)
FolderX_FRAMEWORKS = UIKit
FolderX_PRIVATE_FRAMEWORKS = Preferences
FolderX_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk

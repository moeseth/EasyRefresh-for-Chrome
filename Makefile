include theos/makefiles/common.mk

export GO_EASY_ON_ME=1
export SDKVERSION=5.1

EasyRefreshforChrome_FRAMEWORKS=UIKit QuartzCore
TWEAK_NAME = EasyRefreshforChrome
EasyRefreshforChrome_FILES = EasyRefreshforChrome_tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

ifeq ($(shell [ -f ./framework/makefiles/common.mk ] && echo 1 || echo 0),0)
all clean package install::
	git submodule update --init --recursive
	$(MAKE) $(MAKEFLAGS) MAKELEVEL=0 $@
else

ADDITIONAL_CFLAGS = -DVERSION="$(FW_PACKAGE_VERSION)"

# SBCustomIcon.dylib (/Library/MobileSubstrate/DynamicLibraries)
TWEAK_NAME = SBCustomIcon
SBCustomIcon_OBJC_FILES = hook.m SBApplication.m UIApplication.m
SBCustomIcon_FRAMEWORKS = Foundation UIKit CoreFoundation

include framework/makefiles/common.mk
include framework/makefiles/tweak.mk

internal-package::
	mkdir -p $(FW_PACKAGE_STAGING_DIR)/usr/include/UIKit
	cp -a UIApplication-SBCustomIcon.h $(FW_PACKAGE_STAGING_DIR)/usr/include/UIKit/

endif

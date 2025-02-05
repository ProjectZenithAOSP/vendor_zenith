PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 1
ZENITH_CODENAME = Athena

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)

ZENITH_BUILDTYPE ?= UNOFFICIAL

ifeq ($(WITH_GAPPS), true)
ZENITH_VERSION := ProjectZenith-v$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(ZENITH_CODENAME)-$(CURRENT_DEVICE)-GAPPS-$(ZENITH_BUILDTYPE)-$(shell date -u +%Y%m%d-%H%M)
else
ZENITH_VERSION := ProjectZenith-v$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(ZENITH_CODENAME)-$(CURRENT_DEVICE)-VANILLA-$(ZENITH_BUILDTYPE)-$(shell date -u +%Y%m%d-%H%M)
endif

# Display version
ZENITH_DISPLAY_VERSION := v$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(ZENITH_CODENAME)

# Project Zenith version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.zenith.version=$(ZENITH_VERSION) \
    ro.zenith.display.version=$(ZENITH_DISPLAY_VERSION) \
    ro.zenith.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(ZENITH_CODENAME) \
    ro.zenith.releasetype=$(ZENITH_BUILDTYPE) \
    ro.modversion=$(ZENITH_VERSION)

# Signing
-include vendor/zenith-priv/keys/keys.mk

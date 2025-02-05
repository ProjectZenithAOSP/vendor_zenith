# Basic
PRODUCT_PACKAGES += \
    SettingsIntelligence \
    ThemePicker \
    WallpaperPicker2 \
    Launcher3QuickStep

PRODUCT_DEXPREOPT_SPEED_APPS += \
    Launcher3QuickStep
    
# Vanilla Apps
$(call inherit-product, vendor/vanilla/vanilla.mk)

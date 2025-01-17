# Inherit mobile full common Zenith stuff
$(call inherit-product, vendor/zenith/config/common_mobile_full.mk)

# Inherit tablet common Zenith stuff
$(call inherit-product, vendor/zenith/config/tablet.mk)

$(call inherit-product, vendor/zenith/config/telephony.mk)

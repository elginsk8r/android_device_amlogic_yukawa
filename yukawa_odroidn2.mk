# Inherit the full_base and device configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/amlogic/yukawa/device-yukawa_odroidn2.mk)
$(call inherit-product, device/amlogic/yukawa/yukawa-common.mk)

PRODUCT_NAME := yukawa_odroidn2
PRODUCT_DEVICE := yukawa_odroidn2
PRODUCT_MANUFACTURER := Hardkernel

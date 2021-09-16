$(call inherit-product, device/amlogic/yukawa/device-common.mk)

PRODUCT_PROPERTY_OVERRIDES += ro.product.device=sei510

GPU_TYPE ?= dvalin_ion

# Feature permissions
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/permissions/yukawa.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/yukawa.xml

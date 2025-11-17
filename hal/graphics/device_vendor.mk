# Graphics #
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=320

# Vulkan
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:vendor/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:vendor/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:vendor/etc/permissions/android.hardware.vulkan.level.xml

PRODUCT_PACKAGES += \
    gralloc.yukawa \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl-2.1

# Hardware Composer HAL
#
PRODUCT_PACKAGES += android.hardware.composer.hwc3-service.drm.meson

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.egl=mali \
    ro.hardware.vulkan=yukawa

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=yukawa

# Create input surface on the framework side
PRODUCT_VENDOR_PROPERTIES += \
    debug.stagefright.c2inputsurface=-1

PRODUCT_VENDOR_PROPERTIES += \
	ro.opengles.version=196610

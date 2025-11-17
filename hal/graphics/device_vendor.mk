# Graphics #
ifeq ($(TARGET_DEV_BOARD), vim3l)
PRODUCT_SOONG_NAMESPACES += vendor/amlogic/yukawa/gpu/mesa/a55
else
PRODUCT_SOONG_NAMESPACES += vendor/amlogic/yukawa/gpu/mesa/a73
endif
PRODUCT_VENDOR_PROPERTIES += ro.sf.lcd_density=160
# HWUI VULKAN not working with mesa 25.3
# TARGET_USES_VULKAN = true

# opengles features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2021-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

# Vulkan
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:vendor/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:vendor/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:vendor/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:vendor/etc/permissions/android.software.vulkan.deqp.level.xml

# Minigbm mapper/allocator
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-service.minigbm \
    gralloc.minigbm \
    libminigbm_gralloc \
    mapper.minigbm \
    libgbm_mesa_wrapper

# Mesa GBM backend path
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.hwcomposer=drm \
    ro.hardware.egl=mesa \
    ro.hardware.vulkan=mesa \
    graphics.gpu.profiler.support=true \
    vendor.hwc.drm.device=/dev/dri/card1 \
    ro.hardware.gralloc=minigbm \
    vendor.gralloc.minigbm.backend=gbm_mesa \
    vendor.mesa.gbm_backends_path=/vendor/lib64/gbm \
    debug.renderengine.backend=skiaglthreaded

# Hardware Composer HAL
#
PRODUCT_PACKAGES += android.hardware.composer.hwc3-service.drm

# Display settings (windowing, system decorations, IME ...)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/display_settings.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display_settings.xml

# Create input surface on the framework side
PRODUCT_VENDOR_PROPERTIES += \
    debug.stagefright.c2inputsurface=-1

PRODUCT_VENDOR_PROPERTIES += \
	ro.opengles.version=196864

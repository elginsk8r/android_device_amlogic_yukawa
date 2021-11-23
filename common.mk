PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Kernel
$(call inherit-product, $(LOCAL_PATH)/kernel.mk)

# APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# ART
PRODUCT_RUNTIMES := runtime_libart_default

# Scoped Storage related
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-service \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.soundtrigger@2.2-impl \
    audio.usb.default \
    audio.primary.yukawa \
    audio.r_submix.default \
    audio.bluetooth.default \
    audio.hearing_aid.default \
    audio.a2dp.default \
    tinyplay \
    tinycap \
    tinymix \
    tinypcminfo \
    cplay

USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/hal/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(LOCAL_PATH)/hal/audio/speaker_eq_sei610.fir:$(TARGET_COPY_OUT_VENDOR)/etc/speaker_eq_sei610.fir \
    $(LOCAL_PATH)/permissions/yukawa.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/yukawa.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/media/libeffects/data/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

AUDIO_DEFAULT_OUTPUT ?= speaker
ifeq ($(AUDIO_DEFAULT_OUTPUT),hdmi)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/hal/audio/audio_policy_configuration_hdmi_only.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml

DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/hal/audio/overlay_hdmi_only
else
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/hal/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
endif

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1-service.btlinux \
    YukawaService \
    YukawaAndroidOverlay

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/input/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-external-service

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/hal/camera/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

# Display
ifneq ($(filter g12b s922x a311d,$(TARGET_AMLOGIC_SOC)),)
GPU_TYPE := gondul_ion
endif
GPU_TYPE ?= dvalin_ion
PRODUCT_PACKAGES +=  \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.memtrack@1.0-impl \
    gralloc.yukawa \
    hwcomposer.drm_meson \
    libGLES_mali  \
    libGLES_android \
    memtrack.default

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=320

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.4-service.widevine \
    android.hardware.drm@1.4-service.clearkey

# Fastboot
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0 \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software

# HDMI CEC
PRODUCT_PACKAGES += \
    android.hardware.tv.cec@1.0-impl \
    android.hardware.tv.cec@1.0-service \
    hdmi_cec.yukawa

PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=4 \
    persist.sys.hdmi.keep_awake=false

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/input/Generic.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.hdmi.cec.xml

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service.yukawa \
    android.hardware.health@2.0-service

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# Light
PRODUCT_PACKAGES += \
    android.hardware.light-service \
    lights-yukawa

# Live-LocK Daemon
PRODUCT_PACKAGES += \
    llkd

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media_xml/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml

# Permissions
PRODUCT_COPY_FILES +=  \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.cts.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.cts.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml

# Power
PRODUCT_PACKAGES += \
    power.default \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service

# Ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.yukawa.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.yukawa.rc \
    $(LOCAL_PATH)/init.yukawa.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.yukawa.usb.rc \
    $(LOCAL_PATH)/init.recovery.hardware.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.yukawa.rc \
    $(LOCAL_PATH)/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# Sensors
ifneq ($(TARGET_SENSOR_MEZZANINE),)
TARGET_USES_NANOHUB_SENSORHAL := true
NANOHUB_SENSORHAL_LID_STATE_ENABLED := true
NANOHUB_SENSORHAL_SENSORLIST := $(LOCAL_PATH)/sensorhal/sensorlist_$(TARGET_SENSOR_MEZZANINE).cpp
NANOHUB_SENSORHAL_DIRECT_REPORT_ENABLED := true
NANOHUB_SENSORHAL_DYNAMIC_SENSOR_EXT_ENABLED := true

PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-service \
    android.hardware.sensors@1.0-impl \
    android.hardware.contexthub@1.0-service \
    android.hardware.contexthub@1.0-impl \
    context_hub.default \
    nanoapp_cmd \
    nanotool \
    sensors.yukawa \
    stm32_flash

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.common.nanohub.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.nanohub.rc \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.hifi_sensors.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.hifi_sensors.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.relative_humidity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.relative_humidity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

# Argonkey VL53L0X proximity driver is not available yet. So we are going to copy conf file for neonkey only
ifeq ($(TARGET_SENSOR_MEZZANINE),neonkey)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml
endif
endif

# Thermal
PRODUCT_PACKAGES += \
    thermal.default \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@1.0-service

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.1-service

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# Virtualization APEX
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# Video
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/binaries/video_firmware/g12a_h264.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/g12a_h264.bin \
    $(LOCAL_PATH)/binaries/video_firmware/g12a_hevc_mmu.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/g12a_hevc_mmu.bin \
    $(LOCAL_PATH)/binaries/video_firmware/g12a_vp9.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/g12a_vp9.bin \
    $(LOCAL_PATH)/binaries/video_firmware/gxl_mpeg4_5.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/gxl_mpeg4_5.bin \
    $(LOCAL_PATH)/binaries/video_firmware/gxl_mpeg12.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/gxl_mpeg12.bin \
    $(LOCAL_PATH)/binaries/video_firmware/gxl_mjpeg.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/gxl_mjpeg.bin \
    $(LOCAL_PATH)/binaries/video_firmware/sm1_hevc_mmu.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/sm1_hevc_mmu.bin \
    $(LOCAL_PATH)/binaries/video_firmware/sm1_vp9_mmu.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/meson/vdec/sm1_vp9_mmu.bin

# VNDK
PRODUCT_SHIPPING_API_LEVEL := 29
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
PRODUCT_PACKAGES += \
    libhidltransport \
    libhwbinder \
    vndk_package

# Vulkan
PRODUCT_PACKAGES +=  \
    vulkan.yukawa.so

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:vendor/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:vendor/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:vendor/etc/permissions/android.hardware.vulkan.level.xml

# Wifi
PRODUCT_PACKAGES += \
    libwpa_client \
    wpa_supplicant \
    hostapd \
    wificond \
    wpa_cli

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/binaries/bt-wifi-firmware/BCM.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/brcm/BCM4359C0.hcd \
    $(LOCAL_PATH)/binaries/bt-wifi-firmware/fw_bcm4359c0_ag.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/brcm/fw_bcm4359c0_ag.bin \
    $(LOCAL_PATH)/binaries/bt-wifi-firmware/nvram.txt:$(TARGET_COPY_OUT_VENDOR)/firmware/brcm/nvram.txt \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml

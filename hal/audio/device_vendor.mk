# BayLibre Generic Audio HAL configuration for Yukawa
PRODUCT_PACKAGES += \
    tinyplay2 \
    tinycap2 \
    tinymix2 \
    tinypcminfo2 \
    cplay

# audio policy configuration
USE_XML_AUDIO_POLICY_CONF := 1

DEVICE_PACKAGE_OVERLAYS += \
    device/amlogic/yukawa/hal/audio/overlay_hdmi_only
TARGET_USE_HDMI_AUDIO ?= true

# Generic Audio HAL AIDL packages
PRODUCT_PACKAGES += \
    com.android.hardware.audio.generic \
    android.hardware.bluetooth.audio-impl

# Copy BayLibre audio configuration files for Yukawa
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/hal/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    device/amlogic/yukawa/hal/audio/primary_audio_policy_configuration_hdmi_only.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    device/amlogic/yukawa/hal/audio/mixer_controls.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_controls.xml \
    hardware/amlogic/yukawa/audio/audio_effects_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects_config.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml

# Include BayLibre Audio HAL properties
-include device/amlogic/yukawa/hal/audio/audio_properties.mk


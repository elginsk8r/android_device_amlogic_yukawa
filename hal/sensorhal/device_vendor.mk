# Sensor HAL
ifneq ($(TARGET_SENSOR_MEZZANINE),)
TARGET_USES_NANOHUB_SENSORHAL := true
NANOHUB_SENSORHAL_LID_STATE_ENABLED := true
NANOHUB_SENSORHAL_SENSORLIST := $(LOCAL_PATH)/sensorlist_$(TARGET_SENSOR_MEZZANINE).cpp
NANOHUB_SENSORHAL_DIRECT_REPORT_ENABLED := true
NANOHUB_SENSORHAL_DYNAMIC_SENSOR_EXT_ENABLED := true

PRODUCT_PACKAGES += \
    context_hub.default \
    sensors.yukawa \
    android.hardware.sensors@1.0-service \
    android.hardware.sensors@1.0-impl \
    android.hardware.contexthub@1.2-service \
    android.hardware.contexthub@1.2-impl

# Nanohub tools
PRODUCT_PACKAGES += stm32_flash nanoapp_cmd nanotool

PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/init.common.nanohub.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.nanohub.rc

# Copy sensors config file(s)
PRODUCT_COPY_FILES += \
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

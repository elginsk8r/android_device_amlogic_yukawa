# Thermal HAL Configuration

# Thermal HAL package
PRODUCT_PACKAGES += \
	com.android.hardware.thermal.rs.generic.v3

# Set thermal hardware configuration
# This property tells the thermal HAL which configuration file to load
# from /apex/com.android.hardware.thermal.rs.generic/etc/thermal/
PRODUCT_VENDOR_PROPERTIES += \
    vendor.thermal.hardware=g12

PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

ifeq ($(TARGET_VIM3), true)
PRODUCT_BRAND := Khadas
else ifeq ($(TARGET_VIM3L), true)
PRODUCT_BRAND := Khadas
else ifeq ($(TARGET_ODROIDN2), true)
PRODUCT_BRAND := Hardkernel
else
PRODUCT_BRAND := SEI
endif

ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
PRODUCT_MODEL := AOSP on yukawa
else
PRODUCT_MODEL := ATV on yukawa
endif

ifeq ($(TARGET_VIM3), true)
PRODUCT_MANUFACTURER := Khadas
else ifeq ($(TARGET_VIM3L), true)
PRODUCT_MANUFACTURER := Khadas
else ifeq ($(TARGET_ODROIDN2), true)
PRODUCT_MANUFACTURER := Hardkernel
else
PRODUCT_MANUFACTURER := SEI Robotics
endif

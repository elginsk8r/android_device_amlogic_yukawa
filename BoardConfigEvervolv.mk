#
# Product-specific compile-time definitions.
#
TARGET_NO_KERNEL_OVERRIDE := true

BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_KERNEL_CONFIG := meson_defconfig
TARGET_KERNEL_SOURCE := kernel/amlogic/yukawa

# Reserved Space
ifneq ($(WITH_GMS),true)
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 368640000
endif
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 15360000

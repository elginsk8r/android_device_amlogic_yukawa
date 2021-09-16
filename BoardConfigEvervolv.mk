#
# Product-specific compile-time definitions.
#

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    hardware/evervolv/interfaces/compatibility_matrices/compatibility_matrix.evervolv.xml \
    hardware/lineage/interfaces/compatibility_matrices/compatibility_matrix.lineage.xml

# Kernel
BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_KERNEL_CONFIG := meson_defconfig
TARGET_KERNEL_SOURCE := kernel/amlogic/yukawa
TARGET_NO_KERNEL_OVERRIDE := true

include device/amlogic/yukawa/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := odroidn2
TARGET_BOARD_INFO_FILE := device/amlogic/yukawa/odroidn2/board-info.txt

ifeq ($(TARGET_USE_AB_SLOT), true)
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10730078208
else
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12870221824
endif

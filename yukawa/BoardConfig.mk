include device/amlogic/yukawa/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_DEV_BOARD)
TARGET_BOARD_INFO_FILE := device/amlogic/yukawa/board-info/board-info-$(TARGET_DEV_BOARD).txt

ifeq ($(TARGET_USE_AB_SLOT), true)
BOARD_USERDATAIMAGE_PARTITION_SIZE := $(shell echo $$(( 10233 * 1024 * 1024 )))
else
BOARD_USERDATAIMAGE_PARTITION_SIZE := $(shell echo $$(( 12274 * 1024 * 1024 )))
endif

include device/amlogic/yukawa/BoardConfigCommon.mk

BOARD_USERDATAIMAGE_PARTITION_SIZE := $(shell echo $$(( 4820 * 1024 * 1024 )))

TARGET_BOOTLOADER_BOARD_NAME := sei510
TARGET_BOARD_INFO_FILE := device/amlogic/yukawa/board-info/board-info-sei510.txt

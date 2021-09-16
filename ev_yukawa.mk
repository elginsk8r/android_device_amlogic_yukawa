#
# Copyright (C) 2021 The Evervolv Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit device configuration
$(call inherit-product, device/amlogic/yukawa/yukawa.mk)

# Build type
ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
$(call inherit-product, $(SRC_EVERVOLV_DIR)/config/common_full_tablet_wifionly.mk)
else
TARGET_SCREEN_HEIGHT := 1080
TARGET_SCREEN_WIDTH := 1920

# TV Specific Packages
filter_packages := \
    LeanbackIME \
    LeanbackSampleApp \
    LiveTv \
    TvProvision \
    TVLauncherNoGms \
    TVRecommendationsNoGms \
    TvSampleLeanbackLauncher

$(foreach pkg, $(filter_packages), \
    $(eval PRODUCT_PACKAGES := $(patsubst $(pkg),,$(PRODUCT_PACKAGES))))

$(call inherit-product, $(SRC_EVERVOLV_DIR)/config/common_tv.mk)
endif

PRODUCT_NAME := ev_yukawa

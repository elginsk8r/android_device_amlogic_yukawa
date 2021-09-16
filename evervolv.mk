#
# Copyright (C) 2021 The Evervolv Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Build ty[e
ifeq ($(PRODUCT_IS_ATV), true)
$(call inherit-product, $(SRC_EVERVOLV_DIR)/config/common_tv.mk)
else
$(call inherit-product, $(SRC_EVERVOLV_DIR)/config/common_full_tablet_wifionly.mk)
endif

# Bootanimation
BOOT_ANIMATION_SIZE := 1080p

# Fingerprint
ifeq ($(PRODUCT_IS_ATV), true)
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=adt3 \
    PRIVATE_BUILD_DESC="adt3-user 12 STT1.211025.001.Z4 7928920 release-keys"

BUILD_FINGERPRINT := ADT-3/adt3/adt3:12/STT1.211025.001.Z4/7928920:user/release-keys
endif

#
# Copyright (C) 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# GLES
PRODUCT_PACKAGES += \
    libGLES_mesa \
    libEGL_mesa \
    libGLESv1_CM_mesa \
    libGLESv2_mesa \
    libgallium_dri \
    libglapi

TARGET_BUILD_MESA ?= false
ifneq ($(TARGET_BUILD_MESA), false)
   PRODUCT_SOONG_NAMESPACES += \
       external/mesa3d
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196608 \
    ro.hardware.egl=mesa

# Gralloc
$(call soong_config_set,minigbm,platform,meson)

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-service.minigbm \
    android.hardware.graphics.mapper@4.0-impl.minigbm

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.gralloc=minigbm

# Hardware composer
PRODUCT_PACKAGES += \
    com.android.hardware.graphics.composer.drm_hwcomposer

# Vulkan
PRODUCT_PACKAGES += \
    vulkan.panfrost

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml

PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.vulkan=panfrost

TARGET_USES_VULKAN := true

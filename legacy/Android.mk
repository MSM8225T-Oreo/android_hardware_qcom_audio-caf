#AUDIO_POLICY_TEST := true
#ENABLE_AUDIO_DUMP := true

LOCAL_PATH := $(call my-dir)

# Oreo compat: shadow the removed <cutils/log.h> / <utils/Log.h>.
LGC_COMPAT_INCLUDES := $(LOCAL_PATH)/../compat_headers

common_cflags := -D_POSIX_SOURCE
ifeq ($(strip $(AUDIO_FEATURE_ENABLED_FM)),true)
    common_cflags += -DQCOM_FM_ENABLED
endif
ifeq ($(strip $(QCOM_PROXY_DEVICE_ENABLED)),true)
    common_cflags += -DQCOM_PROXY_DEVICE_ENABLED
endif
ifeq ($(strip $(QCOM_OUTPUT_FLAGS_ENABLED)),true)
    common_cflags += -DQCOM_OUTPUT_FLAGS_ENABLED
endif

include $(CLEAR_VARS)

LOCAL_CFLAGS += $(common_cflags)

ifeq ($(BOARD_USES_STEREO_HW_SPEAKER),true)
    LOCAL_CFLAGS += -DWITH_STEREO_HW_SPEAKER
endif

ifeq ($(BOARD_HAVE_SAMSUNG_AUDIO),true)
    LOCAL_CFLAGS += -DSAMSUNG_AUDIO
endif

ifeq ($(BOARD_HAVE_SEMC_AUDIO),true)
    LOCAL_CFLAGS += -DSEMC_AUDIO
endif

# Oreo note: audio_hw_hal.cpp is deliberately NOT compiled here.
# hardware/libhardware_legacy (15.1) now builds libaudiohw_legacy with its
# own legacy_audio_module HAL adapter (audio_hw_hal.cpp) that calls
# createAudioHardware() provided by AudioHardware.cpp below. Compiling our
# cm-13-era copy would duplicate the HAL_MODULE_INFO_SYM (HMI) symbol.
LOCAL_SRC_FILES := \
    AudioHardware.cpp

LOCAL_SHARED_LIBRARIES := \
    libcutils       \
    libutils        \
    libmedia        \
    libaudioalsa

ifeq ($(BOARD_USES_QCOM_AUDIO_CALIBRATION),true)
    LOCAL_SHARED_LIBRARIES += libaudcal
    LOCAL_CFLAGS += -DWITH_QCOM_CALIBRATION
endif

LOCAL_SHARED_LIBRARIES += libdl

LOCAL_STATIC_LIBRARIES := \
    libmedia_helper \
    libaudiohw_legacy

LOCAL_MODULE := audio.primary.msm7x30

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE_TAGS := optional

LOCAL_CFLAGS += -fno-short-enums

LOCAL_C_INCLUDES := $(LGC_COMPAT_INCLUDES)
LOCAL_C_INCLUDES += hardware/libhardware/include
LOCAL_C_INCLUDES += hardware/libhardware_legacy/include
LOCAL_C_INCLUDES += system/core/include

LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

include $(BUILD_SHARED_LIBRARY)

# Note: the cm-13-era audio_policy.msm7x30 (USE_LEGACY_AUDIO_POLICY) block
# was removed. On Oreo the policy is generated from the XML configuration
# (USE_XML_AUDIO_POLICY_CONF) consumed by audioserver; a legacy policy HAL
# is not loaded for this generation.

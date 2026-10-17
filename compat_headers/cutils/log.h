/*
 * Oreo compatibility shim.
 *
 * system/core's include/cutils/log.h and include/utils/Log.h were removed
 * in Android O; liblog now exports <log/log.h>. This shim keeps the tree's
 * cm-13-era #include directives compiling without touching every source
 * file (see hardware/qcom/display-caf/compat_headers for the same shim).
 */
#include <log/log.h>

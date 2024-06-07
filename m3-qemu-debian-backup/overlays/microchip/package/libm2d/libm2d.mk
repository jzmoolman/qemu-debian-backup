################################################################################
#
# libm2d
#
################################################################################

LIBM2D_VERSION = v1.0.0
LIBM2D_SITE = $(call github,linux4sam,libm2d,$(LIBM2D_VERSION))
LIBM2D_LICENSE = MIT
LIBM2D_LICENSE_FILES = COPYING
LIBM2D_AUTORECONF = YES
LIBM2D_AUTORECONF_OPTS += -I $(HOST_DIR)/usr/share/autoconf-archive
LIBM2D_DEPENDENCIES = libdrm \
	host-pkgconf host-autoconf-archive
LIBM2D_INSTALL_STAGING = YES

LIBM2D_CONF_OPTS = \
	--disable-cairo

define LIBM2D_RUN_AUTOGEN
        cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
LIBM2D_POST_PATCH_HOOKS += LIBM2D_RUN_AUTOGEN

$(eval $(autotools-package))

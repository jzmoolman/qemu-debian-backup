/*
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * Copyright (c) 2020 Western Digital Corporation or its affiliates.
 *
 * Authors:
 *   Anup Patel <anup.patel@wdc.com>
 */

#include <sbi/sbi_console.h>
#include <sbi/sbi_error.h>
#include <sbi/sbi_scratch.h>
#include <sbi_utils/fdt/fdt_helper.h>
#include <sbi_utils/reset/fdt_reset.h>

extern struct fdt_reset fdt_poweroff_gpio;
extern struct fdt_reset fdt_reset_gpio;
extern struct fdt_reset fdt_reset_htif;
extern struct fdt_reset fdt_reset_sifive_test;
extern struct fdt_reset fdt_reset_sunxi_wdt;
extern struct fdt_reset fdt_reset_thead;

static struct fdt_reset *reset_drivers[] = {
	&fdt_poweroff_gpio,
	&fdt_reset_gpio,
	&fdt_reset_htif,
	&fdt_reset_sifive_test,
	&fdt_reset_sunxi_wdt,
	&fdt_reset_thead,
};

void fdt_reset_init(void)
{
	int pos, noff, rc;
	struct fdt_reset *drv;
	const struct fdt_match *match;
	void *fdt = fdt_get_address();

	for (pos = 0; pos < array_size(reset_drivers); pos++) {
		drv = reset_drivers[pos];

		noff = fdt_find_match(fdt, -1, drv->match_table, &match);
		if (noff < 0)
			continue;

		if (drv->init) {
			rc = drv->init(fdt, noff, match);
			if (rc && rc != SBI_ENODEV) {
				sbi_printf("%s: %s init failed, %d\n",
					   __func__, match->compatible, rc);
			}
		}
	}
}

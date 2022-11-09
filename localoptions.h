/*
 * Copyright © 2020-2022 Matt Robinson
 *
 * SPDX-License-Identifier: MIT
 */

// Disable server password auth as crypt() isn't available under Android
#define DROPBEAR_SVR_PASSWORD_AUTH 0

// Disable client password auth as getpass() isn't available under Android
#define DROPBEAR_CLI_PASSWORD_AUTH 0

// Speed up symmetrical ciphers and hashes at the expense of larger binaries
#define DROPBEAR_SMALL_CODE 0

// Build all but the most verbose level of trace messages into the binaries
#define DEBUG_TRACE 4

// Change the fallback list of shells to the non-standard Android shell path
#define COMPAT_USER_SHELLS "/system/bin/sh"

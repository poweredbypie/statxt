#include "fs.h"
#include "util.h"

// errno
#include <errno.h>
// strtod
#include <stdlib.h>
// strchr
#include <string.h>

#define SUPPLIES "/sys/class/power_supply/"
#define TYPE "Battery"

static bool check_supply(struct dirent* supply, struct stat* info) {
    bool success = false;
    if (!S_ISDIR(info->st_mode)) {
        return success;
    }

    cd_fatal(supply->d_name);
    char* type = file_to_str("type");
    // Error is already printed in the conversion func
    if (type == NULL) {
        err("Power device is missing sysfs attributes\n");
        goto cleanup;
    }

    if (strstr(type, "Battery") == NULL) {
        // Not a battery!
        goto cleanup;
    }

    char* charge_str = file_to_str("charge_now");
    char* full_str = file_to_str("charge_full");
    char* status = file_to_str("status");
    if ((charge_str == NULL) || (full_str == NULL) || (status == NULL)) {
        err("Battery device is missing sysfs attributes\n");
        goto cleanup;
    }

    // Get rid of the newline and anything after it.
    char* newline = strchr(status, '\n');
    if (newline != NULL) {
        newline[0] = 0;
    }

    double charge = strtod(charge_str, NULL);
    double full = strtod(full_str, NULL);

    // These values shouldn't be possible!
    if ((charge == 0.0) || (full == 0.0)) {
        goto cleanup;
    }

    printf("%.3lf%% (%s)\n", (charge / full) * 100.0, status);

    success = true;

cleanup:
    // I can free null pointers
    free(type);
    free(charge_str);
    free(full_str);
    free(status);
    cd_fatal(SUPPLIES);
    return success;
}

int main() {
    if (enum_dir(SUPPLIES, &check_supply)) {
        return 0;
    }
    else {
        // We couldn't find an appropriate battery device.
        return ENOENT;
    }
}

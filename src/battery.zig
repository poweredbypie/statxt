const out = @import("std").io.getStdOut().writer();

const linux = @import("linux");
const cstr = linux.cstr;
const sysfs = @import("sysfs.zig");
const util = @import("util.zig");

fn fileToNum(path: []const u8) ?f64 {
    if (util.fileToSlice(path)) |slice| {
        defer linux.mem.free(slice);
        return @intToFloat(f64, cstr.toInt(slice));
    }
    return null;
}

fn checkSupply(supply_type: []u8) bool {
    if (!cstr.contains(supply_type, "Battery")) {
        return false;
    }

    const charge_raw = fileToNum("charge_now");
    const full_raw = fileToNum("charge_full");
    const status_raw = util.fileToSlice("status");
    if (charge_raw == null or full_raw == null or status_raw == null) {
        return false;
    }
    const charge = charge_raw.?;
    const full = full_raw.?;
    const status = status_raw.?;

    // We want to ignore the newline in the status.
    const newline = cstr.find(status, '\n');
    if (newline == null) {
        return false;
    }
    status[newline.?] = 0;
    const percent = (charge / full) * 100.0;

    _ = linux.io.print("%.3lf%% (%s)\n", percent, status.ptr);

    return true;
}

pub fn printBattery() !void {
    try sysfs.enumClass("power_supply", checkSupply);
}

const linux = @import("linux");
const cstr = linux.cstr;
const io = linux.io;

const sysfs = @import("sysfs.zig");
const EnumError = sysfs.EnumError;

const util = @import("util.zig");

fn fileToNum(path: []const u8) ?f64 {
    const slice = util.fileToSlice(path) orelse return null;
    defer linux.mem.free(slice);
    return @intToFloat(f64, cstr.toInt(slice));
}

fn checkSupply(supply_type: []u8) bool {
    if (!cstr.contains(supply_type, "Battery")) {
        return false;
    }

    const charge = fileToNum("charge_now") orelse return false;
    const full = fileToNum("charge_full") orelse return false;
    const status = util.fileToSlice("status") orelse return false;

    // We want to ignore the newline in the status.
    const newline = cstr.find(status, '\n') orelse return false;
    // Truncate C string.
    status[newline] = 0;
    const percent = (charge / full) * 100.0;

    io.print("%.3lf%% (%s)\n", .{ percent, status.ptr });

    return true;
}

pub fn printBattery() void {
    sysfs.enumClass("power_supply", checkSupply) catch |err| switch (err) {
        EnumError.OpenDirFailed, EnumError.ChangeDirFailed => {
            io.eprint("IO error while searching batteries\n", .{});
        },
        EnumError.NoMatches => {
            io.eprint("Couldn't find a battery device\n", .{});
        },
    };
}

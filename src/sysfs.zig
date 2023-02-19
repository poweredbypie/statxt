const linux = @import("linux");
const mem = linux.mem;
const DirIter = linux.fs.DirIter;

const util = @import("util.zig");

const dbgout = @import("std").io.getStdOut().writer();

pub const EnumError = error {
    OpenDirFailed,
    ChangeDirFailed,
    NoMatches
};

fn cd(path: []const u8) EnumError!void {
    if (!linux.fs.cd(path)) {
        return EnumError.ChangeDirFailed;
    }
}

pub const EnumCallback = fn([]u8) bool;
pub fn enumClass(comptime class: []const u8, callback: *const EnumCallback) EnumError!void {
    const path = "/sys/class/" ++ class;

    // TODO: Is there better unwrap syntax?
    var dir = DirIter.init(path) orelse return EnumError.OpenDirFailed;
    defer dir.deinit();

    while (dir.next()) |entry| {
        // To avoid allocation, we change the cwd.
        // This can also be changed in the callback, so we cd each time.
        try cd(path);

        if (entry.name[0] == '.' or entry.type != .LINK) {
            // Ignore '.' and '..'
            continue;
        }

        try cd(&entry.name);

        if (util.fileToSlice("type")) |class_type| {
            defer mem.free(class_type);

            if (callback(class_type)) {
                return;
            }
        }
    }

    return EnumError.NoMatches;
}

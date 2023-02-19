const c = @import("../c.zig");

pub fn cd(path: []const u8) bool {
    return (c.chdir(path.ptr) == 0);
}

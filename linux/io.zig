const c = @import("c.zig");

pub fn print(comptime fmt: []const u8, args: anytype) void {
    _ = @call(.{}, c.printf, .{fmt.ptr} ++ args);
}

pub fn eprint(comptime fmt: []const u8, args: anytype) void {
    _ = @call(.{}, c.fprintf, .{ c.stderr, fmt.ptr } ++ args);
}

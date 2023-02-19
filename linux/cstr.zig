const c = @import("c.zig");

pub fn contains(str: []const u8, substr: []const u8) bool {
    return (c.strstr(str.ptr, substr.ptr) != null);
}

pub fn find(str: []const u8, char: u8) ?usize {
    const ptr = c.strchr(str.ptr, char) orelse return null;
    // This is kind of goofy but I think it's better than raw pointers.
    const idx = ptr - @ptrToInt(str.ptr);
    return @ptrToInt(idx);
}

pub fn toInt(str: []const u8) i32 {
    return @intCast(i32, c.strtol(str.ptr, null, 10));
}

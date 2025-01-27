const c = @import("c.zig");

pub fn alloc(comptime T: type, count: usize) ?[]T {
    const block = @as(?[*]T, @ptrCast(c.malloc(@sizeOf(T) * count))) orelse return null;
    return block[0..count];
}

pub fn free(slice_raw: ?[]u8) void {
    if (slice_raw) |slice| {
        c.free(slice.ptr);
    }
}

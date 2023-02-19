const c = @cImport({
    @cInclude("stdlib.h");
});

pub fn alloc(comptime T: type, count: usize) ?[]T {
    const block = @ptrCast(?[*]T, c.malloc(@sizeOf(T) * count)) orelse return null;
    return block[0..count];
}

pub fn free(slice_raw: ?[]anyopaque) void {
    if (slice_raw) |slice| {
        c.free(slice.ptr);
    }
}

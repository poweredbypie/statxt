const c = @cImport({
    @cInclude("stdlib.h");
});

pub fn alloc(comptime T: type, count: usize) ?[]T {
    if (@ptrCast(?[*]T, c.malloc(@sizeOf(T) * count))) |block| {
        return block[0..count];
    }

    return null;
}

pub fn free(slice_raw: ?[]anyopaque) void {
    if (slice_raw) |slice| {
        c.free(slice.ptr);
    }
}

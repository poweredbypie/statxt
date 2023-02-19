const c = @cImport({
    @cInclude("dirent.h");
    @cInclude("errno.h");
});

pub const EntryType = enum {
    BLOCK,
    CHAR,
    DIR,
    FIFO,
    LINK,
    REG,
    SOCK,
    UNKNOWN
};

pub const Entry = struct {
    name: [256]u8,
    type: EntryType
};

const Self = @This();

entry: c.dirent,
dir: *c.DIR,

pub fn init(path: []const u8) ?Self {
    if (c.opendir(path.ptr)) |dir| {
        return Self {
            .entry = undefined,
            .dir = dir
        };
    }

    return null;
}

pub fn next(self: *Self) ?Entry {
    if (c.readdir(self.dir)) |entry| {
        const entry_type = switch (entry.*.d_type) {
            c.DT_BLK => EntryType.BLOCK,
            c.DT_CHR => EntryType.CHAR,
            c.DT_DIR => EntryType.DIR,
            c.DT_FIFO => EntryType.FIFO,
            c.DT_LNK => EntryType.LINK,
            c.DT_REG => EntryType.REG,
            c.DT_SOCK => EntryType.SOCK,
            else => EntryType.UNKNOWN
        };

        return Entry {
            .name = entry.*.d_name,
            .type = entry_type
        };
    }

    return null;
}

pub fn deinit(self: *Self) void {
    _ = c.closedir(self.dir);
}

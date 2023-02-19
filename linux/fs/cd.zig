const c = @cImport({
    @cInclude("unistd.h");
});

pub fn cd(path: []const u8) bool {
    const status = c.chdir(path.ptr);
    return (status == 0);
}

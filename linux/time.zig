const c = @import("c.zig");

pub const Time = struct {
    const Self = @This();

    // This should be smaller but it's really annoying to cast between.
    second: i32,
    minute: i32,
    hour: i32,

    day: i32,
    month: i32,
    year: i32,

    pub fn now() ?Self {
        const ticks = c.time(null);
        if (ticks == -1) {
            return null;
        }

        const time = c.localtime(&ticks) orelse return null;

        return Self{
            .second = time.*.tm_sec,
            .minute = time.*.tm_min,
            .hour = time.*.tm_hour,
            .day = time.*.tm_mday,
            // For some reason this range is 0 - 11.
            .month = time.*.tm_mon + 1,
            // This starts at 1900.
            .year = time.*.tm_year + 1900,
        };
    }
};

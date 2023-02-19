const linux = @import("linux");
const io = linux.io;
const Time = linux.time.Time;

pub fn printDate() void {
    if (Time.now()) |now| {
        io.print("%02u.%02u.%04u", .{ now.day, now.month, now.year });
    } else {
        io.eprint("Couldn't retrieve current time", .{});
    }
}

pub fn printTime() void {
    if (Time.now()) |now| {
        io.print("%02u:%02u:%02u", .{ now.hour, now.minute, now.second });
    } else {
        io.eprint("Couldn't retrieve current time", .{});
    }
}

const std = @import("std");

pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardOptimizeOption(.{});

    const linux = b.createModule(.{ .root_source_file = b.path("linux/linux.zig") });

    const exe = b.addExecutable(.{
        .name = "statxt",
        .root_source_file = b.path("src/main.zig"),
        .optimize = mode,
        .target = target,
    });
    exe.root_module.addImport("linux", linux);
    exe.linkLibC();
    b.installArtifact(exe);
}

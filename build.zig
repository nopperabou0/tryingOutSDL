const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{ .os_tag = .linux, .cpu_arch = .x86_64, .abi = .gnu });
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "tryingOutSDL",
        .target = target,
        .optimize = optimize,
    });

    exe.addCSourceFiles(.{ .files = &.{"./main.c"}, .flags = &.{ "-Wall", "-Wextra", "-std=c99", "-pedantic", "-g3" } });

    exe.addIncludePath(b.path("."));

    exe.addObjectFile(b.path("lib/SDL3/libSDL3.so.0.2.8"));
    exe.addRPath(b.path("lib/SDL3"));

    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

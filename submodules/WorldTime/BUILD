load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "WorldTime",
    module_name = "WorldTime",
    srcs = glob([
		"Sources/**/*.swift",
    ]),
    copts = [
    ],
    deps = [
        "//submodules/SSignalKit/SwiftSignalKit:SwiftSignalKit",
        "//submodules/TelegramCore:TelegramCore",
    ],
    visibility = [
        "//visibility:public",
    ],
)
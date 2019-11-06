load("@bazel_gazelle//:def.bzl", "gazelle")

# Gazelle is used for automatically creating BUILD files and updating dependencies from go
# bazel run //:gazelle -- update
# bazel run //:gazelle -- update-repos https://github.com/link/to/repo/to/add
#
# gazelle:prefix github.com/MichiganDiningAPI
# gazelle:build_file_names BUILD,BUILD.bazel
gazelle(name = "gazelle")

load("@com_github_bazelbuild_buildtools//buildifier:def.bzl", "buildifier")

# Buildifier formats BUILD files
# bazel run //:buildifier
buildifier(name = "buildifier")

exports_files(["tsconfig.json"])


load("@build_bazel_rules_nodejs//:index.bzl", "npm_package")

npm_package(
    name = "mdining_ts_proto_package",
    srcs = ["package.json", ".npmignore"],
    deps = ["//proto:mdining_ts_proto"],
)

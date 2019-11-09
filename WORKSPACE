######################
# BUILD DEPENDENCIES #
######################
##
# http_archive rule
##
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
# load("//rules:deps.bzl", "load_dependencies")
# load_dependencies()

#####################
# BAZEL TOOLS RULES #
#####################

load("//rules:rule_deps.bzl", "rule_dependencies")
rule_dependencies()
load("//rules:proto_deps.bzl", "proto_dependencies")
proto_dependencies()
load("//rules:go_deps.bzl", "go_dependencies")
go_dependencies()

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")
grpc_deps()
load("@com_github_grpc_grpc//bazel:grpc_extra_deps.bzl", "grpc_extra_deps")
grpc_extra_deps()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies(go_sdk="go_sdk")
# Load and call dependencies
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")

rules_proto_dependencies()
rules_proto_toolchains()

# Load and call the dependencies
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()
go_register_toolchains()

load("@io_bazel_rules_closure//closure:defs.bzl", "closure_repositories")
closure_repositories()

load("@build_bazel_rules_nodejs//:defs.bzl", "yarn_install")

yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock"
)

load("@npm//:install_bazel_dependencies.bzl", "install_bazel_dependencies")
install_bazel_dependencies()

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories")
node_repositories(package_json = ["//:package.json"])

# Setup TypeScript toolchain
load("@npm_bazel_typescript//:index.bzl", "ts_setup_workspace")
ts_setup_workspace()

# Load and call dependencies
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")
protobuf_deps()

# Load and call dependencies
load("@com_googleapis_googleapis//:repository_rules.bzl", "switched_rules_by_language")
switched_rules_by_language(
    name = "com_google_googleapis_imports",
    gapic = True,
    go = True,
    grpc = True,
    java = False
)

# Load and call dependencies
load("@grpc_ecosystem_grpc_gateway//:repositories.bzl", "go_repositories")

go_repositories()

###############
# BAZEL TOOLS #
###############

##
# bazelbuild buildtools for formatting build files
##
http_archive(
    name = "com_github_bazelbuild_buildtools",
    strip_prefix = "buildtools-master",
    url = "https://github.com/bazelbuild/buildtools/archive/master.zip",
)
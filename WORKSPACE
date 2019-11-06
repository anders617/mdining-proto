#####################
# BAZEL TOOLS RULES #
#####################

##
# http_archive rule
##
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

##
# git_repository rule
##
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")






###############
# BUILD RULES #
###############

##
# rules_proto provides rules for building protocol buffer files
##
http_archive(
    name = "rules_proto",
    sha256 = "602e7161d9195e50246177e7c55b2f39950a9cf7366f74ed5f22fd45750cd208",
    strip_prefix = "rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
        "https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz",
    ],
)

# Load and call dependencies
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
rules_proto_dependencies()
rules_proto_toolchains()

##
# io_bazel_rules_go provides rules for buidling go libraries and executables
##
http_archive(
    name = "io_bazel_rules_go",
    urls = [
        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/rules_go/releases/download/v0.20.2/rules_go-v0.20.2.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.20.2/rules_go-v0.20.2.tar.gz",
    ],
    sha256 = "b9aa86ec08a292b97ec4591cf578e020b35f98e12173bbd4a921f84f583aebd9",
)

# Load and call the dependencies
load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
go_rules_dependencies()
go_register_toolchains()

##
# io_bazel_rules_closure - Included for com_github_grpc_web
##
http_archive(
    name = "io_bazel_rules_closure",
    sha256 = "fecda06179906857ac79af6500124bf03fe1630fd1b3d4dcf6c65346b9c0725d",
    strip_prefix = "rules_closure-03110588392d8c6c05b99c08a6f1c2121604ca27",
    urls = [
        "https://github.com/bazelbuild/rules_closure/archive/03110588392d8c6c05b99c08a6f1c2121604ca27.zip",
    ],
)

load("@io_bazel_rules_closure//closure:defs.bzl", "closure_repositories")

closure_repositories()


##
# build_stack_rules_proto - Included for grpc gateway bazel rules for protos
##
http_archive(
    name = "build_stack_rules_proto",
    sha256 = "c62f0b442e82a6152fcd5b1c0b7c4028233a9e314078952b6b04253421d56d61",
    strip_prefix = "rules_proto-b93b544f851fdcd3fc5c3d47aee3b7ca158a8841",
    urls = ["https://github.com/stackb/rules_proto/archive/b93b544f851fdcd3fc5c3d47aee3b7ca158a8841.tar.gz"],
)

##
# com_github_grpc_web - Included for generated grpc web proto files
##
git_repository(
    name = "com_github_grpc_web",
    commit = "8b501a96f427603ee600d3ff0291eff932fb54a1",
    remote = "https://github.com/grpc/grpc-web"
)

##
# build_bazel_rules_nodejs - Included for generating nodejs 
##
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "3d7296d834208792fa3b2ded8ec04e75068e3de172fae79db217615bd75a6ff7",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.39.1/rules_nodejs-0.39.1.tar.gz"],
)


load("@build_bazel_rules_nodejs//:defs.bzl", "yarn_install")
yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)

load("@npm//:install_bazel_dependencies.bzl", "install_bazel_dependencies")
install_bazel_dependencies()

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories")

node_repositories(package_json = ["//:package.json"])

# Setup TypeScript toolchain
load("@npm_bazel_typescript//:index.bzl", "ts_setup_workspace")
ts_setup_workspace()




###############
# BAZEL TOOLS #
###############

##
# bazel_gazelle for easily updating go dependency rules
##
http_archive(
    name = "bazel_gazelle",
    sha256 = "7fc87f4170011201b1690326e8c16c5d802836e3a0d617d8f75c3af2b23180c4",
    urls = [
        "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/bazel-gazelle/releases/download/0.18.2/bazel-gazelle-0.18.2.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/0.18.2/bazel-gazelle-0.18.2.tar.gz",
    ],
)

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

gazelle_dependencies()

##
# bazelbuild buildtools for formatting build files
##
http_archive(
    name = "com_github_bazelbuild_buildtools",
    strip_prefix = "buildtools-master",
    url = "https://github.com/bazelbuild/buildtools/archive/master.zip",
)





######################
# Protobuf Libraries #
######################

##
# com_google_protobuf contains the protoc compiler and c++ protocol buffer runtime
##
git_repository(
    name = "com_google_protobuf",
    commit = "6d4e7fd7966c989e38024a8ea693db83758944f1",
    remote = "https://github.com/protocolbuffers/protobuf",
    shallow_since = "1558721209 -0700",
)

# Load and call dependencies
load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")
protobuf_deps()

##
# com_googleapis_googleapis provides common proto definitions for Google APIs
##
git_repository(
    name = "com_googleapis_googleapis",
    commit = "fcbb13c4f84380c6546a1c78e44b241c3c8c13f4",
    remote = "https://github.com/googleapis/googleapis",
)

# Load and call dependencies
load("@com_googleapis_googleapis//:repository_rules.bzl", "switched_rules_by_language")
switched_rules_by_language(
    name = "com_google_googleapis_imports",
    gapic = True,
    go = True,
    grpc = True,
    java = False,
)

##
# com_google_api_codegen - Included for com_google_googleapis above 
##
http_archive(
    name = "com_google_api_codegen",
    strip_prefix = "gapic-generator-5aa30f3d6850c8ebc1092d17ef471aea27a81242",
    urls = ["https://github.com/googleapis/gapic-generator/archive/5aa30f3d6850c8ebc1092d17ef471aea27a81242.zip"],
)





################
# Go Libraries #
################

##
# org_golang_google_grpc - Go grpc runtime library
##
go_repository(
    name = "org_golang_google_grpc",
    build_file_proto_mode = "disable",
    importpath = "google.golang.org/grpc",
    sum = "h1:vb/1TCsVn3DcJlQ0Gs1yB1pKI6Do2/QNwxdKqmc/b0s=",
    version = "v1.24.0",
)

##
#  grpc_ecosystem_grpc_gateway - grpc gateway runtime library
##
go_repository(
    name = "grpc_ecosystem_grpc_gateway",
    importpath = "github.com/grpc-ecosystem/grpc-gateway",
    sum = "h1:h8+NsYENhxNTuq+dobk3+ODoJtwY4Fu0WQXsxJfL8aM=",
    version = "v1.11.3",
)

# Load and call dependencies
load("@grpc_ecosystem_grpc_gateway//:repositories.bzl", "go_repositories")
go_repositories()

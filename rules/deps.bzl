#####################
# BAZEL TOOLS RULES #
#####################

load("//rules:rule_deps.bzl", "rule_dependencies")

load("//rules:proto_deps.bzl", "proto_dependencies")

load("//rules:go_deps.bzl", "go_dependencies")

def load_dependencies():
    rule_dependencies()
    proto_dependencies()
    go_dependencies()


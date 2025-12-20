# Build docc documentation

# This invocation provides a stable scrach (build) directory location which allows repeated runs to 
# execute faster. This is useful when developing and debugging documentation generation compiler warnings.
#
# After building, a local web server is started to preview the documentation.

REPO_PATH="$(git rev-parse --show-toplevel)"
BUILD_PATH="$REPO_PATH/.build"
./build-docc.sh -w -s "$BUILD_PATH"
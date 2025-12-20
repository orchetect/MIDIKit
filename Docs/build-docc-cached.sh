# Build docc documentation

# This invocation provides a stable scrach (build) directory location which allows repeated runs to 
# execute faster. This is useful when developing and debugging documentation generation compiler warnings.
#
# After building, the built documentation folder is opened in the Finder.

REPO_PATH="$(git rev-parse --show-toplevel)"
BUILD_PATH="$REPO_PATH/.build"
./build-docc.sh -o -s "$BUILD_PATH"
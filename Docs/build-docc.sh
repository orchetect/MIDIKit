# Build docc documentation

# Arguments:
#
# [-s <path>]  Optionally supply a scratch path (a.k.a. build path).
#              Defaults to temporary directory, which is unique on every script execution.
#              To provide a stable scratch folder, supply this argument with the path to a directory
#              (absolute path, or relative path to the current working directory.)
#
#              For example, to use the default ".build" folder at the repo's root:
#              build-docc -s .build

# Swift-DocC Plugin Documentation:
# https://swiftlang.github.io/swift-docc-plugin/documentation/swiftdoccplugin/

PACKAGE_NAME="MIDIKit"

usageAndExit() { echo "$0 usage:" && grep "[[:space:]].)\ #" $0 | sed 's/#//' | sed -r 's/([a-z])\)/-\1/'; exit 0; }

while getopts "s::owh" flag; do
    case "${flag}" in
        s) # Optionally supply a scratch (build) directory path.
            BUILD_PATH="${OPTARG}"
            ;;
        o) # Open folder in the Finder after building.
            OPEN_FOLDER_IN_FINDER=1
            ;;
        w) # Start a local webserver to preview documentation after building.
            ALLOW_WEBSERVER=1
            ;;
        h) # Display help.
            usageAndExit
            ;;
    esac
done

# Provide default(s) for arguments
if [ "$OPEN_FOLDER_IN_FINDER" = "" ]; then OPEN_FOLDER_IN_FINDER=0; fi
if [ "$ALLOW_WEBSERVER" = "" ]; then ALLOW_WEBSERVER=0; fi

# Set up base paths
REPO_PATH="$(git rev-parse --show-toplevel)"
TEMP_WORKING_PATH="$(mktemp -d)"
DOCC_OUTPUT_WEBROOT="$TEMP_WORKING_PATH/docs-webroot"
DOCC_OUTPUT_PATH="$DOCC_OUTPUT_WEBROOT/$PACKAGE_NAME"

echo "Package Name: $PACKAGE_NAME"
echo "Repo Path: $REPO_PATH"
echo "Temporary Working Path: $TEMP_WORKING_PATH"
echo "DocC Output Path: $DOCC_OUTPUT_PATH"

# Create output folders
mkdir "$DOCC_OUTPUT_WEBROOT"
mkdir "$DOCC_OUTPUT_PATH"

cd "$REPO_PATH"

# Set up build paths
if [ "$BUILD_PATH" = "" ]; then BUILD_PATH="$TEMP_WORKING_PATH/build"; fi
echo "Scratch (Build) Path: $BUILD_PATH"
PLUGIN_OUTPUTS_PATH="$BUILD_PATH/plugins/Swift-DocC/outputs"

# Delete old docs from build folder, if any
if [ -d "$PLUGIN_OUTPUTS_PATH" ]; then
    echo "Removing old build products..."
    rm -r "$PLUGIN_OUTPUTS_PATH"
fi

# Custom env flag that opts-in to using the plugin as a Package dependency
export ENABLE_DOCC_PLUGIN=1

# --disable-indexing: Indexing is only relevant to IDEs like Xcode, and not relevant for hosting online
echo "Compiling docs..."
swift package \
  --scratch-path "$BUILD_PATH" \
  --disable-sandbox \
  --allow-writing-to-directory "$DOCC_OUTPUT_PATH" \
  generate-documentation \
  --target MIDIKit \
  --target MIDIKitCore \
  --target MIDIKitIO \
  --target MIDIKitSMF \
  --target MIDIKitSync \
  --target MIDIKitControlSurfaces \
  --target MIDIKitUI \
  --disable-indexing \
  --output-path "$DOCC_OUTPUT_PATH" \
  --transform-for-static-hosting \
  --enable-experimental-combined-documentation \
  --hosting-base-path "$PACKAGE_NAME"

# Reveal output folder in finder
if [ $OPEN_FOLDER_IN_FINDER == 1 ]; then
    echo "Opening built documentation in Finder."
    open "$DOCC_OUTPUT_PATH"
fi

# Start local webserver
if [ $ALLOW_WEBSERVER == 1 ]; then
    echo Starting localhost webserver on port 8080. Press Ctrl+C to end.
    echo Browse: http://localhost:8080/$PACKAGE_NAME/documentation/
    cd "$DOCC_OUTPUT_WEBROOT"
    ruby -run -ehttpd . -p8080
fi
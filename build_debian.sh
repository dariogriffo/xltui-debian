xltui_VERSION=$1
BUILD_VERSION=$2
ARCH=${3:-amd64}  # Default to amd64 if no architecture specified

if [ -z "$xltui_VERSION" ] || [ -z "$BUILD_VERSION" ]; then
    echo "Usage: $0 <xltui_version> <build_version> [architecture]"
    echo "Example: $0 0.0.3 1 arm64"
    echo "Example: $0 0.0.3 1 all    # Build for all architectures"
    echo "Supported architectures: amd64, arm64, all"
    exit 1
fi

# Function to map Debian architecture to xltui release name
get_xltui_release() {
    local arch=$1
    case "$arch" in
        "amd64")
            echo "xltui-v${xltui_VERSION}-linux-x64"
            ;;
        "arm64")
            echo "xltui-v${xltui_VERSION}-linux-arm64"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to build for a specific architecture
build_architecture() {
    local build_arch=$1
    local xltui_release

    xltui_release=$(get_xltui_release "$build_arch")
    if [ -z "$xltui_release" ]; then
        echo "❌ Unsupported architecture: $build_arch"
        echo "Supported architectures: amd64, arm64"
        return 1
    fi

    echo "Building for architecture: $build_arch using $xltui_release"

    # Clean up any previous builds for this architecture
    rm -rf "$xltui_release" || true
    rm -f "${xltui_release}.tar.gz" || true

    # Download and extract xltui binary for this architecture
    if ! wget "https://github.com/PDMLab/xltui/releases/download/v${xltui_VERSION}/${xltui_release}.tar.gz"; then
        echo "❌ Failed to download xltui binary for $build_arch"
        return 1
    fi

    # The tarball holds the bare xltui binary with no top-level directory.
    mkdir -p "$xltui_release"
    if ! tar -xf "${xltui_release}.tar.gz" -C "$xltui_release"; then
        echo "❌ Failed to extract xltui binary for $build_arch"
        return 1
    fi

    rm -f "${xltui_release}.tar.gz"

    # One package for every suite: xltui is a self-contained .NET single-file
    # app that dlopens whichever libicuNN it finds, so the per-suite builds
    # only differed in their libicu dependency. One alternation covering every
    # suite's ICU (see output/DEBIAN/control) replaces them. The fixed ~griffo
    # keeps it below the distro's own build of the same version.
    FULL_VERSION="$xltui_VERSION-${BUILD_VERSION}~griffo_${build_arch}"
    echo "  Building $FULL_VERSION"

    if ! docker build . -t "xltui-$build_arch" \
        --build-arg xltui_VERSION="$xltui_VERSION" \
        --build-arg BUILD_VERSION="$BUILD_VERSION" \
        --build-arg FULL_VERSION="$FULL_VERSION" \
        --build-arg ARCH="$build_arch" \
        --build-arg XLTUI_RELEASE="$xltui_release"; then
        echo "❌ Failed to build Docker image for $build_arch"
        return 1
    fi

    id="$(docker create "xltui-$build_arch")"
    if ! docker cp "$id:/xltui_$FULL_VERSION.deb" - > "./xltui_$FULL_VERSION.deb"; then
        echo "❌ Failed to extract .deb package for $build_arch"
        return 1
    fi

    if ! tar -xf "./xltui_$FULL_VERSION.deb"; then
        echo "❌ Failed to extract .deb contents for $build_arch"
        return 1
    fi

    # Clean up extracted directory
    rm -rf "$xltui_release" || true

    echo "✅ Successfully built for $build_arch"
    return 0
}

# Main build logic
if [ "$ARCH" = "all" ]; then
    echo "🚀 Building xltui $xltui_VERSION-$BUILD_VERSION for all supported architectures..."
    echo ""

    # All supported architectures
    ARCHITECTURES=("amd64" "arm64")

    for build_arch in "${ARCHITECTURES[@]}"; do
        echo "==========================================="
        echo "Building for architecture: $build_arch"
        echo "==========================================="

        if ! build_architecture "$build_arch"; then
            echo "❌ Failed to build for $build_arch"
            exit 1
        fi

        echo ""
    done

    echo "🎉 All architectures built successfully!"
    echo "Generated packages:"
    ls -la xltui_*.deb
else
    # Build for single architecture
    if ! build_architecture "$ARCH"; then
        exit 1
    fi
fi

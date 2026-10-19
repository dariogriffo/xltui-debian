![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/dariogriffo/xltui-debian/total)
![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/dariogriffo/xltui-debian/latest/total)
![GitHub Release](https://img.shields.io/github/v/release/dariogriffo/xltui-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/dariogriffo/xltui-debian)

<h1>
   <p align="center">
     <a href="https://xltui.org/"><img src="https://github.com/dariogriffo/xltui-debian/blob/main/xltui-logo.png" alt="xltui Logo" width="128" style="margin-right: 20px"></a>
     <a href="https://www.debian.org/"><img src="https://github.com/dariogriffo/xltui-debian/blob/main/debian-logo.png" alt="Debian Logo" width="104" style="margin-left: 20px"></a>
     <br>xltui for Debian
   </p>
</h1>
<p align="center">
 minimal Terminal UI for Excel files written in .NET.
</p>

# xltui for Debian

This repository contains build scripts to produce the _unofficial_ Debian packages
(.deb) for [xltui](https://github.com/PDMLab/xltui/) hosted at [deb.griffo.io](https://deb.griffo.io)

Currently supported Debian distros are:
- Bookworm (v12)
- Trixie (v13)
- Forky (v14)
- Sid (testing)

Currently supported Ubuntu distros are:
- Jammy (22.04)
- Noble (24.04)
- Questing (25.10)
- Resolute (26.04)

One package per architecture serves every suite: xltui loads whichever ICU
library the system ships (libicu70 to libicu78).

Thanks to @ranjithrajv

Supported architectures:
- amd64 (x86_64)
- arm64 (aarch64)

This is an unofficial community project to provide a package that's easy to
install on Debian. If you're looking for the xltui source code, see
[xltui](https://github.com/PDMLab/xltui/).

## Install/Update

### The Debian way

> ⚠️ **apt access requires a yearly subscription**
> ([deb.griffo.io](https://deb.griffo.io)). To use this tool for free, download
> the .deb from the [Releases](https://github.com/dariogriffo/xltui-debian/releases) page
> and install it manually (see below).

```sh
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://deb.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/deb.griffo.io.gpg
echo "deb [signed-by=/etc/apt/keyrings/deb.griffo.io.gpg] https://deb.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/deb.griffo.io.list
sudo apt update
sudo apt install -y xltui
```

### Manual Installation

1. Download the .deb package for your architecture available on
   the [Releases](https://github.com/dariogriffo/xltui-debian/releases) page.
2. Install the downloaded .deb package.

```sh
sudo apt install ./<filename>.deb
```
## Updating

To update to a new version, just follow any of the installation methods above. There's no need to uninstall the old version; it will be updated correctly.

## Building

### Build for single architecture
```sh
./build.sh <xltui_version> <build_version> <architecture>
# Example: ./build.sh 0.0.3 1 arm64
```

### Build for all architectures
```sh
./build.sh <xltui_version> <build_version> all
# Example: ./build.sh 0.0.3 1 all
```

## Roadmap

- [x] Produce a .deb package on GitHub Releases
- [x] Set up a debian mirror for easier updates
- [x] Multi-architecture support (amd64, arm64)

## Disclaimer

- This repo is not open for issues related to xltui. This repo is only for _unofficial_ Debian packaging.

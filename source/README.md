# checkpack

Tiny library to check if a system package is already installed.

Contributions are welcome.

[!["Buy Me A Beer"](https://www.buymeacoffee.com/assets/img/custom_images/yellow_img.png)](https://www.buymeacoffee.com/EchoPouet)

## Installation

Install `checkpack` with [Nimble](https://github.com/nim-lang/nimble):

```bash
$ nimble install -y checkpack
```

Add Norm to your .nimble file:

```nim
requires "checkpack"
```

## Usage

It's very simple. See following code:

```nim
import checkpack

if not checkPack("git"):
    echo "Git not found"
```

## Package manager support
The supported package manager are following:

* Windows:
  * [Chocolatey](https://chocolatey.org/)
* Linux:
  * YUM
  * DPKG
  * RPM
  * PACMAN
* MacOSX:
  * [Homebrew](https://brew.sh/index_fr)
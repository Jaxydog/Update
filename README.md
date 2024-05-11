# Update

My update script, intended for Ubuntu 22.04.

This script automatically updates:
- `apt` packages (with `autoremove -y`).
- `rustup` itself, and installed toolchains.
- Installed `cargo` applications.
    - Updated with [cargo-update](https://crates.io/crates/cargo-update).
- `snap` projects.
- `tldr` cache.
- A global [Gradle](https://gradle.org) installation.

This is intended to be as easy as possible to extend. If an update 'group' is not listed here, it should be easy to add.

### Usage

Currently, Update does not have any command-line flags. They may be added later on if deemed necessary.

```sh
$ ./src/update.sh
```

You may 'pin' specific sections by inserting their names into the `~/.update_pinned` file, like so:

```
snap
gradle
```

### License

Update is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Update is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Update, within [LICENSE](./LICENSE). If not, see <[https://www.gnu.org/licenses/](https://www.gnu.org/licenses/)>.

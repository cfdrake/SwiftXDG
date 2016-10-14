# SwiftXDG

Building a command line application in Swift? 🐦 Be a good UNIX citizen!

The [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
specifies where user-specific configuration, data, cache, and runtime files should live and how applications should
discover them.

This library is meant to be a no-dependency, simple to use implementation of this standard.

## Example Usage

Say you are building an application, `myapp`, and you'd like to load the user's configuration file, if it exists.
Using `SwiftXDG`, you would simply write the following:

```swift
import SwiftXDG

if let config = XDG.readFile(type: .config, path: "myapp/myapp.conf") {
    // Found it! Parse configuration file, etc.  
}
```

Under the hood, `SwiftXDG` will consult `$XDG_CONFIG_HOME`, `$XDG_CONFIG_DIRS`, provide fallbacks if needed, and
return the contents of the first matching file on the user's system (if one exists). For most users, this will be
the file at `~/.config/myapp/myapp.conf`, with a fallback to the potentially system-provided `/etc/xdg/myapp/myapp.conf`.

## Installation

### Swift Package Manager

Add the following line to the `dependencies` section of your `Package.swift`:

```swift
.Package(url: "https://github.com/cfdrake/SwiftXDG", majorVersion: 0, minorVersion: 1)
```

## API

### Get XDG Preferences

The following properties, exposing the user's XDG directories, are exposed:

```swift
XDG.configHome   // the value of $XDG_CONFIG_HOME
XDG.dataHome     // the value of $XDG_DATA_HOME
XDG.cacheHome    // the value of $XDG_CACHE_HOME
XDG.runtimeDir   // the value of $XDG_RUNTIME_DIR
XDG.configDirs   // the value of $XDG_CONFIG_DIRS (list)
XDG.dataDirs     // the value of $XDG_DATA_DIRS (list)
```

If the values retrieved from the environment are not absolute paths, a fallback is returned.

### Find a file path

`SwiftXDG` queries are formed of two parts: the base directory to search (an `XDGBaseDirectory` enum value),
and the relative path from that directory (a `String`). The base directory enum may have the value of `.config`,
`.data`, `.cache`, or `.runtime`.

```swift
let path: String? = XDG.find(type: .config, path: "myapp/myapp.conf")
```

### Find a file

```swift
let handle: FileHandle? = XDG.findFile(type: .config, path: "myapp/myapp.conf")
```

### Read a file

```swift
let contents: String? = XDG.readFile(type: .config, path: "myapp/myapp.conf")
```

## License

`SwiftXDG` is under the MIT license. Please see the `LICENSE` file for more details.

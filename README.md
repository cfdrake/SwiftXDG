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

## API Documentation

TODO.

## License

`SwiftXDG` is under the MIT license. Please see the `LICENSE` file for more details.

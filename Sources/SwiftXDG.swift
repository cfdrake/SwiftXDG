import Foundation

// MARK: Types

/// Represents an XDG base directory type.
public enum XDGBaseDirectory {
    case config, data, cache, runtime
}

/// A directory search environment.
public struct XDGDirectories {
    /// The value of $XDG_CONFIG_HOME, if it is an absolute path.
    public let configHome: String

    /// The value of $XDG_DATA_HOME, if it is an absolute path.
    public let dataHome: String

    /// The value of $XDG_CACHE_HOME, if it is an absolute path.
    public let cacheHome: String

    /// The value of $XDG_RUNTIME_DIR, if it is an absolute path.
    public let runtimeDir: String

    /// The value of $XDG_CONFIG_DIRS, filtered to only include absolute paths.
    public let configDirs: [String]

    /// The value of $XDG_DATA_DIRS, filtered to only include absolute paths.
    public let dataDirs: [String]

    init() {
        configHome = getPath("XDG_CONFIG_HOME")  ?? joinHome(".config")
        dataHome   = getPath("XDG_DATA_HOME")    ?? joinHome(".local/share")
        cacheHome  = getPath("XDG_CACHE_HOME")   ?? joinHome(".cache")
        runtimeDir = getPath("XDG_RUNTIME_DIR")  ?? NSTemporaryDirectory()
        configDirs = getPaths("XDG_CONFIG_DIRS") ?? ["/etc/xdg"]
        dataDirs   = getPaths("XDG_DATA_DIRS")   ?? ["/usr/local/share", "/usr/share"]
    }

    fileprivate func _find(dirs: [String], path: String) -> String? {
        let paths = dirs.map { join([$0, path]) }
        return paths.first(where: FileManager.default.fileExists)
    }

    /// Finds the first existing file path under the given XDG base directory type.
    public func find(type: XDGBaseDirectory, path: String) -> String? {
        switch type {
        case .config:
            return _find(dirs: [configHome] + configDirs, path: path)
        case .data:
            return _find(dirs: [dataHome] + dataDirs, path: path)
        case .cache:
            return _find(dirs: [cacheHome], path: path)
        case .runtime:
            return _find(dirs: [runtimeDir], path: path)
        }
    }
}

/// Default instance.
public let XDG = XDGDirectories()

// MARK: Private Helpers

fileprivate extension Optional {
    fileprivate func require(_ predicate: (Wrapped) -> Bool) -> Optional<Wrapped> {
        guard let value = self else {
            return nil
        }
        return predicate(value) ? self : nil
    }
}

fileprivate func isAbsolute(path: String) -> Bool {
    return path.characters.first == "/"
}

fileprivate func getPath(_ varName: String) -> String? {
    return ProcessInfo().environment[varName].require(isAbsolute)
}

fileprivate func getPaths(_ varName: String) -> [String]? {
    return ProcessInfo().environment[varName]?
        .characters
        .split(separator: ":")
        .map(String.init)
        .filter(isAbsolute)
}

fileprivate func join(_ dirs: [String]) -> String {
    return NSString.path(withComponents: dirs)
}

fileprivate func joinHome(_ path: String) -> String {
    return join([NSHomeDirectory(), path])
}

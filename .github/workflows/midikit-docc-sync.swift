//
//  midikit-docc-sync.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Globals

let fm = FileManager.default

func shell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/zsh")
    task.standardInput = nil
    
    try task.run() // <--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

func info(_ msg: String) {
    print(msg)
}

func success(_ msg: String, strong: Bool = false) {
    // not sure why but the extra space is needed for the grey tickmark or it appears without a
    // trailing space
    print((strong ? "✅" : "☑️ ") + " " + msg)
}

func warn(_ msg: String, with error: Error? = nil) {
    if let error = error {
        print("🚩 \(msg) -", error)
    } else {
        print("🚩 \(msg)")
    }
}

func exit(_ msg: String, with error: Error? = nil) -> Never {
    if let error = error {
        print("🛑 \(msg) -", error)
    } else {
        print("🛑 \(msg)")
    }
    exit(1)
}

extension URL {
    static func + (lhs: Self, rhs: String) -> Self {
        lhs.appendingPathComponent(rhs)
    }
    
    static func += (lhs: inout Self, rhs: String) {
        lhs.appendPathComponent(rhs)
    }
    
    /// Read file contents as lines. Errors are fatal.
    func readUTF8Lines() -> [Substring] {
        readUTF8()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "\n", omittingEmptySubsequences: false)
    }
    
    func readUTF8() -> String {
        do {
            return try String(contentsOf: self, encoding: .utf8)
        } catch {
            exit("Error while reading textual file contents of \(self)", with: error)
        }
    }
    
    /// Write file contents. Errors are fatal.
    func writeUTF8Contents(_ lines: [Substring]) {
        writeUTF8Contents(
            lines
                .joined(separator: "\n")
        )
    }
    
    /// Write file contents. Errors are fatal.
    func writeUTF8Contents(_ content: String) {
        do {
            try content.write(to: self, atomically: false, encoding: .utf8)
        } catch {
            exit("Error while writing textual file contents of \(self)", with: error)
        }
    }
    
    func trashItem(
        successMessage: String? = nil,
        errorMessage: String,
        errorIsFatal: Bool
    ) {
        do {
            try fm.trashItem(at: self, resultingItemURL: nil)
            if let successMessage = successMessage { success(successMessage) }
        } catch {
            guard !errorIsFatal else { exit(errorMessage, with: error) }
            warn(errorMessage, with: error)
        }
    }
    
    func fileExists() -> Bool {
        fm.fileExists(atPath: path)
    }
}

extension StringProtocol {
    /// **OTCore 1.4.2:**
    /// Returns an array of RegEx matches
    @available(macOS 10.7, *)
    public func regexMatches(
        pattern: String,
        options: NSRegularExpression.Options = [],
        matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
    ) -> [String] {
        do {
            let regex = try NSRegularExpression(
                pattern: pattern,
                options: options
            )
            
            func runRegEx(in source: String) -> [NSTextCheckingResult] {
                regex.matches(
                    in: source,
                    options: matchesOptions,
                    range: NSMakeRange(0, nsString.length)
                )
            }
            
            let nsString: NSString
            let results: [NSTextCheckingResult]
            
            switch self {
            case let _self as String:
                nsString = _self as NSString
                results = runRegEx(in: _self)
                
            default:
                let stringSelf = String(self)
                nsString = stringSelf as NSString
                results = runRegEx(in: stringSelf)
            }
            
            return results.map { nsString.substring(with: $0.range) }
            
        } catch {
            return []
        }
    }
    
    /// **OTCore 1.4.2:**
    /// Returns a string from a tokenized string of RegEx matches
    @available(macOS 10.7, *)
    public func regexMatches(
        pattern: String,
        replacementTemplate: String,
        options: NSRegularExpression.Options = [],
        matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds],
        replacingOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
    ) throws -> String {
        let regex = try NSRegularExpression(
            pattern: pattern,
            options: options
        )
            
        func runRegEx(in source: String) -> String {
            regex.stringByReplacingMatches(
                in: source,
                options: replacingOptions,
                range: NSMakeRange(0, source.count),
                withTemplate: replacementTemplate
            )
        }
            
        let result: String
            
        switch self {
        case let _self as String:
            result = runRegEx(in: _self)
            
        default:
            let stringSelf = String(self)
            result = runRegEx(in: stringSelf)
        }
            
        return result
    }
}

extension String {
    func trailingSlash() -> String {
        suffix(1) == "/" ? self : self + "/"
    }
    
    func printIfNotEmpty() {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { print(trimmed) }
    }
}

extension Bool {
    var emoji: String { self ? "✅" : "⚠️" }
}

/// Executes rsync with the given arguments.
func sync(
    operationName: String,
    sourceFolder src: URL,
    destFolder dest: URL,
    excludePattern: String? = nil,
    mirror: Bool = true,
    dryRun: Bool = false
) {
    guard fm.fileExists(atPath: src.path) else {
        info("Nothing to sync for \(operationName).")
        return // continue forEach { }
    }
    
    do {
        // rsync needs folder paths to end with a trailing /
        let srcPath = src.path.trailingSlash()
        let destPath = dest.path.trailingSlash()
        
        var shellComponents: [String] = ["rsync"]
        if dryRun { shellComponents.append("--dry-run") }
        if Options.debugMode {
            shellComponents.append("-acvvW") // additionally verbose mode -vv
        } else {
            shellComponents.append("-acW")
        }
        if mirror { shellComponents.append("--delete") }
        if let excludePattern {
            shellComponents.append("--exclude \(excludePattern)")
        }
        shellComponents.append("\"\(srcPath)\"")
        shellComponents.append("\"\(destPath)\"")
        
        let shellCmd = shellComponents.joined(separator: " ")
        
        let output = try shell(shellCmd)
        output.printIfNotEmpty()
        success("Synced \(operationName)")
    } catch {
        exit("Unable to sync \(operationName)", with: error)
    }
}

// MARK: - Params

enum Options {
    static var debugMode = false
    static let deleteDestinationFirst = false
}

struct Package {
    let name: String
    
    let base: URL
    
    /// Returns Sources folder without validation.
    var sources: URL { base + "Sources" }
    
    /// Inits without validation.
    init(name: String, base: URL) {
        self.name = name
        self.base = base
    }
    
    func validate() {
        guard isValid() else {
            exit("Package does not exist or is not valid Swift package: \(base)")
        }
    }
    
    func isValid() -> Bool {
        let pkgSwift = base + "Package.swift"
        let sources = sources
        
        return pkgSwift.fileExists() && sources.fileExists()
    }
}

protocol Target {
    var name: String { get }
}

extension Target {
    /// Returns target base folder with validation.
    var base: URL { package.sources + name }
    
    /// Returns docc folder with validation.
    var docc: URL { base + "\(name).docc" }
    
    /// Returns docc Resources folder without validation.
    var doccResources: URL { docc + "Resources" }
    
    /// Creates resources folder if it's missing and returns the URL.
    var doccResourcesGuaranteed: URL {
        let url = doccResources
        
        if !fm.fileExists(atPath: url.path) {
            do {
                try fm.createDirectory(at: url, withIntermediateDirectories: false)
            } catch {
                exit("Could not create Resources folder \(url)")
            }
        }
        
        return url
    }
    
    func validate() {
        guard isValid() else {
            exit("Target \(name) is not valid.")
        }
        
        if !doccResources.fileExists() {
            warn("Target \(name) Resources folder does not exist.")
        }
    }
    
    func isValid() -> Bool {
        base.fileExists() && docc.fileExists()
    }
}

struct MainTarget: Target {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct SubTarget: Target {
    let name: String
    
    var nonResourceFilesToDeleteAtDestination: [String]
    var regexOperations: [RegexOperation]
    
    var doccInMainTarget: URL { mainTarget.docc + name }
    var doccResourcesInMainTarget: URL { doccInMainTarget + "Resources" }
    
    init(
        name: String,
        nonResourceFilesToDeleteAtDestination: [String] = [],
        regexOperations: [RegexOperation] = []
    ) {
        self.name = name
        self.nonResourceFilesToDeleteAtDestination = nonResourceFilesToDeleteAtDestination
        self.regexOperations = regexOperations
    }
    
    func trashDestinationInMainTargetDocC() {
        let dest = doccInMainTarget
        if fm.fileExists(atPath: dest.path) {
            guard fm.isDeletableFile(atPath: dest.path) else {
                exit("Unable to delete existing destination. May be read-only: \(dest)")
            }
            dest.trashItem(
                errorMessage: "Unable to delete existing destination: \(dest)",
                errorIsFatal: true
            )
        }
    }
    
    func filesAtDestination(matching isIncluded: (_ fileName: String) -> Bool) -> [URL] {
        let dest = doccInMainTarget
        do {
            return try fm.contentsOfDirectory(
                at: dest,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: []
            )
            .filter { isIncluded($0.lastPathComponent) }
        } catch {
            exit("Error while getting file listing for \(dest)", with: error)
        }
    }
    
    func filesAtDestination(matching findMask: String) -> [URL] {
        let dest = doccInMainTarget
        
        let cmd = "find \"\(dest.path)\" -name \"\(findMask)\" -type f"
        do {
            let result = try shell(cmd)
            let paths = result.split(separator: "\n", omittingEmptySubsequences: true)
            let urls = paths.map { URL(fileURLWithPath: String($0)) }
            return urls
        } catch {
            return []
        }
    }
    
    func fileAtDestination(relativePath: String) -> URL {
        let pathComponents = relativePath
            .trimmingCharacters(in: CharacterSet(["/"]))
            .split(separator: "/")
            .map { String($0) }
        
        return pathComponents.reduce(doccInMainTarget) { $0 + $1 }
    }
    
    func trashNonResourceFilesToDeleteAtDestination() {
        let dest = doccInMainTarget
        for filename in nonResourceFilesToDeleteAtDestination {
            let url = dest + filename
            if fm.fileExists(atPath: url.path) {
                url.trashItem(
                    successMessage: "Deleted \(url)",
                    errorMessage: "Error while attempting to delete \(url)",
                    errorIsFatal: false
                )
            }
        }
    }
}

struct RegexOperation {
    enum FileMatching {
        case findMask(String)
        case relativePath(String)
    }

    let fileMask: FileMatching
    let pattern: String
    let replacementTemplate: String
}

// MARK: - Command Line

guard (2 ... 3).contains(CommandLine.arguments.count) else {
    exit(
        """
        Invalid arguments.
        
        Expected:
            swift script.swift <path to package root folder> [-debug]
        
        ie:
            swift script.swift .
            swift script.swift /Users/user/Desktop/Package/
            swift script.swift /Users/user/Desktop/Package/ -debug
        """
    )
}

let packagePathArg = CommandLine.arguments[1]
guard fm.fileExists(atPath: packagePathArg) else {
    exit("Path does not exist: \(packagePathArg)")
}

if CommandLine.arguments.count == 3 {
    let arg = CommandLine.arguments[2]
    switch arg {
    case "-debug":
        Options.debugMode = true
    default:
        exit("Unrecognized argument: \(arg)")
    }
}

// MARK: - Script

let package = Package(
    name: "MIDIKit",
    base: URL(fileURLWithPath: packagePathArg)
)

let mainTarget = MainTarget(name: "MIDIKit")

let subTargets: [SubTarget] = [
    "MIDIKitCore",
    "MIDIKitIO",
    "MIDIKitUI",
    "MIDIKitControlSurfaces",
    "MIDIKitSMF",
    "MIDIKitSync"
].map {
    SubTarget(
        name: $0,
        nonResourceFilesToDeleteAtDestination: [
            "Internals-From-MIDIKitCore.md"
        ],
        regexOperations: [
            .init(
                fileMask: .findMask("*.md"),
                pattern: "\n" + "- <doc:Internals-From-MIDIKitCore>",
                replacementTemplate: ""
            )
        ]
    )
}

info("Using sub-targets: \(subTargets.map { $0.name }.joined(separator: " "))")

info("\(package.name) package located at \(package.base)")

info("\(package.name).docc found at \(mainTarget.docc)")

func syncSubTargetsToMainTarget() {
    if Options.deleteDestinationFirst {
        info("Deleting existing sub-target folders from main target if present.")
        
        subTargets.forEach { st in
            st.trashDestinationInMainTargetDocC()
        }
    }
    
    info("Syncing sub-targets to main target.")
    
    subTargets.forEach { st in
        // copy each submodule's docc into main docc
        let src = st.docc
        let dest = st.doccInMainTarget
        
        sync(
            operationName: "Sync \(st.name) docc to main docc",
            sourceFolder: src,
            destFolder: dest,
            excludePattern: "Resources/",
            mirror: true
        )
    }
}

/// Sync all contents of each copied submodule docc folder’s Resources subfolder into main docc
// Resources folder if the submodule's Resources folder exists.
func syncSubTargetResourcesToMainTargetResources() {
    info("Syncing sub-targets resources to main target resources.")
    
    subTargets.forEach { st in
        let src = st.doccResources
        let dest = mainTarget.doccResourcesGuaranteed
            .appendingPathComponent(st.name)
        
        sync(
            operationName: "Sync \(st.name) docc resources to main docc resources",
            sourceFolder: src,
            destFolder: dest,
            excludePattern: nil,
            mirror: true
        )
        
        guard fm.fileExists(atPath: src.path) else {
            info("No resources to copy for \(st.name).")
            return // continue forEach { }
        }
    }
}

/// Rewrite the first line of each sub-target's root .md file to remove double backticks.
///
/// ie: in file SubTarget.md, first line
///
///     ``SubTarget``
///
/// becomes:
///
///     SubTarget
func updateSubTargetRootFiles() {
    info("Rewriting sub-target root file headers.")
    
    subTargets.forEach { st in
        let rootMD = st.doccInMainTarget + (st.name + ".md")
        guard fm.fileExists(atPath: rootMD.path) else {
            return // continue forEach { }
        }
        
        var fileLines = rootMD.readUTF8Lines()
        
        guard let firstLine = fileLines.first,
              !firstLine.isEmpty
        else {
            warn("\(st.name) root .md file is empty. Unable to rewrite file header.")
            return // continue forEach { }
        }
        
        let modifiedFirstLine = "# \(st.name)"
        
        if firstLine == modifiedFirstLine {
            info("\(st.name) root .md file header already patched.")
            return // continue forEach { }
        }
        
        guard firstLine.starts(with: "# ``\(st.name)``") else {
            warn("\(st.name) root .md file header is not as expected. Aborting file modification.")
            return // continue forEach { }
        }
        
        fileLines.removeFirst()
        fileLines.insert(Substring(modifiedFirstLine), at: 0)
        
        rootMD.writeUTF8Contents(fileLines)
        
        success("Rewrote \(st.name) root file header")
    }
}

/// Rewrite .md symbol extension files' first line to use main target as root target name.
///
/// ie: first line
///
///     ``SubTarget/SomeSymbol``
///
/// becomes:
///
///     ``MainTarget/SomeSymbol``
func updateSymbolExtensionFiles() {
    info("Rewriting sub-target symbol extension file headers.")
    
    subTargets.forEach { st in
        let mdFiles: [URL] = st.filesAtDestination { $0.hasSuffix(".md") }
        
        // print(mdFiles.map { "\($0)" }.joined(separator: "\n"))
        for mdFile in mdFiles {
            var fileLines = mdFile.readUTF8Lines()
            
            guard let firstLine = fileLines.first,
                  !firstLine.isEmpty
            else { continue }
            
            var shouldRewriteFileContents = false
            
            let modifiedFirstLinePrefix = "# ``\(mainTarget.name)/"
            
            guard !firstLine.starts(with: modifiedFirstLinePrefix) else {
                info("\(st.name) file header for \(mdFile) already patched.")
                continue
            }
            
            let symbolExtensionPrefix = "# ``\(st.name)/"
            if firstLine.starts(with: symbolExtensionPrefix) {
                let modifiedLine = firstLine.replacingOccurrences(
                    of: symbolExtensionPrefix,
                    with: modifiedFirstLinePrefix
                )
                fileLines.removeFirst()
                fileLines.insert(Substring(modifiedLine), at: 0)
                
                shouldRewriteFileContents = true
            }
            
            if shouldRewriteFileContents {
                mdFile.writeUTF8Contents(fileLines)
                success("Rewrote \(st.name) file header for \(mdFile)")
            }
        }
    }
}

func processRegexOperations() {
    info("Processing RegEx operations.")
    
    subTargets.forEach { st in
        for regExOp in st.regexOperations {
            let files: [URL] = {
                switch regExOp.fileMask {
                case let .findMask(mask):
                    return st.filesAtDestination(matching: mask)
                case let .relativePath(relPath):
                    return [st.fileAtDestination(relativePath: relPath)]
                }
            }()
            
            for file in files {
                guard fm.fileExists(atPath: file.path) else {
                    warn("File not found while processing RegEx: \(file)")
                    continue
                }
                
                let fileContents = file.readUTF8()
                
                // first check to see if there are any matches for the RegEx pattern
                let numberOfMatches = fileContents
                    .regexMatches(pattern: regExOp.pattern)
                    .count
                
                guard numberOfMatches > 0 else {
                    // info("Skipping processing RegEx for \(file) - no pattern matches were
                    // found.")
                    continue
                }
                
                guard let replaced = try? fileContents.regexMatches(
                    pattern: regExOp.pattern,
                    replacementTemplate: regExOp.replacementTemplate
                ) else {
                    warn("Error processing RegEx for \(file) - file was not modified.")
                    continue
                }
                
                file.writeUTF8Contents(replaced)
                
                success("Performed RegEx replacement in file contents: \(file)")
            }
        }
    }
}

func cleanup() {
    info("Cleaning up.")
    
    subTargets.forEach { st in
        st.trashNonResourceFilesToDeleteAtDestination()
    }
}

if Options.debugMode {
    func urlStatus(_ url: URL) -> String {
        "\(url.fileExists().emoji) \(url)"
    }
    
    info("Package \"\(package.name)\":")
    info("  is valid:       \(package.isValid().emoji)")
    info("  base:           \(urlStatus(package.base))")
    
    info("Main Target \"\(mainTarget.name)\":")
    info("  is valid:       \(mainTarget.isValid().emoji)")
    info("  base:           \(urlStatus(mainTarget.base))")
    info("  docc:           \(urlStatus(mainTarget.docc))")
    info("  docc Resources: \(urlStatus(mainTarget.doccResources))")
    
    subTargets.forEach {
        info("Sub-Target \"\($0.name)\":")
        info("  is valid:       \($0.isValid().emoji)")
        info("  base:           \(urlStatus($0.base))")
        info("  docc:           \(urlStatus($0.docc))")
        info("  docc Resources: \(urlStatus($0.doccResources))")
    }
} else {
    package.validate()
    mainTarget.validate()
    subTargets.forEach { $0.validate() }
    
    syncSubTargetsToMainTarget()
    syncSubTargetResourcesToMainTargetResources()
    updateSubTargetRootFiles()
    updateSymbolExtensionFiles()
    processRegexOperations()
    
    cleanup()
}

success("Done", strong: true)

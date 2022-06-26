import Foundation

let cliInfo = """
xcpBranch 0.0.2 (xcodeprojBranch)
(c) 2022 Steffan Andrews (https://github.com/orchetect)
This script gets or sets SPM dependency parameters in an Xcode project file.

Command line arguments:

  swift xcpBranch.swift get [-p <package name>] [path to .xcodeproj]

  swift xcpBranch.swift set <mode> -p <package_name> <path to .xcodeproj> <target>
    <mode> options:
      -go                perform replacement and write contents to disk
      -dry               analyze project file but do not write any changes to disk
    <target> options:
      -branch <branch name>
      -exactVersion <semver>
      -upToNextMajorVersion <semver>
      -upToNextMinorVersion <semver>
      -versionRange <semver>...<semver>

Examples:

  swift xcpBranch.swift get -p MyPackage ./PathTo/MyProject.xcodeproj
  swift xcpBranch.swift set -go -p MyPackage ./PathTo/MyProject.xcodeproj -branch hotfix
  swift xcpBranch.swift set -go -p MyPackage ./PathTo/MyProject.xcodeproj -exactVersion 1.4.7
  swift xcpBranch.swift set -go -p MyPackage ./PathTo/MyProject.xcodeproj -upToNextMajorVersion 1.4.7
  swift xcpBranch.swift set -go -p MyPackage ./PathTo/MyProject.xcodeproj -upToNextMinorVersion 1.4.7
  swift xcpBranch.swift set -go -p MyPackage ./PathTo/MyProject.xcodeproj -versionRange 1.4.7...1.5.5

"""

func exitWithInvalidArgs() -> Never {
    print(cliInfo)
    print()
    exit(1)
}

// MARK: - Parse Command Line Arguments

guard CommandLine.arguments.count > 1 else { // first arg is always the entire command string
    exitWithInvalidArgs()
}

switch CommandLine.arguments[1] {
case "get":
    guard CommandLine.arguments.count == 1 + 1 + 3 else { // first arg is always the entire command string
        exitWithInvalidArgs()
    }
    
    guard CommandLine.arguments[2].lowercased() == "-p" else {
        exitWithInvalidArgs()
    }
    
    let pkgName = CommandLine.arguments[3]
    
    let xcodeprojPath = CommandLine.arguments[4]
    let xcodeprojURL = URL(fileURLWithPath: xcodeprojPath)
    
    getBranch(pkgName: pkgName,
              xcodeprojURL: xcodeprojURL)
    
case "set":
    guard CommandLine.arguments.count == 1 + 1 + 6 else { // first arg is always the entire command string
        exitWithInvalidArgs()
    }
    
    let isDry: Bool = {
        switch CommandLine.arguments[2].lowercased() {
        case "-dry": return true
        case "-go": return false
        default: exitWithInvalidArgs()
        }
    }()
    
    guard CommandLine.arguments[3].lowercased() == "-p" else {
        exitWithInvalidArgs()
    }
    
    let pkgName = CommandLine.arguments[4]
    
    let xcodeprojPath = CommandLine.arguments[5]
    let xcodeprojURL = URL(fileURLWithPath: xcodeprojPath)
    
    let setType = CommandLine.arguments[6]
    
    let setParam = CommandLine.arguments[7]
    
    setBranch(
        isDry: isDry,
        pkgName: pkgName,
        setType: setType,
        setParam: setParam,
        xcodeprojURL: xcodeprojURL
    )
    
default:
    exitWithInvalidArgs()
}

// MARK: - String Extensions

extension StringProtocol {
    func regexMatches(
        pattern: String,
        options: NSRegularExpression.Options = [],
        matchesOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
    ) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern,
                                                options: options)
            
            func runRegEx(in source: String) -> [NSTextCheckingResult] {
                regex.matches(in: source,
                              options: matchesOptions,
                              range: NSMakeRange(0, nsString.length))
            }
            
            let nsString: NSString
            let results: [NSTextCheckingResult]
            
            switch self {
            case let _self as String:
                nsString = _self as NSString
                results = runRegEx(in: _self)
                
            case let _self as Substring:
                let stringSelf = String(_self)
                nsString = stringSelf as NSString
                results = runRegEx(in: stringSelf)
                
            default:
                return []
            }
            
            return results.map { nsString.substring(with: $0.range) }
        } catch {
            return []
        }
    }
    
    func regexMatches(
        pattern: String,
        replacementTemplate: String,
        options: NSRegularExpression.Options = [],
        matchesOptions _: NSRegularExpression.MatchingOptions = [.withTransparentBounds],
        replacingOptions: NSRegularExpression.MatchingOptions = [.withTransparentBounds]
    ) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern,
                                                options: options)
            
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
                
            case let _self as Substring:
                let stringSelf = String(_self)
                result = runRegEx(in: stringSelf)
                
            default:
                return nil
            }
            
            return result
        } catch {
            return nil
        }
    }
}

// MARK: - Helper Methods

func readPBX(xcodeprojURL: URL) -> (contents: String, url: URL) {
    
    guard FileManager.default.fileExists(atPath: xcodeprojURL.path) else {
        print("File does not exist:", xcodeprojURL.path)
        exit(1)
    }
    
    let pbxURL = xcodeprojURL.appendingPathComponent("project.pbxproj")
    
    guard FileManager.default.fileExists(atPath: pbxURL.path) else {
        print("File does not exist:", pbxURL.path)
        exit(1)
    }
    
    let pbxData: Data!
    
    do {
        pbxData = try Data(contentsOf: pbxURL)
    } catch {
        print("Error '\(error.localizedDescription)' while attempting to read contents of", pbxURL.path)
        exit(1)
    }
    
    print("pbxproj file located at:", pbxURL.path)
    //print(pbxData.count, "bytes.") // just for debugging
    
    guard let pbxString = String(data: pbxData, encoding: .utf8) else {
        print("Could not parse file as text. Aborting.")
        exit(1)
    }
    
    return (pbxString, pbxURL)
    
}

func regexPattern(pkgName: String) -> String {
    
    #"(XCRemoteSwiftPackageReference \""# + pkgName + #"\".+\n.+\n.+"# + pkgName + #".*\n.+requirement\s\=\s)(\{(\n.+?)*?\})"#
    
}

// MARK: - Trunk Methods

func getBranch(
    pkgName: String,
    xcodeprojURL: URL
) {
    
    let pbx = readPBX(xcodeprojURL: xcodeprojURL)
    
    // verify
    
    let pattern = regexPattern(pkgName: pkgName)
    let matches = pbx.contents.regexMatches(pattern: pattern)
    let numberOfMatches = matches.count
    guard numberOfMatches > 0 else {
        print("No \(pkgName) dependency references found.")
        exit(0)
    }
    
    print("Found \(numberOfMatches) \(pkgName) dependency reference\(numberOfMatches == 1 ? "" : "s").")
    
    print(matches.joined(separator: "\n\n"))
    print("")
    
}

func setBranch(
    isDry: Bool,
    pkgName: String,
    setType: String,
    setParam: String,
    xcodeprojURL: URL
) {
    
    let pbx = readPBX(xcodeprojURL: xcodeprojURL)
    
    // verify
    
    let pattern = regexPattern(pkgName: pkgName)
    let numberOfMatches = pbx.contents.regexMatches(pattern: pattern).count
    guard numberOfMatches > 0 else {
        print("No \(pkgName) dependency references found. Aborting pbxproj modification.")
        exit(1)
    }
    
    print("Found \(numberOfMatches) \(pkgName) dependency reference\(numberOfMatches == 1 ? "" : "s").")
    
    // modify
    
    let branchesPlural = "branch\(numberOfMatches == 1 ? "" : "es")"
    
    let newRequirement: String
    switch setType {
    case "-branch":
        newRequirement = """
            {
            \t\t\t\tkind = branch;
            \t\t\t\tbranch = \(setParam);
            \t\t\t}
            """
        
        print("Setting \(pkgName) dependency \(branchesPlural) to \"\(setParam)\".")
        
    case "-exactVersion":
        newRequirement = """
            {
            \t\t\t\tkind = exactVersion;
            \t\t\t\tversion = \(setParam);
            \t\t\t}
            """
        
        print("Setting \(pkgName) dependency \(branchesPlural) to exact version \(setParam).")
        
    case "-upToNextMinorVersion":
        newRequirement = """
            {
            \t\t\t\tkind = upToNextMinorVersion;
            \t\t\t\tminimumVersion = \(setParam);
            \t\t\t}
            """
        
        print("Setting \(pkgName) dependency \(branchesPlural) to \(setParam) up to Next Minor Version.")
        
    case "-upToNextMajorVersion":
        newRequirement = """
            {
            \t\t\t\tkind = upToNextMajorVersion;
            \t\t\t\tminimumVersion = \(setParam);
            \t\t\t}
            """
        
        print("Setting \(pkgName) dependency \(branchesPlural) to \(setParam) up to Next Major Version.")
        
    case "-versionRange":
        let vers = setParam
            .replacingOccurrences(of: "...", with: "\0")
            .split(separator: "\0")
        guard vers.count == 2 else {
            print("Error: version range \"\(setParam)\" is invalid. It must be in this format: 1.4.7...1.5.5")
            exit(1)
        }
        let minVer = vers[0]
        let maxVer = vers[1]
        
        newRequirement = """
            {
            \t\t\t\tkind = versionRange;
            \t\t\t\tmaximumVersion = \(maxVer);
            \t\t\t\tminimumVersion = \(minVer);
            \t\t\t}
            """
        
        print("Setting \(pkgName) dependency \(branchesPlural) to version range \(setParam).")
        
    default:
        print("Error: unrecognized target flag: \"\(setType)\".")
        exit(1)
    }
        
    guard let newPbxContents = pbx.contents.regexMatches(pattern: pattern,
                                                         replacementTemplate: "$1\(newRequirement)")
    else {
        print("Error: RegEx replacement failed. Aborting pbxproj modification.")
        exit(1)
    }
    
    if isDry {
        print("-dry flag: outputting processed pbxproj file contents without writing contents to disk.")
        print()
        print(newPbxContents)
        exit(0)
    }
    
    guard let newPbxData = newPbxContents.data(using: .utf8) else {
        print("Error: Failed to convert new pbxproj data to string. Aborting pbxproj modification.")
        exit(1)
    }
    
    print(newPbxData.count, "bytes to write to pbxproj.")
    
    do {
        try newPbxData.write(to: pbx.url)
    } catch {
        print("Error '\(error.localizedDescription)' while attempting to write contents of", pbx.url.path)
        exit(1)
    }
    
    print("Successfully written pbxproj to disk.")

    
}

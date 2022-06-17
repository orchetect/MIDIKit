// Updated 20220616

import Foundation

let cliInfo = """
This script uses RegEx to set an SPM dependency entry in an Xcode project file to a specific branch.

Command line arguments:

  swift setBranch.swift [-dry or -go] [-p <package name>] [path to .xcodeproj] [branch name]
     -go    == perform replacement and write contents to disk
     -dry   == analyze project file but do not write any changes to disk

Example:

  swift setBranch.swift -go -p MyPackage ./PathTo/MyProject.xcodeproj use-this-branch

"""

func exitWithInvalidArgs() -> Never {
    print(cliInfo)
    print()
    exit(1)
}

guard CommandLine.arguments.count == 1 + 5 else { // first arg is always the entire command string
    exitWithInvalidArgs()
}

let isDry: Bool = {
    switch CommandLine.arguments[1].lowercased() {
    case "-dry": return true
    case "-go": return false
    default: exitWithInvalidArgs()
    }
}()

guard CommandLine.arguments[2].lowercased() == "-p" else {
    exitWithInvalidArgs()
}

let pkgName = CommandLine.arguments[3]

let xcodeprojPath = CommandLine.arguments[4]

let newBranch = CommandLine.arguments[5]

let projURL = URL(fileURLWithPath: xcodeprojPath)

guard FileManager.default.fileExists(atPath: projURL.path) else {
    print("File does not exist:", projURL.path)
    exit(1)
}

let pbxURL = projURL.appendingPathComponent("project.pbxproj")

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

print("Processing pbxproj file located at:", pbxURL.path)
print(pbxData.count, "bytes.") // just for debugging

public extension StringProtocol {
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

guard let pbxString = String(data: pbxData, encoding: .utf8) else {
    print("Could not parse file as text. Aborting pbxproj modification.")
    exit(1)
}

// this is char-for-char regex with no Swift escape chars
let regexPattern = #"(XCRemoteSwiftPackageReference \""# + pkgName + #"\".+\n.+\n.+"# + pkgName + #".*\n.+requirement\s\=\s)(\{(\n.+?)*?\})"#

let newRequirement = """
{
                kind = branch;
                branch = \(newBranch);
            }
"""

// verify

let numberOfMatches = pbxString.regexMatches(pattern: regexPattern).count
guard numberOfMatches > 0 else {
    print("No \(pkgName) dependency references found. Aborting pbxproj modification.")
    exit(1)
}

print("Found \(numberOfMatches) \(pkgName) dependency reference\(numberOfMatches == 1 ? "" : "s").")

print("Setting \(pkgName) dependency branch\(numberOfMatches == 1 ? "" : "es") to \"\(newBranch)\".")

guard let newPbxString = pbxString.regexMatches(pattern: regexPattern,
                                                replacementTemplate: "$1\(newRequirement)")
else {
    print("RegEx replacement failed. Aborting pbxproj modification.")
    exit(1)
}

if isDry {
    print("-dry flag: outputting processed pbxproj file contents without writing contents to disk.")
    print()
    print(newPbxString)
    exit(0)
}

guard let newPbxData = newPbxString.data(using: .utf8) else {
    print("Failed to convert new pbxproj data to string. Aborting pbxproj modification.")
    exit(1)
}

print(newPbxData.count, "bytes to write to pbxproj.")

do {
    try newPbxData.write(to: pbxURL)
} catch {
    print("Error '\(error.localizedDescription)' while attempting to write contents of", pbxURL.path)
    exit(1)
}

print("Successfully written pbxproj to disk.")

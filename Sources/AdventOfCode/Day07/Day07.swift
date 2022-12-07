import Foundation
import Helpers

protocol DirectoryObject {
  var name: String { get }
  var size: Int { get }
}

struct File: DirectoryObject {
  let size: Int
  let name: String
}

struct Directory: DirectoryObject {
  let name: String
  let contents: [DirectoryObject]
  
  var directories: [Directory] {
    contents.compactMap({ $0 as? Directory })
  }
  
  var size: Int {
    contents.map({ $0.size }).reduce(0, +)
  }
  
  init(name: String, contents: [DirectoryObject] = []) {
    self.name = name
    self.contents = contents
  }
}

struct Day07: AoCPrintable {
  
  let inputString: String
  
  func calculatePart1() throws -> Int {
    var steps = inputString.components(separatedBy: "\n")
    
    let directory = try parseDirectory(&steps)
    let allDirectories = flattenDirectories(directory: directory)
    let smallDirectories = allDirectories.filter({ $0.size <= 100000 })
    return smallDirectories.map({ $0.size }).reduce(0, +)
  }
  
  func calculatePart2() throws -> Int {
    var steps = inputString.components(separatedBy: "\n")
    
    let directory = try parseDirectory(&steps)
    let allDirectories = flattenDirectories(directory: directory)
    
    let fileSystemTotal = 70000000
    let neededFreeSpace = 30000000
    let currentFreeSpace = fileSystemTotal - directory.size
    let deleteSpace = neededFreeSpace - currentFreeSpace
    
    guard let directorySizeToDelete = allDirectories
      .filter({ $0.size >= deleteSpace })
      .map({ $0.size })
      .sorted()
      .first else {
      throw AoCError.GeneralError("Could not calculate directory to delete")
    }
    
    return directorySizeToDelete
  }
  
  /// Parses a directory
  /// steps should start with "$ cd {name}"
  private func parseDirectory(_ steps: inout [String]) throws -> Directory {
    guard steps.count > 0 else {
      throw AoCError.GeneralError("No steps left")
    }
    
    guard steps[0].starts(with: "$ cd") else {
      throw AoCError.GeneralError("Not a directory")
    }
    
    let directoryName = String(steps.removeFirst().split(separator: " ").last!)
    guard !steps.isEmpty else {
      return Directory(name: directoryName, contents: [])
    }
    
    let directoryObjects = try parseDirectoryFiles(&steps)
    
    return Directory(name: directoryName, contents: directoryObjects)
  }
  
  /// Parses directory files
  /// Steps should start with "$ ls"
  private func parseDirectoryFiles(_ steps: inout [String]) throws -> [DirectoryObject] {
    let firstStep = steps.removeFirst()
    
    if !firstStep.starts(with: "$ ls") {
      throw AoCError.GeneralError("Invalid list of steps, start with ls")
    }
    
    var directoryObjects: [DirectoryObject] = []
    var shouldContinue = true
    
    while shouldContinue {
      if steps.isEmpty {
        shouldContinue = false
        break
      }
      
      if steps[0].starts(with: "$ cd ..") {
        steps.removeFirst()
        shouldContinue = false
        break
      } else if steps[0].starts(with: "$ cd") {
        let directory = try parseDirectory(&steps)
        directoryObjects.append(directory)
        continue
      } else {
        let step = steps.removeFirst()
        let components = step.components(separatedBy: " ")
        if components[0] != "dir" {
          directoryObjects.append(File(size: Int(components[0])!, name: components[1]))
        }
      }
    }
    return directoryObjects
  }
  
  // Recursively flattens directories
  private func flattenDirectories(directory: Directory) -> [Directory] {
    let children = directory.directories.flatMap({ flattenDirectories(directory: $0) })
    return children + [directory]
  }
}

import Foundation
import Helpers

struct Day05 {
  // Just the movement steps
  private let inputString: String
  private var stacks: [[String]]
  
  init(stacks: [[String]], inputString: String) {
    self.stacks = stacks
    self.inputString = inputString
  }
  
  mutating func calculatePart1() throws -> String {
    let steps = inputString.components(separatedBy: "\n")
    
    for step in steps {
      let parsedStep = step
        .replacingOccurrences(of: "move ", with: "")
        .replacingOccurrences(of: "from ", with: "")
        .replacingOccurrences(of: "to ", with: "")
        .components(separatedBy: " ").compactMap({ Int($0) })
      
      guard parsedStep.count == 3 else {
        throw AoCError.GeneralError("Error parsing step: \(step)")
      }
      
      let count = parsedStep[0]
      let fromStack = parsedStep[1] - 1
      let toStack = parsedStep[2] - 1
      
      for _ in 1...count {
        let item = stacks[fromStack].popLast()!
        stacks[toStack].append(item)
      }
    }
    
    return stacks.compactMap({ $0.last }).joined()
  }
  
  mutating func calculatePart2() throws -> String {
    let steps = inputString.components(separatedBy: "\n")
    
    for step in steps {
      let parsedStep = step
        .replacingOccurrences(of: "move ", with: "")
        .replacingOccurrences(of: "from ", with: "")
        .replacingOccurrences(of: "to ", with: "")
        .components(separatedBy: " ").compactMap({ Int($0) })
      
      guard parsedStep.count == 3 else {
        throw AoCError.GeneralError("Error parsing step: \(step)")
      }
      
      let count = parsedStep[0]
      let fromStack = parsedStep[1] - 1
      let toStack = parsedStep[2] - 1
      
      var popped: [String] = []
      for _ in 1...count {
        popped.append(stacks[fromStack].popLast()!)
      }
      
      for item in popped.reversed() {
        stacks[toStack].append(item)
      }
    }
    
    return stacks.compactMap({ $0.last }).joined()
  }
}



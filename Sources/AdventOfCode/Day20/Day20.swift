import Foundation
import Helpers

struct Day20: AoCPrintable {
  
  let inputString: String
  
  func calculatePart1() throws -> Int {
    return try mix(numberOfMixes: 1, multiplication: 1)
  }
  
  func calculatePart2() throws -> Int {
    return try mix(numberOfMixes: 10, multiplication: 811589153)
  }
  
  func printNew(_ newIndices: [Value]) {
    let line = newIndices.map({ "\($0.value)" })
    print(line)
  }
  
  func mix(numberOfMixes: Int, multiplication: Int) throws -> Int {
    var originalIndices = inputString
      .components(separatedBy: "\n")
      .map({ Int($0)! })
      .enumerated().map { (index, value) in
        Value(from: value * multiplication, index: index)
      }
    
    var sortedIndices = originalIndices
    
    let modNum = sortedIndices.count - 1
    let totalRounds = numberOfMixes * sortedIndices.count
    
    for round in 1...totalRounds {
      defer {
        originalIndices.moveFirstToLast()
      }
      
      let currentValue = originalIndices.first!
      
      if currentValue.value == 0 {
        continue
      }
      
      let index = sortedIndices.firstIndex(where: { $0.id == currentValue.id })!
      
      var newIndex = index + currentValue.value
      
      if currentValue.value < 0 {
        
        let multiplier = modNum * (abs(newIndex) / modNum) + 1
        let add = multiplier * modNum
        newIndex = (newIndex + add) % modNum
      } else if currentValue.value > 0 {
        newIndex = newIndex % modNum
      }
      
      sortedIndices.remove(at: index)
      sortedIndices.insert(currentValue, at: newIndex)
    }
    
    guard let zeroIndex = sortedIndices.firstIndex(where: { $0.value == 0 }) else {
      throw AoCError.GeneralError("Could not find 0")
    }
    
    let value1Index = (1000 + zeroIndex) % sortedIndices.count
    let value1 = sortedIndices[value1Index].value
    
    let value2Index = (2000 + zeroIndex) % sortedIndices.count
    let value2 = sortedIndices[value2Index].value
    
    let value3Index = (3000 + zeroIndex) % sortedIndices.count
    let value3 = sortedIndices[value3Index].value
    
    print("Values are \(value1), \(value2), \(value3)")
    return value1 + value2 + value3
  }
}

struct Value {
  let id: String
  let value: Int
  
  init(from value: Int, index: Int) {
    self.value = value
    self.id = "\(index): \(value)"
  }
}

fileprivate extension [Value] {
  mutating func moveFirstToLast() {
    let value = self.first!
    self.removeFirst()
    self.append(value)
  }
}

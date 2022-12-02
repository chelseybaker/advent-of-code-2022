// https://adventofcode.com/2022/day/2

import Foundation
import Helpers

struct Day01: AoCPrintable {
  
  private let inputString: String
  
  init(inputString: String = Day01Input.Input) {
    self.inputString = inputString
  }
  
  func calculatePart1() throws -> Int {
    let elves = inputString.components(separatedBy: "\n\n")
    let sorted = elves.map({ $0.components(separatedBy: "\n").map({ Int($0)! }).reduce(0, { $0 + $1 }) }).sorted()
    return sorted.last!
  }
  
  func calculatePart2() throws -> Int {
    let elves = inputString.components(separatedBy: "\n\n")
    let sorted = elves.map({ $0.components(separatedBy: "\n").map({ Int($0)! }).reduce(0, { $0 + $1 }) }).sorted()
    return sorted[sorted.count - 1] + sorted[sorted.count - 2] + sorted[sorted.count - 3]
  }
}

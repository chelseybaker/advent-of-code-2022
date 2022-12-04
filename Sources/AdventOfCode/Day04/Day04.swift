import Foundation
import Helpers

struct Day04: AoCPrintable {
  
  private let inputString: String
  
  init(inputString: String = Day04Input.Input) {
    self.inputString = inputString
  }
  
  func calculatePart1() throws -> Int {
    let pairs = inputString.components(separatedBy: "\n")
    return try pairs.map({ pair in
      let (elf1, elf2) = try CleaningRange.parsePair(from: pair)
      return elf1.contains(elf2) || elf2.contains(elf1) ? 1 : 0
    }).reduce(0, +)
  }
  
  func calculatePart2() throws -> Int {
    let pairs = inputString.components(separatedBy: "\n")
    
    return try pairs.map({ pair in
      let (elf1, elf2) = try CleaningRange.parsePair(from: pair)
      return elf1.overlaps(elf2) || elf2.overlaps(elf1) ? 1 : 0
    }).reduce(0, +)
  }
}

fileprivate struct CleaningRange {
  let low: Int
  let high: Int
  
  init(from rangeString: String) throws {
    let range = rangeString.components(separatedBy: "-")
    guard range.count == 2,
          let low = Int(range[0]),
          let high = Int(range[1]) else {
      throw AoCError.GeneralError("Invalid elf range: \(rangeString)")
    }
    
    self.low = low
    self.high = high
  }
}

fileprivate extension CleaningRange {
  // Parses each CleaningRange pair from a string in the format 1-10,2-11
  static func parsePair(from pairString: String) throws -> (CleaningRange, CleaningRange) {
    
    let rangeStrings = pairString.components(separatedBy: ",")
    
    guard rangeStrings.count == 2 else {
      throw AoCError.GeneralError("Invalid parsing of each elf's area")
    }
    
    guard let range1 = try? CleaningRange(from: rangeStrings[0]),
          let range2 = try? CleaningRange(from: rangeStrings[1]) else {
      throw AoCError.GeneralError("Invalid parsing of each elf's area")
    }
    
    return (range1, range2)
    
  }
}

fileprivate extension CleaningRange {
  // Returns true if self fully contains the other range
  func contains(_ otherRange: CleaningRange) -> Bool {
    otherRange.low >= self.low && otherRange.high <= self.high
  }
  
  // Returns true if self overlaps with the other range
  func overlaps(_ otherRange: CleaningRange) -> Bool {
    self.contains(otherRange) || otherRange.high >= self.low && otherRange.low <= self.low || otherRange.low <= self.high && otherRange.high >= self.high
  }
}

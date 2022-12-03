// https://adventofcode.com/2022/day/3

import Foundation
import Helpers


struct Day03: AoCPrintable {
  
  private let inputString: String
  private let letterValue = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

  init(inputString: String = Day03Input.Input) {
    self.inputString = inputString
  }

  func calculatePart1() throws -> Int {
    let rucksacks = inputString.components(separatedBy: "\n")
    
    var total = 0
    
    try rucksacks.forEach { rucksack in
      let halfway = rucksack.count / 2
      let firstHalf = rucksack[0..<halfway]
      let secondHalf = rucksack[halfway...]
      
      guard let badge = firstHalf.filter({ secondHalf.contains($0) }).first else {
        throw AoCError.GeneralError("Couldn't calculate badge")
      }
      
      total += try value(for: badge)
    }
    
    return total
  }
  
  func calculatePart2() throws -> Int {
    let rucksacks = inputString.components(separatedBy: "\n")
    
    var total = 0
    
    for i in stride(from: 0, to: rucksacks.count - 1, by: 3) {
      let rucksack1 = rucksacks[i]
      let rucksack2 = rucksacks[i + 1]
      let rucksack3 = rucksacks[i + 2]
      
      for letter in rucksack1 {
        guard rucksack2.contains(letter) && rucksack3.contains(letter) else {
          continue
        }
        
        total += try value(for: letter)
        break
      }
    }
    
    return total
  }
  

  private func value(for letter: Character) throws -> Int {
    guard let index = letterValue.firstIndex(of: letter) else {
      throw AoCError.GeneralError("Invalid letter: \(letter)")
    }
    
    let value = letterValue.distance(from: letterValue.startIndex, to: index)
    return value + 1
  }
}

//
//  File.swift
//  
//
//  Created by Chelsey Baker on 12/5/22.
//

import XCTest
@testable import AdventOfCode

class Day05Tests: XCTestCase {
  // practice
  let practiceStacks = [
    ["Z", "N"],
    ["M", "C", "D"],
    ["P"]
  ]
  
  // real
  let inputStacks = [
    ["S", "M", "R", "N", "W", "J", "V", "T"],
    ["B", "W", "D", "J", "Q", "P", "C", "V"],
    ["B", "J", "F", "H", "D", "R", "P"],
    ["F", "R", "P", "B", "M", "N", "D"],
    ["H", "V", "R", "P", "T", "B"],
    ["C", "B", "P", "T"],
    ["B", "J", "R", "P", "L"],
    ["N", "C", "S", "L", "T", "Z", "B", "W"],
    ["L", "S", "G"]
  ]
  
  func test_part1_practice() {
    var day = Day05(stacks: practiceStacks, inputString: Day05Input.Practice)
    let output = try? day.calculatePart1()
    XCTAssertEqual(output, "CMZ")
  }
  
  func test_part1_Input() {
    var day = Day05(stacks: inputStacks, inputString: Day05Input.Input)
    let output = try? day.calculatePart1()
    XCTAssertEqual(output, "LJSVLTWQM")
  }
  
  func test_part2_practice() {
    var day = Day05(stacks: practiceStacks, inputString: Day05Input.Practice)
    let output = try? day.calculatePart2()
    XCTAssertEqual(output, "MCD")
  }
  
  func test_part2_Input() {
    var day = Day05(stacks: inputStacks, inputString: Day05Input.Input)
    let output = try? day.calculatePart2()
    XCTAssertEqual(output, "BRQWDBBJM")
  }
}

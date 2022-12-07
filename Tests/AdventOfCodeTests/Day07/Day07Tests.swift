//
//  File.swift
//  
//
//  Created by Chelsey Baker on 12/7/22.
//

import XCTest
@testable import AdventOfCode

class Day07Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day07(inputString: Day07Input.Practice).calculatePart1()
    XCTAssertEqual(output, 95437)
  }
  
  func test_part1_input() {
    let output = try? Day07(inputString: Day07Input.Input).calculatePart1()
    XCTAssertEqual(output, 1118405)
  }
  
  func test_part2_practice() {
    let output = try? Day07(inputString: Day07Input.Practice).calculatePart2()
    XCTAssertEqual(output, 24933642)
  }
  
  func test_part2_input() {
    let output = try? Day07(inputString: Day07Input.Input).calculatePart2()
    XCTAssertEqual(output, 12545514)
  }
}

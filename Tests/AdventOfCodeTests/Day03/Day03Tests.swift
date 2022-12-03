//
//  Day03Tests.swift
//  AdventOfCode2021Tests
//
//

import XCTest
@testable import AdventOfCode

class Day03Tests: XCTestCase {
  
  func test_part1_practice() {
    let output = try? Day03(inputString: Day03Input.Practice).calculatePart1()
    XCTAssertEqual(output, 157)
  }
  
  func test_part1_input() {
    let output = try? Day03(inputString: Day03Input.Input).calculatePart1()
    XCTAssertEqual(output, 8105)
  }
  
  func test_part2_practice() {
    let output = try? Day03(inputString: Day03Input.Practice).calculatePart2()
    XCTAssertEqual(output, 70)
  }
  
  func test_part2_input() {
    let output = try? Day03(inputString: Day03Input.Input).calculatePart2()
    XCTAssertEqual(output, 2363)
  }
}

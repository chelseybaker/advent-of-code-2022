//
//  Day02Calculations.swift
//  AdventOfCode2021Tests
//
//

import XCTest
@testable import AdventOfCode

class Day02Tests: XCTestCase {
  
  func test_part1_practice() {
    let output = try? Day02(inputString: Day02Input.Practice).calculatePart1()
    XCTAssertEqual(output, 15)
  }

  func test_part1_input() {
    let output = try? Day02(inputString: Day02Input.Input).calculatePart1()
    XCTAssertEqual(output, 13484)
  }
  
  func test_part2_practice() {
    let output = try? Day02(inputString: Day02Input.Practice).calculatePart2()
    XCTAssertEqual(output, 12)
  }
  
  func test_part2_input() {
    let output = try? Day02(inputString: Day02Input.Input).calculatePart2()
    XCTAssertEqual(output, 13433)
  }
  
}

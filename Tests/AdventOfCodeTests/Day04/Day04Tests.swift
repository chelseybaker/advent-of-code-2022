//
//  Day04Tests.swift
//  AdventOfCode2022Tests
//
//

import XCTest
@testable import AdventOfCode

class Day04Tests: XCTestCase {
  
  func test_part1_practice() {
    let output = try? Day04(inputString: Day04Input.Practice).calculatePart1()
    XCTAssertEqual(output, 2)
  }

  func test_part1_input() {
    let output = try? Day04(inputString: Day04Input.Input).calculatePart1()
    XCTAssertEqual(output, 483)
  }

  func test_part2_practice() {
    let output = try? Day04(inputString: Day04Input.Practice).calculatePart2()
    XCTAssertEqual(output, 4)
  }
  
  func test_part2_input() {
    let output = try? Day04(inputString: Day04Input.Input).calculatePart2()
    XCTAssertEqual(output, 874)
  }
}

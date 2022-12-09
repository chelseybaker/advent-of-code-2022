//
//  File.swift
//  
//
//  Created by Chelsey Baker on 12/8/22.
//

import XCTest
@testable import AdventOfCode

class Day08Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day08(inputString: Day08Input.Practice).calculatePart1()
    XCTAssertEqual(output, 21)
  }
  
  func test_part1_input() {
    let output = try? Day08(inputString: Day08Input.Input).calculatePart1()
    XCTAssertEqual(output, 1787)
  }
  
  func test_part2_practice() {
    let output = try? Day08(inputString: Day08Input.Practice).calculatePart2()
    XCTAssertEqual(output, 8)
  }
  
  func test_part2_input() {
    let output = try? Day08(inputString: Day08Input.Input).calculatePart2()
    XCTAssertEqual(output, 440640)
  }
}

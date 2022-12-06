//
//  File.swift
//  
//
//  Created by Chelsey Baker on 12/6/22.
//

import XCTest
@testable import AdventOfCode

class Day06Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day06(inputString: Day06Input.Practice).calculatePart1()
    XCTAssertEqual(output, 7)
  }
  
  func test_part1_input() {
    let output = try? Day06(inputString: Day06Input.Input).calculatePart1()
    XCTAssertEqual(output, 1042)
  }
  
  func test_part2_practice() {
    let output = try? Day06(inputString: "mjqjpqmgbljsphdztnvjfqwrcgsmlb").calculatePart2()
    XCTAssertEqual(output, 19)
  }
  
  func test_part2_input() {
    let output = try? Day06(inputString: Day06Input.Input).calculatePart2()
    XCTAssertEqual(output, 2980)
  }
}

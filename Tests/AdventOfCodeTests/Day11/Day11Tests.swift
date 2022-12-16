import XCTest
import Foundation
@testable import AdventOfCode

class Day11Tests: XCTestCase {
  func test_part1_practice() {
    let output = Scratch11Day(Day11Input.Practice).calculatePart1()
    XCTAssertEqual(output, 10605)
  }
  
  func test_part1_input() {
    let output = Scratch11Day(Day11Input.Input).calculatePart1()
    XCTAssertEqual(output, 182293)
  }
  
  func test_part2_practice() {
    let output = Scratch11Day(Day11Input.Practice).calculatePart2()
    XCTAssertEqual(output, 2713310158)
  }
  
  func test_part2_input() {
    let output = Scratch11Day(Day11Input.Input).calculatePart2()
    XCTAssertEqual(output, 2713310158)
  }

}

import XCTest
@testable import AdventOfCode
import RegexBuilder

@available(macOS 13.0, *)
class Day16Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day16(inputString: Day16Input.Practice).calculatePart1()
    XCTAssertEqual(output, 1651)
  }
  
  func test_part1_input() {
    let output = try? Day16(inputString: Day16Input.Input).calculatePart1()
    XCTAssertEqual(output, 0)
  }
  
  func test_part2_practice() {
    let output = try? Day16(inputString: Day16Input.Practice).calculatePart2()
    XCTAssertEqual(output, 8)
  }
  
  func test_part2_input() {
    let output = try? Day16(inputString: Day16Input.Input).calculatePart2()
    XCTAssertEqual(output, 0)
  }
}

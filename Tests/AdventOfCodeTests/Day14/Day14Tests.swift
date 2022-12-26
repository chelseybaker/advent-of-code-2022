import XCTest
@testable import AdventOfCode

class Day14Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day14(inputString: Day14Input.Practice).calculatePart1()
    XCTAssertEqual(output, 24)
  }
  
  func test_part1_input() {
    let output = try? Day14(inputString: Day14Input.Input).calculatePart1()
    XCTAssertEqual(output, 964)
  }
  
  func test_part2_practice() {
    let output = try? Day14(inputString: Day14Input.Practice).calculatePart2()
    XCTAssertEqual(output, 93)
  }
  
  func test_part2_input() {
    let output = try? Day14(inputString: Day14Input.Input).calculatePart2()
    XCTAssertEqual(output, 32041)
  }
  
}

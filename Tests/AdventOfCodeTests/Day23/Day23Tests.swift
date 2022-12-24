import XCTest
@testable import AdventOfCode

class Day23Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day23(inputString: Day23Input.Practice).calculatePart1()
    XCTAssertEqual(output, 110)
  }
  
  func test_part1_input() {
    let output = try? Day23(inputString: Day23Input.Input).calculatePart1()
    XCTAssertEqual(output, 4288)
  }
  
  func test_part2_practice() {
    let output = try? Day23(inputString: Day23Input.Practice).calculatePart2()
    XCTAssertEqual(output, 20)
  }
  
  func test_part2_input() {
    let output = try? Day23(inputString: Day23Input.Input).calculatePart2()
    XCTAssertEqual(output, 940)
  }
}

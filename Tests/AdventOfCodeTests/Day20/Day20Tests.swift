import XCTest
@testable import AdventOfCode

class Day20Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day20(inputString: Day20Input.Practice).calculatePart1()
    XCTAssertEqual(output, 3)
  }
  
  func test_part1_input() {
    let output = try? Day20(inputString: Day20Input.Input).calculatePart1()
    // 5829 too low
    XCTAssertEqual(output, 15297)
  }

  func test_part2_practice() {
    let output = try? Day20(inputString: Day20Input.Practice).calculatePart2()
    XCTAssertEqual(output, 1623178306)
  }

  func test_part2_input() {
    let output = try? Day20(inputString: Day20Input.Input).calculatePart2()
    XCTAssertEqual(output, 2897373276210)
  }
  
}

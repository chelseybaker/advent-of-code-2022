import XCTest
@testable import AdventOfCode

class Day10Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day10(inputString: Day10Input.Practice).calculatePart1()
    XCTAssertEqual(output, 13140)
  }
  
  func test_part1_input() {
    let output = try? Day10(inputString: Day10Input.Input).calculatePart1()
    XCTAssertEqual(output, 14220)
  }
  
  func test_part2_practice() {
    let output = try? Day10(inputString: Day10Input.Practice).calculatePart2()
    XCTAssertEqual(output, 0)
  }
  
  func test_part2_input() {
    let output = try? Day10(inputString: Day10Input.Input).calculatePart2()
    // prints ZRARLFZU
    XCTAssertEqual(output, 0)
  }
}

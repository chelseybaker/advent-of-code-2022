import XCTest
@testable import AdventOfCode

class Day15Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day15(inputString: Day15Input.Practice).calculatePart1()
    XCTAssertEqual(output, 26)
  }
  
  func test_part1_input() {
    let output = try! Day15(inputString: Day15Input.Input).calculatePart1()
    XCTAssertEqual(output, 5040643)
  }
  
  func test_part2_practice() {
    let output = try? Day15(inputString: Day15Input.Practice).calculatePart2()
    XCTAssertEqual(output, 56000011)
  }
  
  func test_part2_input() {
    let output = try? Day15(inputString: Day15Input.Input).calculatePart2()
    XCTAssertEqual(output, 11016575214126)
  }
}

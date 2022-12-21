import XCTest
@testable import AdventOfCode

@available(macOS 13.0, *)
class Day21Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day21(inputString: Day21Input.Practice).calculatePart1()
    XCTAssertEqual(output, 152)
  }
  
  func test_part1_input() {
    let output = try? Day21(inputString: Day21Input.Input).calculatePart1()
    XCTAssertEqual(output, 232974643455000)
  }
  
  func test_part2_practice() {
    let output = try! Day21(inputString: Day21Input.Practice).calculatePart2()
    XCTAssertEqual(output, 301)
  }
  
  func test_part2_input() {
    let output = try? Day21(inputString: Day21Input.Input).calculatePart2()
    XCTAssertEqual(output, 3740214169961)
  }
}

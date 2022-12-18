import XCTest
@testable import AdventOfCode

class Day18Tests: XCTestCase {
  func test_part1_practice1() {
    let output = try? Day18(inputString: Day18Input.Practice1).calculatePart1()
    XCTAssertEqual(output, 10)
  }
  
  func test_part1_practice2() {
    let output = try? Day18(inputString: Day18Input.Practice2).calculatePart1()
    XCTAssertEqual(output, 64)
  }
  
  func test_part1_input() {
    let output = try? Day18(inputString: Day18Input.Input).calculatePart1()
    XCTAssertEqual(output, 3576)
  }
  
  func test_part2_practice() {
    let output = try? Day18(inputString: Day18Input.Practice2).calculatePart2()
    XCTAssertEqual(output, 58)
  }
  
  func test_part2_input() {
    let output = try? Day18(inputString: Day18Input.Input).calculatePart2()
    XCTAssertEqual(output, 2066)
  }
}

import XCTest
@testable import AdventOfCode

class Day17Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day17(inputString: Day17Input.Practice).calculatePart1()
    XCTAssertEqual(output, 3068)
  }

  func test_part1_input() {
    let output = try! Day17(inputString: Day17Input.Input).calculatePart1()
    XCTAssertEqual(output, 3193)
  }
  
  func test_part2_practice() {
    let output = try! Day17(inputString: Day17Input.Practice).calculatePart2()
    XCTAssertEqual(output, 1514285714288)
  }

  func test_part2_input() {

    let output = try! Day17(inputString: Day17Input.Input).calculatePart2()
    XCTAssertEqual(output, 1577650429835)
  }
}

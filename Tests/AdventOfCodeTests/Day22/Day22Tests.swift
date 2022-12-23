import XCTest
@testable import AdventOfCode

class Day22Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day22(inputString: Day22Input.Practice).calculatePart1()
    XCTAssertEqual(output, 6032)
  }
  
  func test_part1_input() {
    let output = try? Day22(inputString: Day22Input.Input).calculatePart1()
    XCTAssertEqual(output, 159034)
  }
  
  func test_part2_practice() {
    let output = try? Day22(inputString: Day22Input.Practice).calculatePart2()
    XCTAssertEqual(output, 5031)
  }
  
  func test_part2_input() {
    let output = try? Day22(inputString: Day22Input.Input).calculatePart2()
    XCTAssertEqual(output, 0)
  }
}

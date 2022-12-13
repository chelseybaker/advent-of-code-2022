import XCTest
@testable import AdventOfCode

class Day12Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day12(inputString: Day12Input.Practice).calculatePart1()
    XCTAssertEqual(output, 31)
  }
  
  func test_part1_input() {
    let output = try? Day12(inputString: Day12Input.Input).calculatePart1()
    // it should be 517
    XCTAssertEqual(output!, 517)
  }
  
  func test_part2_practice() {
    let output = try? Day12(inputString: Day12Input.Practice).calculatePart2()
    XCTAssertEqual(output, 29)
  }
  
  func test_part2_input() {
    let output = try? Day12(inputString: Day12Input.Input).calculatePart2()
    XCTAssertEqual(output, 512)
  }
}



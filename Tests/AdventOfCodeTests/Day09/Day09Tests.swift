import XCTest
@testable import AdventOfCode

class Day09Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day09(inputString: Day09Input.Practice).calculatePart1()
    XCTAssertEqual(output, 13)
  }

  func test_part1_input() {
    let output = try? Day09(inputString: Day09Input.Input).calculatePart1()
    XCTAssertEqual(output, 6266)
  }

  func test_part2_practice1() {
    let output = try? Day09(inputString: Day09Input.Practice).calculatePart2()
    XCTAssertEqual(output, 1)
  }
  
  func test_part2_practice2() {
    let output = try? Day09(inputString: Day09Input.Practice2).calculatePart2()
    XCTAssertEqual(output, 36)
  }

  func test_part2_input() {
    let output = try? Day09(inputString: Day09Input.Input).calculatePart2()
    // 340 is too low
    XCTAssertEqual(output, 0)
  }
//
//  func test_left() {
//    let tail = Position(x: 0, y: 0)
//    let head = Position(x: 10, y: 11)
//  }
  
  
}

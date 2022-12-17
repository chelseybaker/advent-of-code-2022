import XCTest
@testable import AdventOfCode

class Day14Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day14(inputString: Day14Input.Practice).calculatePart1()
    XCTAssertEqual(output, 0)
  }
  
//  func test_part1_input() {
//    let output = try? Day14(inputString: Day14Input.Input).calculatePart1()
//    XCTAssertEqual(output, 0)
//  }
//
//  func test_part2_practice() {
//    let output = try? Day14(inputString: Day14Input.Practice).calculatePart2()
//    XCTAssertEqual(output, 8)
//  }
//
//  func test_part2_input() {
//    let output = try? Day14(inputString: Day14Input.Input).calculatePart2()
//    XCTAssertEqual(output, 0)
//  }
  
//  fileprivate func test_parseInput() {
//    let rocks = try? Day14(inputString: Day14Input.Practice).parseInput()
//    XCTAssertEqual(rocks?.count, 2)
//    XCTAssertEqual(rocks![0].points.count, 3)
//    XCTAssertEqual(rocks![1].points.count, 4)
//  }
}

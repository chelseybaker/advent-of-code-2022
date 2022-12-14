import XCTest
@testable import AdventOfCode

class Day13Tests: XCTestCase {
  func test_part1_practice() {
    let output = try! Day13(inputString: Day13Input.Practice).calculatePart1()
    XCTAssertEqual(output, 13)
  }
  
  func test_part1_input() {
    let output = try? Day13(inputString: Day13Input.Input).calculatePart1()
    XCTAssertEqual(output, 6240)
  }
  
  func test_part2_practice() {
    let output = try? Day13(inputString: Day13Input.Practice).calculatePart2()
    XCTAssertEqual(output, 140)
  }
  
  func test_part2_input() {
    let output = try? Day13(inputString: Day13Input.Input).calculatePart2()
    XCTAssertEqual(output, 23142)
  }

}

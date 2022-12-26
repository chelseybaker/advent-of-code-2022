import XCTest
@testable import AdventOfCode

class Day25Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day25(inputString: Day25Input.Practice).calculatePart1()
    XCTAssertEqual(output, "2=-1=0")
  }

  func test_part1_input() {
    let output = try? Day25(inputString: Day25Input.Input).calculatePart1()
    XCTAssertEqual(output, "2-1=10=1=1==2-1=-221")
  }
}

import XCTest
@testable import AdventOfCode

class Day01Tests: XCTestCase {
  
  func test_part1_practice() {
    let practice = try? Day01(inputString: Day01Input.Practice).calculatePart1()
    XCTAssertEqual(practice, 24000)
  }
  
  func test_part1_input() {
    let practice = try? Day01(inputString: Day01Input.Input).calculatePart1()
    XCTAssertEqual(practice, 66487)
  }
  
  func test_part2_practice() {
    let practice = try? Day01(inputString: Day01Input.Practice).calculatePart2()
    XCTAssertEqual(practice, 45000)
  }
  
  func test_part2_input() {
    let practice = try? Day01(inputString: Day01Input.Input).calculatePart2()
    XCTAssertEqual(practice, 197301)
  }
}

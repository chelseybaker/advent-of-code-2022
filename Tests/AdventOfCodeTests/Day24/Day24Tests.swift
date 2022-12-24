import XCTest
@testable import AdventOfCode

class Day24Tests: XCTestCase {
  func test_part1_practice() {
    let output = try? Day24(inputString: Day24Input.Practice).calculatePart1()
    XCTAssertEqual(output, 18)
  }
  
  func test_part1_input() {
    let output = try? Day24(inputString: Day24Input.Input).calculatePart1()
    XCTAssertEqual(output, 334)
  }
  
  func test_part2_practice() {
    let output = try? Day24(inputString: Day24Input.Practice).calculatePart2()
    XCTAssertEqual(output, 54)
  }
  
  func test_part2_input() {
    let output = try? Day24(inputString: Day24Input.Input).calculatePart2()
    XCTAssertEqual(output, 934)
  }
  
  func testHashValues() {
    let hash1 = TestHash(x: 1, y: 2, z: 3)
    let hash2 = TestHash(x: 1, y: 2, z: 5)
    XCTAssertEqual(hash1.hashValue, hash2.hashValue)
  }
}


struct TestHash: Hashable {
  let x: Int
  let y: Int
  let z: Int
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

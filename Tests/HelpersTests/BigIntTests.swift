//
//  BigInt.swift
//  
//
//  Created by Chelsey Baker on 12/11/22.
//

import XCTest
import Helpers

final class BigIntTests: XCTestCase {
  func test_addition() {
    let output = BigInt("46") + BigInt("10")
    XCTAssertEqual(output.value, "56")
  }
  
  func test_multiplication() {
    let output = BigInt("5") * BigInt("9")
    XCTAssertEqual(output.value, "45")
  }
  
  func test_subtraction() {
    let output = try?  BigInt("55").subtract(right: BigInt(42))
    XCTAssertEqual(output?.value, "13")
  }
  
  func test_subtraction_carryOver() {
    let output = try? BigInt("25").subtract(right: BigInt(19))
    XCTAssertEqual(output?.value, "6")
  }
  
  func test_subtraction_ofSame() {
    let output = try?  BigInt("25").subtract(right: BigInt(25))
    XCTAssertEqual(output?.value, "0")
  }
  
  func test_subtraction_toNegativeThrowsError() {
    XCTAssertThrowsError(try BigInt(25).subtract(right: BigInt(26)))
  }
  
  func test_divide25_5() {
    let output = BigInt(25) / BigInt(5)
    XCTAssertEqual(output.value, "5")
  }
  
  func test_divide_26_5() {
    let output = BigInt(26) / BigInt(5)
    XCTAssertEqual(output.value, "5")
  }
  
  func test_divide_100_10() {
    let output = BigInt(100) / BigInt(10)
    XCTAssertEqual(output.value, "10")
  }
  
  func test_divide_10_100() {
    let output = BigInt(10) / BigInt(100)
    XCTAssertEqual(output.value, "0")
  }
  
  func test_mod_26_5() {
    let output = BigInt(26) % BigInt(5)
    XCTAssertEqual(output.value, "1")
  }
  
  func test_mod_25_5() {
    let output = BigInt(25) % BigInt(5)
    XCTAssertEqual(output.value, "0")
  }
  
  func test_mod_5_25() {
    let output = BigInt(5) % BigInt(25)
    XCTAssertEqual(output.value, "5")
  }
  
  func test_greaterThan_2_1() {
    let output = BigInt(2).greaterThan(BigInt(1))
    XCTAssertEqual(output, true)
  }
  
  func test_greaterThan_25_1() {
    let output = BigInt(25).greaterThan(BigInt(1))
    XCTAssertEqual(output, true)
  }
  
  func test_greaterThan_1_25() {
    let output = BigInt(1).greaterThan(BigInt(25))
    XCTAssertEqual(output, false)
  }
  
  func test_greaterThan_25_24() {
    let output = BigInt(25).greaterThan(BigInt(24))
    XCTAssertEqual(output, true)
  }
  
  func test_greaterThan_25_25() {
    let output = BigInt(25).greaterThan(BigInt(25))
    XCTAssertEqual(output, false)
  }
  
  func test_greaterThan_25_19() {
    let output = BigInt(19).greaterThan(BigInt(25))
    XCTAssertEqual(output, false)
  }
  
  func test_add_54_6() {
    let output = BigInt(54) + BigInt(6)
    XCTAssertEqual(output.value, "60")
  }
  
  func test_divide_1203_3() {
    let output = BigInt(123) / BigInt(3)
    XCTAssertEqual(output, BigInt(41))
  }
  
  func test_divide_73_3() {
    let output = BigInt(71) / BigInt(3)
    XCTAssertEqual(output, BigInt(23))
  }
  
  
  func test_divide() {
    // print("Testing divide")
    let arr = Array(0...100)
    for i in arr {
      for j in arr {
        if j == 0 { continue }
        let output = BigInt(i) / BigInt(j)
        XCTAssertEqual(output.value, String(i / j))
        // print("\(i) / \(j) = \(output.value)")
      }
    }
  }
  
  func test_greaterThan() {
    // print("Testing divide")
    let arr = Array(0...100)
    for i in arr {
      for j in arr {
        let output = BigInt(i) > BigInt(j)
        XCTAssertEqual(output, i > j)
        // print("\(i) / \(j) = \(output.value)")
      }
    }
  }
  
  func test_lessThan() {
    // print("Testing divide")
    let arr = Array(0...100)
    for i in arr {
      for j in arr {
        let output = BigInt(i) < BigInt(j)
        XCTAssertEqual(output, i < j)
        // print("\(i) / \(j) = \(output.value)")
      }
    }
  }
  
  func test_multiply() {
    // print("Testing divide")
    let arr = Array(0...100)
    for i in arr {
      for j in arr {
        let output = BigInt(i) * BigInt(j)
        XCTAssertEqual(output.value, String(i * j))
        // print("\(i) / \(j) = \(output.value)")
      }
    }
  }
  
  func test_add() {
    // print("Testing divide")
    let arr = Array(0...100)
    for i in arr {
      for j in arr {
        let output = BigInt(i) + BigInt(j)
        XCTAssertEqual(output.value, String(i + j), "\(i) + \(j) should equal \(i + j), but you have \(output.value)")
        // print("\(i) / \(j) = \(output.value)")
      }
    }
  }
  
  func test_add_9_7() {
    let output = BigInt(9) + BigInt(9)
    XCTAssertEqual(output.value, "18")
  }
  
  func test_add_9_1() {
    let output = BigInt(9) + BigInt(1)
    XCTAssertEqual(output.value, "10")
  }
  
  func test_subtract() {
    // print("Testing divide")
    let arr = Array(0...100)
    for i in arr {
      for j in arr {
        if j > i { continue }
        let output = try! BigInt(i) - BigInt(j)
        XCTAssertEqual(output.value, String(i - j))
        // print("\(i) / \(j) = \(output.value)")
      }
    }
  }
  
  func test_mod() {
    // print("Testing divide")
    let arr = Array(1...100)
    for i in arr {
      for j in arr {
        let output = BigInt(i) % BigInt(j)
        XCTAssertEqual(output.value, String(i % j))
        // print("\(i) / \(j) = \(output.value)")
      }
    }
  }
}

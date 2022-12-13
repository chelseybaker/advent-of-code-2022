//
//  BigInt.swift
//  
//
//  Created by Chelsey Baker on 12/11/22.
//

import Foundation

public enum BigIntError: Error {
  case InvalidSubtraction
  
  var message: String {
    switch self {
    case .InvalidSubtraction: return "BigInt does not support negative subtraction"
    }
  }
}

public struct BigInt: CustomDebugStringConvertible {
  
  public var value: String
  
  public init(_ value: String) {
    var trimmedValue = value
    while trimmedValue.starts(with: "0") {
      trimmedValue.removeFirst()
    }
    self.value = trimmedValue.isEmpty ? "0" : trimmedValue
  }
  
  public var debugDescription: String {
    return value
  }
  
  public init(_ value: Int) {
    self.value = "\(value)"
  }
  
  public func multiply(right: BigInt) -> BigInt {
    // print("Multiplying \(self.value) and \(right.value)")
    
    var leftCharacterArray = value.reversed().map { Int(String($0))! }
    var rightCharacterArray = right.value.reversed().map { Int(String($0))! }
    var result = [Int](repeating: 0, count: leftCharacterArray.count+rightCharacterArray.count)
    
    for leftIndex in 0..<leftCharacterArray.count {
      for rightIndex in 0..<rightCharacterArray.count {
        
        let resultIndex = leftIndex + rightIndex
        
        result[resultIndex] = leftCharacterArray[leftIndex] * rightCharacterArray[rightIndex] + (resultIndex >= result.count ? 0 : result[resultIndex])
        if result[resultIndex] > 9 {
          result[resultIndex + 1] = (result[resultIndex] / 10) + (resultIndex+1 >= result.count ? 0 : result[resultIndex + 1])
          result[resultIndex] -= (result[resultIndex] / 10) * 10
        }
        
      }
      
    }
    
    result = Array(result.reversed())
    
    while result.count > 0 && result.first == 0 {
      result.removeFirst(1)
    }
    
    return  BigInt(result.map { String($0) }.joined(separator: ""))
  }
  
  public func add(right: BigInt) -> BigInt {
    var leftValue = self.value
    var rightValue = right.value
    
    // Pads with 0s so they're the same size. "123" + "4567" becomes "0123" + "4567"
    while leftValue.count > rightValue.count { rightValue = "0" + rightValue  }
    while rightValue.count > leftValue.count { leftValue = "0" + leftValue  }

    let leftReversedArray = leftValue.reversed().map { Int(String($0))! } // "123" becomes [3, 2, 1]
    let rightReversedArray = rightValue.reversed().map { Int(String($0))! }
    var result: [Int] = Array(repeating: 0, count: leftReversedArray.count + rightReversedArray.count)
    
    var carryOver = 0
    
    for index in 0..<leftReversedArray.count {
      var additionResult = leftReversedArray[index] + rightReversedArray[index] + carryOver
      carryOver = additionResult / 10
      additionResult = additionResult % 10
      result[index] = additionResult
    }

    var index = leftReversedArray.count
    
    while carryOver > 0 {
      let value = carryOver % 10
      result[index] = value
      index += 1
      carryOver = carryOver / 10
    }
    
    while result.last == 0 {
      result.removeLast()
    }
    
    let stringValue = result.reversed().map({ "\($0)" }).joined()
    return BigInt(stringValue)
  }
  
  public func subtract(right: BigInt) throws -> BigInt {
    if right.greaterThan(self) {
      throw BigIntError.InvalidSubtraction
    }
    
    if right == self { return BigInt(0) }
    
    if right.value.count > self.value.count {
      throw BigIntError.InvalidSubtraction
    }
    
    var leftValue = self.value
    var rightValue = right.value
    
    // Pads with 0s so they're the same size. "123" + "4567" becomes "0123" + "4567"
    while leftValue.count > rightValue.count { rightValue = "0" + rightValue  }
    while rightValue.count > leftValue.count { leftValue = "0" + leftValue  }
    
    
    var leftReversedArray = leftValue.reversed().map { Int(String($0)) ?? 0 } // "123" becomes [3, 2, 1]
    var rightReversedArray = rightValue.reversed().map { Int(String($0)) ?? 0 }
    var result: [Int] = Array(repeating: 0, count: leftReversedArray.count + rightReversedArray.count)
    
    for index in 0..<leftReversedArray.count {
      if leftReversedArray[index] >= rightReversedArray[index] {
        result[index] = leftReversedArray[index] - rightReversedArray[index]
      } else {
        // Need to borrow
        if index + 1 >= leftReversedArray.count {
          throw BigIntError.InvalidSubtraction
        }
        
        leftReversedArray[index + 1] = leftReversedArray[index + 1] - 1
        leftReversedArray[index] = leftReversedArray[index] + 10
        result[index] = leftReversedArray[index] - rightReversedArray[index]
      }
    }
    
    while result.last == 0 {
      result.removeLast()
    }
    
    if result.count == 0 { return BigInt(0) }
    let stringValue = result.reversed().map({ "\($0)" }).joined()
    return BigInt(stringValue)
  }
  
  public func divide(by divisor: BigInt) -> BigInt {
   
    if divisor > self { return BigInt(0) }
 
    // Take the first number of self
    var fullDividend = self
    
    var tempDividend = BigInt(String(fullDividend.value.removeFirst()))
    var quotient = ""

    while fullDividend.value.count >= 0 {
      if tempDividend < divisor {
        // Brings down the next value
        quotient = quotient + "0"
        if fullDividend.value.count == 0 {
          return BigInt(quotient)
        }
        tempDividend = tempDividend * 10 + BigInt(String(fullDividend.value.removeFirst()))
        continue
      }
      
      var tempTempDividend = tempDividend
      var count = 0
      while tempTempDividend >= divisor {
        tempTempDividend = try! tempTempDividend.subtract(right: divisor)
        count += 1
      }
      
      // Count is the number that gets added to the quotient
      quotient = quotient + "\(count)"
      
      if fullDividend.value.count == 0 {
        return BigInt(quotient)
      }
      
      let product = divisor.multiply(right: BigInt(count))
      
      let diff = try! tempDividend.subtract(right: product)
      
      let total = diff
      tempDividend = BigInt(total.value + String(fullDividend.value.removeFirst()))
     //  print(tempDividend.value)
    }
    
    if quotient == "" || quotient.filter({ String($0) == "0" }).count == quotient.count { return BigInt(0) }
    return BigInt(quotient)
  }
  
  // Fermat's little theorem states that if p is a prime number, then for any integer a, the number {\displaystyle a^{p}-a}{\displaystyle a^{p}-a} is an integer multiple of p. In the notation of modular arithmetic, this is expressed as
  
  // For example,
  // if a = 2 and p = 7,
  // then z = 2^7 = 128,
  // and 128 − 2 = 126 = 7 × 18
  // is an integer multiple of 7.
  // a ^ 7 = a % 7
  // a & (p-1) ≡ 1 (mod p)
  // 2 ^ (17 - 1)     ≡ 1 mod(17)
  public func mod(_ right: BigInt) -> BigInt {
    let divideValue = self.divide(by: right)
    if divideValue == 0 { return self }
    if divideValue * right > self { return self }
    // print("right: \(right.value) self: \(self.value) divideValue: \(divideValue)")
    return try! self.subtract(right: right * divideValue)
  }
  
  public func greaterThan(_ right: BigInt) -> Bool {
    if self.value.count > right.value.count { return true }
    if self.value.count < right.value.count { return false }
    
    // equal sized values
    let leftInts = self.value.map({ Int(String($0))! })
    let rightInts = right.value.map({ Int(String($0))! })
    
    for index in 0..<leftInts.count {
      if leftInts[index] == rightInts[index] { continue }
      if leftInts[index] < rightInts[index] { return false }
      if leftInts[index] > rightInts[index] { return true }
    }
    
    return false
  }
  
  public func lessThan(_ right: BigInt) -> Bool {
    if self.value == right.value { return false }
    return !self.greaterThan(right)
  }
  
  private static let primeNumbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29].map({ BigInt($0) })
}

extension BigInt: Equatable {}

public func == (left: BigInt, right: Int) -> Bool { return left == BigInt(right) }

public func * (left: BigInt, right: Int) -> BigInt { return left.multiply(right: BigInt(right)) }
public func * (left: BigInt, right: BigInt) -> BigInt { return left.multiply(right: right) }


public func / (left: BigInt, right: Int) -> BigInt { return left.divide(by: BigInt(right)) }
public func / (left: BigInt, right: BigInt) -> BigInt { return left.divide(by: right) }

public func % (left: BigInt, right: Int) -> BigInt { return left.mod(BigInt(right)) }
public func % (left: BigInt, right: BigInt) -> BigInt { return left.mod(right) }

public func > (left: BigInt, right: Int) -> Bool { return left.greaterThan(BigInt(right)) }
public func > (left: BigInt, right: BigInt) -> Bool { return left.greaterThan(right) }

public func >= (left: BigInt, right: Int) -> Bool { return
  left.value == BigInt(right).value ||
  left.greaterThan(BigInt(right)) }
public func >= (left: BigInt, right: BigInt) -> Bool { return
  left.value == right.value || left.greaterThan(right) }


public func < (left: BigInt, right: Int) -> Bool { return left.lessThan(BigInt(right)) }
public func < (left: BigInt, right: BigInt) -> Bool { return left.lessThan(right) }

public func + (left: BigInt, right: BigInt) -> BigInt { return left.add(right: right) }
public func + (left: BigInt, right: Int) -> BigInt { return left.add(right: BigInt(right)) }
public func - (left: BigInt, right: BigInt) throws -> BigInt { return try left.subtract(right: right) }



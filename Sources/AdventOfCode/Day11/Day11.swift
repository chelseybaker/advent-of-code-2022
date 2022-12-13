//
//  File.swift
//
//
//  Created by Chelsey Baker on 12/11/22.
//

import Foundation
import Helpers

fileprivate enum Operation {
  case add(num: Int)
  case multiply(num: Int)
  case square
  case divide(num: Int)
  
  var name: String {
    switch self {
    case .add(let num): return "adds \(num)"
    case .multiply(let num): return "is multiplied by \(num)"
    case .square: return "is squared"
    case .divide(let num): return "divided by \(num)"
    }
  }
}

fileprivate extension String {
  var nums: String {
    return String(self.filter("0123456789".contains))
  }
  
  var num: Int {
    return Int(self.nums)!
  }
}

fileprivate struct WorryValue {
  let originalValue: Int
  var primeValueDictionary: [Int: Int]
  // CurrentValue is only kept up to date in part 1
  var currentValue: BigInt
  
  init(_ value: Int) {
    self.originalValue = value
    self.primeValueDictionary =  [3, 11, 19, 5, 2, 7, 17, 13, 23]
      .reduce([Int: Int]()) { (dict, prime) -> [Int: Int] in
        var dict = dict
        dict[prime] = value
        return dict
      }
    self.currentValue = BigInt(value)
  }
  
  mutating func applyOperation(_ operation: Operation, isPart1: Bool) {
    for prime in primeValueDictionary.keys {
      let currentValue = primeValueDictionary[prime]!
      var newValue = currentValue
      switch operation {
      case .add(let num): newValue = currentValue + num
      case .multiply(let num): newValue = currentValue * num
      case .divide(let num): newValue = currentValue / num
      case .square: newValue = currentValue * currentValue
      }
      newValue = isPart1 ? newValue : (newValue % prime)
      primeValueDictionary[prime] = newValue
    }
    
    if isPart1 {
      switch operation {
      case .add(let num): currentValue = currentValue.add(right: BigInt(num))
      case .multiply(let num): currentValue = currentValue.multiply(right: BigInt(num))
      case .divide(let num): currentValue = currentValue.divide(by: BigInt(num))
      case .square: currentValue = currentValue.multiply(right: currentValue)
      }
    }
    
  }
  
  func isDivisibleBy(_ prime: Int, isPart1: Bool) -> Bool {
    if (isPart1) { return self.currentValue % prime == 0 }
    return primeValueDictionary[prime]! % prime == 0
  }
}

fileprivate struct Monkey {
  let name: Int
  private var items: [WorryValue]
  let operation: Operation
  let divisibleBy: Int
  let throwDict: [Bool: Int]
  var inspectionCount: Int = 0
  var itemNames: String {
    return items.map({ $0.currentValue.value }).joined(separator: ", ")
  }
  
  init(_ block: String) {
    let monkeySteps = block.components(separatedBy: "\n").map({ String($0) })
    
    self.name = Int(exactly: monkeySteps[0].num)!
    
    self.items = monkeySteps[1].filter("0123456789,".contains).components(separatedBy: ",").map({ WorryValue(Int($0)!) })
    
    let operation = monkeySteps[2]
    if operation.contains("+") {
      self.operation = .add(num: operation.num)
    } else if operation.contains("*") && operation.nums.isEmpty {
      self.operation = .square
    } else {
      self.operation = .multiply(num: operation.num)
    }
    
    self.divisibleBy = monkeySteps[3].num
    let trueMonkey = monkeySteps[4].num
    let falseMonkey = monkeySteps[5].num
    throwDict = [true: trueMonkey, false: falseMonkey]
  }
  
  var stillHasItems: Bool {
    return !items.isEmpty
  }
  
  mutating func increaseInspectionCount() {
    inspectionCount += 1
  }
  
  mutating func getFirstItem() -> WorryValue {
    return items.removeFirst()
  }
  
  mutating func receiveItem(_ item: WorryValue) {
    self.items.append(item)
  }
}

struct Scratch11Day {
  let inputString: String
  
  init(_ inputString: String) {
    self.inputString = inputString
  }
  
  func calculatePart1() -> Int {
    var monkeys = inputString.components(separatedBy: "\n\n").map({ Monkey($0) })
    
    let totalRounds = 20
    
    for round in 1...totalRounds {
      for monkeyIdx in 0..<monkeys.count {
        while monkeys[monkeyIdx].stillHasItems {
          
          // 1. Get Item
          var item = monkeys[monkeyIdx].getFirstItem()
          print("\nMonkey \(monkeys[monkeyIdx].name) inspects an item with a worry level of \(item.currentValue.value)")
          monkeys[monkeyIdx].increaseInspectionCount()
          
          // 2. Perform operation
          item.applyOperation(monkeys[monkeyIdx].operation, isPart1: true)
          print("Worry level is now \(item.currentValue.value)")
          
          // 3. Divide by 3
          item.applyOperation(.divide(num: 3), isPart1: true)
          print("Monkey gets bored with item. Worry level is divided by 3 to \(item.currentValue)")
          
          // 4. Determine where to throw
          let isTrue = item.isDivisibleBy(monkeys[monkeyIdx].divisibleBy, isPart1: true)
          print("Current worry level \(isTrue ? "is" : "is not") divisible by \(monkeys[monkeyIdx].divisibleBy) ")
          
          // 5. Throw to another monkey
          let receivingMonkey = monkeys[monkeyIdx].throwDict[isTrue]!
          print("Item with worry level \(item.currentValue.value) is thrown to monkey \(receivingMonkey)")
          monkeys[receivingMonkey].receiveItem(item)
        }
      }
      print("== After round \(round) ==")
      for monkey in monkeys {
        let items = monkey.itemNames
        print("Monkey \(monkey.name) has \(items)")
      }
    }
    
    for monkey in monkeys {
      print("Monkey \(monkey.name) has inspected \(monkey.inspectionCount) times")
      
    }
    
    let inspections = monkeys.map({ $0.inspectionCount }).sorted()
    print(inspections)
    return inspections[inspections.count - 1] * inspections[inspections.count - 2]
  }
  
  func calculatePart2() -> Int {
    var monkeys = inputString.components(separatedBy: "\n\n").map({ Monkey($0) })
    
    let totalRounds = 10000
    
    for round in 1...totalRounds {
      print("Round \(round)")
      for monkeyIdx in 0..<monkeys.count {
        while monkeys[monkeyIdx].stillHasItems {
          
          // 1. Get Item
          var item = monkeys[monkeyIdx].getFirstItem()
          monkeys[monkeyIdx].increaseInspectionCount()
          
          // 2. Perform operation
          item.applyOperation(monkeys[monkeyIdx].operation, isPart1: false)
          
          // 3. Determine where to throw
          let isTrue = item.isDivisibleBy(monkeys[monkeyIdx].divisibleBy, isPart1: false)
          
          // 5. Throw to another monkey
          let receivingMonkey = monkeys[monkeyIdx].throwDict[isTrue]!
          monkeys[receivingMonkey].receiveItem(item)
        }
      }
      if (round == 1 || round == 20 || round % 1000 == 0) {
        print("== After round \(round) ==")
        for monkey in monkeys {
          let items = monkey.itemNames
          print("Monkey \(monkey.name) has inspected \(monkey.inspectionCount) items")
          
        }
      }
    }
    
    let inspections = monkeys.map({ $0.inspectionCount }).sorted()
    print(inspections)
    return inspections[inspections.count - 1] * inspections[inspections.count - 2]
  }
}

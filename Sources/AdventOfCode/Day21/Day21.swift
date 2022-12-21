import Foundation
import Helpers
@available(macOS 13.0, *)
struct Day21: AoCPrintable {
  
  let inputString: String
  
  init(inputString: String = Day21Input.Input) {
    self.inputString = inputString
  }
  
  func calculatePart1() throws -> Int {
    let monkeys = try parseInputs()
    
    var valueMonkeys = monkeys
      .filter({ $0.value.value != nil })
      .mapValues({ $0.value! })
    
    var operationMonkeys = monkeys
      .filter({ $0.value.operation != nil })
      .mapValues({ $0.operation! })
    
    while valueMonkeys["root"] == nil {
      for key in operationMonkeys.keys {
        let monkey1 = operationMonkeys[key]!.lhs
        let monkey2 = operationMonkeys[key]!.rhs
        let operatorr = operationMonkeys[key]!.operatorr
        
        guard let value1 = valueMonkeys[monkey1], let value2 = valueMonkeys[monkey2] else {
          continue
        }
        
        let value = processOperation(lhsValue: value1, rhsValue: value2, operation: operatorr)
        guard valueMonkeys[key] == nil else {
          throw AoCError.GeneralError("Monkey \(key) already has a value")
        }
        
        valueMonkeys[key] = value
        operationMonkeys[key] = nil
        break
      }
    }
    
    return valueMonkeys["root"]!
  }
  
  func calculatePart2() throws -> Int {
    let monkeys = try parseInputs()
    
    var valueMonkeys = monkeys
      .filter({ $0.value.value != nil })
      .mapValues({ $0.value! })
    
    // Value is now irrelevant
    valueMonkeys["humn"] = nil
    
    // How do we find the value of humn?
    // It is equal to root
    
    // What number is root?
    
    var operationMonkeys = monkeys
      .filter({ $0.value.operation != nil })
    
    let rootMonkey = operationMonkeys["root"]!
    operationMonkeys["root"] = nil
    
    // What is human values so that the two sides of root equal each other?
    // How do you program for that?
    
    var keepGoing = true

    // We need to determine what is root, and that is equal to humn
    while keepGoing {
      let valueCount = valueMonkeys.count
      
      for key in operationMonkeys.keys {
        let monkey1 = operationMonkeys[key]!.operation!.lhs
        let monkey2 = operationMonkeys[key]!.operation!.rhs
        let operatorr = operationMonkeys[key]!.operation!.operatorr

        guard let value1 = valueMonkeys[monkey1], let value2 = valueMonkeys[monkey2] else {
          continue
        }

        let value = processOperation(lhsValue: value1, rhsValue: value2, operation: operatorr)
        guard valueMonkeys[key] == nil else {
          throw AoCError.GeneralError("Monkey \(key) already has a value")
        }
        
        valueMonkeys[key] = value
        operationMonkeys[key] = nil
        break
      }
      
      keepGoing = valueCount != valueMonkeys.count
    }

    if let lhsValue = parseOp(monkeyName: rootMonkey.operation!.lhs,
                         allMonkeys: monkeys,
                         valueMonkeys: &valueMonkeys,
                              operationMonkeys: &operationMonkeys) {
      return try figureOut(operation: operationMonkeys[rootMonkey.operation!.rhs]!.operation!,
                       value: lhsValue,
                       allMonkeys: monkeys,
                       valueMonkeys: &valueMonkeys,
                       operationMonkeys: &operationMonkeys)!
    }
    
    if let rhsValue = parseOp(monkeyName: rootMonkey.operation!.rhs,
                         allMonkeys: monkeys,
                         valueMonkeys: &valueMonkeys,
                              operationMonkeys: &operationMonkeys) {
      return try figureOut(operation: operationMonkeys[rootMonkey.operation!.lhs]!.operation!,
                       value: rhsValue,
                       allMonkeys: monkeys,
                       valueMonkeys: &valueMonkeys,
                       operationMonkeys: &operationMonkeys)!
    }
 
    
    // how can we make a stack?
    
    
    return valueMonkeys["humn"]!
  }
  
  private func parseInputs() throws -> [String: Monkey] {
    let monkeys: [String: Monkey] = try inputString
      .components(separatedBy: "\n")
      .map({ try Monkey(fromLine: $0) }).reduce([:], { dict, monkey in
        var dictinoary = dict
        dictinoary[monkey.name] = monkey
        return dictinoary
      })
    return monkeys
  }
  
  private func processOperation(lhsValue: Int, rhsValue: Int, operation: Operator) -> Int {
    switch operation {
    case .Add: return lhsValue + rhsValue
    case .Subtract: return lhsValue - rhsValue
    case .Multiply: return lhsValue * rhsValue
    case .Divide: return lhsValue / rhsValue
    }
  }
  
  
  // Parse the operation if possible
  private func parseOp(monkeyName: String,
                       allMonkeys: [String: Monkey],
                       valueMonkeys: inout [String: Int],
                       operationMonkeys: inout [String: Monkey]) -> Int? {
    // if the monkey already has a value
    if let value = valueMonkeys[monkeyName] {
      return value
    }
   
    guard let operation = operationMonkeys[monkeyName]?.operation else {
      return nil
    }
    
    guard let value1 = parseOp(monkeyName: operation.lhs,
                               allMonkeys: allMonkeys,
                               valueMonkeys: &valueMonkeys,
                               operationMonkeys: &operationMonkeys),
          let value2 = parseOp(monkeyName: operation.rhs,
                               allMonkeys: allMonkeys,
                               valueMonkeys: &valueMonkeys,
                               operationMonkeys: &operationMonkeys) else {
      return nil
    }
    
    return processOperation(lhsValue: value1,
                            rhsValue: value2,
                            operation: operation.operatorr)
  }
  /**
   monkeyName: Monkey to determine (humn)
   operation: operation of unknown side = to right side
   value: Value the left side should equal
   
   */
  
  private func figureOut(operation: Operation,
                         value: Int,
                         allMonkeys: [String: Monkey],
                         valueMonkeys: inout [String: Int],
                         operationMonkeys: inout [String: Monkey]) throws -> Int? {
    
    // operation needs to equal value
    let lhsValue = parseOp(monkeyName: operation.lhs,
                         allMonkeys: allMonkeys,
                         valueMonkeys: &valueMonkeys,
                         operationMonkeys: &operationMonkeys)
    
    let rhsValue = parseOp(monkeyName: operation.rhs,
                         allMonkeys: allMonkeys,
                         valueMonkeys: &valueMonkeys,
                         operationMonkeys: &operationMonkeys)
    
    if let lhsValue = lhsValue, let rhsValue = rhsValue {
      return processOperation(lhsValue: lhsValue,
                              rhsValue:
                                rhsValue, operation: operation.operatorr)
    }
    
    
    if let lhsValue = lhsValue {
      valueMonkeys[operation.lhs] = lhsValue
      operationMonkeys[operation.lhs] = nil
      
      
      
      let newValue: Int
      
      switch operation.operatorr {
      case .Add: newValue = value - lhsValue
      case .Subtract: newValue = lhsValue - value
      case .Divide: newValue = lhsValue / value
      case .Multiply: newValue = value / lhsValue
      }
    
      if operation.lhs == "humn" { return newValue }
      
      return try figureOut(operation: operationMonkeys[operation.rhs]!.operation!,
                       value: newValue,
                       allMonkeys: allMonkeys,
                       valueMonkeys: &valueMonkeys,
                       operationMonkeys: &operationMonkeys)
    }
    
    if let rhsValue = rhsValue {
      valueMonkeys[operation.rhs] = rhsValue
      operationMonkeys[operation.rhs] = nil
      // value2 = 4
      // monkey operation == divide
      // new left side is 150 * value2
      // operation for left monkey
      
      let newValue: Int
      
      switch operation.operatorr {
      case .Divide: newValue = value * rhsValue
      case .Multiply: newValue = value / rhsValue
      case .Add: newValue = value - rhsValue
      case .Subtract: newValue = value + rhsValue
      }
      
      if operation.lhs == "humn" { return newValue }
      
      return try figureOut(operation: operationMonkeys[operation.lhs]!.operation!,
                       value: newValue,
                       allMonkeys: allMonkeys,
                       valueMonkeys: &valueMonkeys,
                       operationMonkeys: &operationMonkeys)
    }
    
    

    
    throw AoCError.GeneralError("You've got a bug")
  }
}

fileprivate enum Operator {
  case Add
  case Subtract
  case Multiply
  case Divide
  
  init(fromString stringValue: String) throws {
    switch stringValue {
    case "+": self = .Add
    case "-": self = .Subtract
    case "*": self = .Multiply
    case "/": self = .Divide
    default: throw AoCError.GeneralError("Cannot parse \(stringValue) as Operator")
    }
  }
  
  var oppositeOperator: Operator {
    switch self {
    case .Add: return .Subtract
    case .Subtract: return .Add
    case .Multiply: return .Divide
    case .Divide: return .Multiply
    }
  }
}

fileprivate struct Operation {
  var lhs: String
  var rhs: String
  var operatorr: Operator
}

@available(macOS 13.0, *)
fileprivate struct Monkey {
  let name: String
  private(set) var value: Int? = nil
  let operation: Operation?
  
  init(fromLine line: String) throws {
    let components = line.components(separatedBy: " ")
    
    if components.count == 2 {
      try self.init(fromValue: line)
      return
    } else if components.count == 4 {
      try self.init(fromOperation: line)
      return
    }
    
    throw AoCError.GeneralError("Cannot parse \(line) as Monkey")
  }
  
  private init(fromOperation operation: String) throws {
    let components = operation.components(separatedBy: " ")
    let operatorr = try Operator(fromString: components[2])
    self.operation = Operation(lhs: components[1],
                               rhs: components[3],
                               operatorr: operatorr)
    self.name = String(components[0]).replacing(":", with: "")
  }
  
  private init(fromValue: String) throws {
    let components = fromValue.components(separatedBy: " ")
    guard let value = Int(components[1]) else {
      throw AoCError.GeneralError("Cannot parse \(fromValue) as int")
    }
    self.value = value
    self.operation = nil
    self.name = String(components[0]).replacing(":", with: "")
  }
  
  mutating func setValue(_ value: Int) {
    self.value = value
  }
}

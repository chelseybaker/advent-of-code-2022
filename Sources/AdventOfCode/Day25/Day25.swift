import Foundation
import Helpers

struct Day25 {
  
  let inputString: String
  
  func calculatePart1() throws -> String {
    let snafus = try inputString
      .components(separatedBy: "\n")
      .map({ try Snafu(String($0)) })
    
    let sum = snafus.map({ $0.intValue }).reduce(0, +)
    return try Snafu(sum).stringValue
  }
  
  func calculatePart2() throws -> Int {
    throw AoCError.NotYetImplemented
  }
}

fileprivate enum Base5 {
  case One
  case Two
  case Zero
  case Minus
  case DoubleMinus
  
  init(fromValue value: String) throws {
    switch value {
    case "1": self = .One
    case "2": self = .Two
    case "0": self = .Zero
    case "-": self = .Minus // - 1
    case "=": self = .DoubleMinus // -2
    default: throw AoCError.GeneralError("Cannot parse \(value) as Base5")
    }
  }
  
  init(_ value: Int) throws {
    switch value {
    case 0: self = .Zero
    case 1: self = .One
    case 2: self = .Two
    case 3: self = .DoubleMinus
    case 4: self = .Minus
    default: throw AoCError.GeneralError("Cannot parse \(value) as Base5")
    }
  }
  
  var intValue: Int {
    switch self {
    case .One: return 1
    case .Two: return 2
    case .Zero: return 0
    case .Minus: return -1 // - 1 || 4
    case .DoubleMinus: return -2 // -2 || 3
    }
  }
  
  var stringValue: String {
    switch self {
    case .One: return "1"
    case .Two: return "2"
    case .Zero: return "0"
    case .Minus: return "-" // - 1 || 4
    case .DoubleMinus: return "=" // -2 || 3
    }
  }
}

fileprivate struct Snafu: Equatable {
  // Reverse indexes are powers
  let base5Value: [Base5]
  
  var stringValue: String {
    base5Value.map({ $0.stringValue }).joined()
  }
  
  var intValue: Int {
    let reverse = Array(base5Value.reversed())
    
    var value = 0
    
    for index in 0..<reverse.count {
      let power = Int(pow(Double(5), Double(index)))
      let newValue = power * reverse[index].intValue
      value += newValue
    }
    
    return value
  }
  
  init(_ value: String) throws {
    base5Value = try value.map {
      try Base5(fromValue: String($0))
    }
  }
  
  init(_ digit: Int) throws {
    if digit < 0 {
      throw AoCError.GeneralError("Cannot parse \(digit) as Snafu")
    }
    
    if digit == 0 {
      self.base5Value = [.Zero]
      return
    }
    
    var value = digit
    var result: [Base5] = []
    while value > 0 {
      let mod = value % 5
      let base5 = try Base5(mod)
      result.append(base5)
      value = Int(round(Double(value) / Double(5)))
    }
    
    self.base5Value = Array(result.reversed())
  }
}

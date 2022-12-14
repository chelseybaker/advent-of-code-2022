import Foundation
import Helpers

struct Day13: AoCPrintable {
  let inputString: String
  
  init(inputString: String = Day13Input.Input) {
    self.inputString = inputString
  }
  
  // 1. if both values are ints, the lower integer should come first.
  // 2. if both values are lists, compare each value (same index) of each list.
  //    if left runs out first, it's in the right order. if right runs out first it's not in the right order. if same, continue
  // 3. If exactly one value is an integer, convert the integer to a list which contains that integer as its only value, then retry the comparison. For example, if comparing [0,0,0] and 2, convert the right value to [2] (a list containing 2); the result is then found by instead comparing [0,0,0] and [2].
  func calculatePart1() throws -> Int {
    let packets = try parseInput(input: inputString)
    var sum = 0
    for index in 0..<packets.count {
      // Force unwrapping because top level ones should always return
      let isInOrder = isInRightOrder(packet: packets[index])!
      if isInOrder {
        sum = sum + index + 1
      }
    }
    return sum
  }
  
  func calculatePart2() throws -> Int {
    let two = List([Digit(2)])
    let six = List([Digit(6)])
    
    let packets = try inputString
      .components(separatedBy: "\n\n")
      .flatMap({ $0.components(separatedBy: "\n") })
      .map({ try parseItem($0) }) +
    [two, six]
    
    let sorted = packets.sorted {
      // Force unwrapping because top level should always have answer
      isInRightOrder(packet: PacketPair(left: $0, right: $1))!
    }
    
    let twoIndex = sorted.firstIndex(where: { ($0 as? List) == two })!
    let sixIndex = sorted.firstIndex(where: { ($0 as? List) == six })!
    
    let twoDistance = sorted.distance(from: sorted.startIndex, to: twoIndex) + 1
    let sixDistance = sorted.distance(from: sorted.startIndex, to: sixIndex) + 1
    
    return twoDistance * sixDistance
  }
  
  func isInCorrectOrder(_ value1: String, _ value2: String) -> Bool{
    return false
  }
  
  fileprivate func parseInput(input: String) throws -> [PacketPair] {
    let packetBlocks = input.components(separatedBy: "\n\n")
    
    var packets: [PacketPair] = []
    
    for packetBlock in packetBlocks {
      let lines = packetBlock.components(separatedBy: "\n")
      let item1 = try parseItem(lines[0])
      let item2 = try parseItem(lines[1])
      packets.append(PacketPair(left: item1, right: item2))
    }
    
    return packets
  }
  
  fileprivate func parseItem(_ item: String) throws -> Item {
    if item.starts(with: "[") { return try parseList(item) }
    return try parseAsDigit(item)
  }
  
  fileprivate func parseList(_ packetBlock: String) throws -> Item {
    guard packetBlock.starts(with: "[") else {
      throw AoCError.GeneralError("Cannot parse \(packetBlock) as array")
    }
    
    if packetBlock == "[]" { return List([]) }
    
    let endIndex = packetBlock.count - 2
    // How can we separate? We need a stack
    
    var stringItems: [String] = []
    
    var item = ""
    var stackCount = 0
    let shortenedBlock = String(packetBlock[1...endIndex])
    for char in shortenedBlock {
      let charAsString = String(char)
      if charAsString == "," && stackCount == 0 {
        stringItems.append(item)
        item = ""
        continue
      }
      item += charAsString
      if charAsString == "[" { stackCount += 1 }
      if charAsString == "]" { stackCount -= 1 }
    }
    stringItems.append(item)
    
    let items = try stringItems.map({ try parseItem($0) })
    return List(items)
  }
  
  fileprivate func parseAsDigit(_ packetBlock: String) throws -> Digit {
    var packetCopy = packetBlock
    var numString = ""
    
    var value = packetCopy.pop()
    while value != nil && "1234567890".contains(value!) {
      numString += value!
      value = packetCopy.pop()
    }
    
    guard let intValue = Int(numString) else {
      throw AoCError.GeneralError("Could not parse block")
    }
    
    return Digit(intValue)
  }
  
  fileprivate func isInRightOrder(packet: PacketPair) -> Bool? {
    // If both values are integers, the lower integer should come first. If the left integer is lower than the right integer, the inputs are in the right order. If the left integer is higher than the right integer, the inputs are not in the right order. Otherwise, the inputs are the same integer; continue checking the next part of the input.
    if let left = packet.left as? Digit, let right = packet.right as? Digit {
      if left.value < right.value { return true }
      if right.value < left.value { return false }
      return nil
    }
    
    // If exactly one value is an integer, convert the integer to a list which contains that integer as its only value, then retry the comparison. For example, if comparing [0,0,0] and 2, convert the right value to [2] (a list containing 2); the result is then found by instead comparing [0,0,0] and [2].
    if let left = packet.left as? Digit, let right = packet.right as? List {
      let newLeft = List([left])
      let newPacket = PacketPair(left: newLeft, right: right)
      return isInRightOrder(packet: newPacket)
    }
    
    if let left = packet.left as? List, let right = packet.right as? Digit {
      let newRight = List([right])
      let newPacket = PacketPair(left: left, right: newRight)
      return isInRightOrder(packet: newPacket)
    }
    
    // If both values are lists, compare the first value of each list, then the second value, and so on. If the left list runs out of items first, the inputs are in the right order. If the right list runs out of items first, the inputs are not in the right order. If the lists are the same length and no comparison makes a decision about the order, continue checking the next part of the input.
    if let left = packet.left as? List, let right = packet.right as? List {
      
      // create new packets out of matching indices
      let maxIndex = min(left.list.count, right.list.count)
      if maxIndex != 0 {
        for index in 0..<maxIndex {
          // if the right is ever lower than the left, auto no
          let newLeft = left.list[index]
          let newRight = right.list[index]
          if let correct = isInRightOrder(packet: PacketPair(left: newLeft, right: newRight)) {
            return correct
          }
        }
      }
      // Needs to come after all the individual comparisons
      if left.list.count < right.list.count { return true }
      if right.list.count < left.list.count { return false }
    }
    
    
    return nil
  }
}

fileprivate protocol Item {}

fileprivate struct Digit: Item, Equatable {
  let value: Int
  
  init(_ value: Int) {
    self.value = value
  }
}

fileprivate struct List: Item, Equatable {
  static func == (lhs: List, rhs: List) -> Bool {
    if lhs.list.count != rhs.list.count { return false }
    
    for index in 0..<lhs.list.count {
      if let _ = lhs.list[index] as? List, let _ = rhs.list[index] as? Digit {
        return false
      }
      
      if let _ = lhs.list[index] as? Digit, let _ = rhs.list[index] as? List {
        return false
      }
      
      if let left = lhs.list[index] as? List, let right = rhs.list[index] as? List {
        return left == right
      }
      
      if let left = lhs.list[index] as? Digit, let right = rhs.list[index] as? Digit {
        return left == right
      }
    }
    
    return true
  }
  
  let list: [Item]
  
  init(_ list: [Item]) {
    self.list = list
  }
}

fileprivate struct PacketPair {
  let left: Item
  let right: Item
}

fileprivate extension String {
  mutating func pop() -> String? {
    if self.isEmpty { return nil }
    return String(self.removeFirst())
  }
}

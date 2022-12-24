import Foundation
import Helpers

struct Day23: AoCPrintable {
  
  let inputString: String
  
  func calculatePart1() throws -> Int {
    var elves = parseBoard()
    
    // Key is moving TO, value is elves that want to move from that position
    var movementDict: [Position: [Position]] = [:]
    
    var directions = [Direction.North, .South, .West, .East]
    
    for round in 1...10 {
      print("== Round \(round) ==")
      var remainingElves = elves.filter({ !$0.isAlone(elves: elves) })
      
      for direction in directions {
        // Get all elves that can move in that direction
        let movingElves = remainingElves
          .filter({ $0.canMove(direction, elves: elves) })
        // print("\(movingElves.count) can potentially move \(direction)")
        // Mark their spots
        movingElves
          .forEach({
            movementDict[$0.getNewPosition(direction), default: []].append($0)
          })
        // Reduce remaining elves
        remainingElves = remainingElves
          .filter({ !movingElves.contains($0) })
      }
      
    
      try movementDict
        // Get only elves where their movement position was only themself
        .filter({ $0.value.count == 1 })
        .forEach { (newPosition: Position, oldPosition: [Position]) in
          
          if oldPosition.count != 1 {
            throw AoCError.GeneralError("Should only h have one movement")
          }
          // Move them!
          elves.remove(oldPosition.first!)
          elves.insert(newPosition)
      }
      
      movementDict = [:]
      directions.moveFirstToLast()
    }
    
    return calculateTiles(elves)
  }
  
  func calculatePart2() throws -> Int {
    var elves = parseBoard()
    
    // Key is moving TO, value is elves that want to move from that position
    var movementDict: [Position: [Position]] = [:]
    
    var directions = [Direction.North, .South, .West, .East]
    
    var round = 1
    var keepGoing = true
    
    while keepGoing {
      print("== Round \(round) ==")
      
      var remainingElves = elves.filter({ !$0.isAlone(elves: elves) })
      
      if remainingElves.isEmpty {
        keepGoing = false
        break
      }
      
      for direction in directions {
        // Get all elves that can move in that direction
        let movingElves = remainingElves
          .filter({ $0.canMove(direction, elves: elves) })
        // Mark their spots
        movingElves
          .forEach({
            movementDict[$0.getNewPosition(direction), default: []].append($0)
          })
        // Reduce remaining elves
        remainingElves = remainingElves
          .filter({ !movingElves.contains($0) })
      }
      
      try movementDict
      // Get only elves where their movement position was only themself
        .filter({ $0.value.count == 1 })
        .forEach { (newPosition: Position, oldPosition: [Position]) in
          
          if oldPosition.count != 1 {
            throw AoCError.GeneralError("Should only h have one movement")
          }
          // Move them!
          elves.remove(oldPosition.first!)
          elves.insert(newPosition)
        }
      
      movementDict = [:]
      directions.moveFirstToLast()
      round += 1
    }
    
    return round
    
    
    throw AoCError.NotYetImplemented
  }
  
  private func parseBoard() -> Set<Position> {
    let blocks = inputString
      .components(separatedBy: "\n")
      .map({ $0.map({ String($0) }) })
    
    var elves: Set<Position> = []
    
    for y in 0..<blocks.count {
      for x in 0..<blocks[y].count {
        if blocks[y][x] == "#" {
          elves.insert(Position(x: x, y: -y))
        }
      }
    }
    
    return elves
  }
  
  private func printBoard(_ elves: Set<Position>) {
    let xValues = elves.map({ $0.x }).sorted()
    let yValues = elves.map({ $0.y }).sorted()
    
    let lowX = xValues.first!
    let highX = xValues.last!
    let lowY = yValues.first!
    let highY = yValues.last!
    
    for y in stride(from: highY, through: lowY, by: -1) {
      var line = ""
      for x in lowX...highX {
        let position = Position(x: x, y: y)
        line += elves.contains(position) ? "#" : "."
      }
      print(line)
    }
  }
  
  private func calculateTiles(_ elves: Set<Position>) -> Int {
    let xValues = elves.map({ $0.x }).sorted()
    let yValues = elves.map({ $0.y }).sorted()
    
    let x = xValues.last! - xValues.first! + 1
    let y = yValues.last! - yValues.first! + 1
    
    return x * y - elves.count
  }
}

fileprivate enum Direction {
  case North
  case East
  case South
  case West
}

fileprivate struct Position: Equatable, Hashable {
  var x: Int
  var y: Int
  
  func getNewPosition(_ direction: Direction) -> Position {
    switch direction {
    case .North: return Position(x: x, y: y + 1)
    case .South: return Position(x: x, y: y - 1)
    case .West: return Position(x: x - 1, y: y)
    case .East: return Position(x: x + 1, y: y)
    }
  }
  
  // Gets the nearby positions based on direction
  func getSpaces(_ direction: Direction) -> [Position] {
    switch direction {
    case .North:
      let newY = y + 1
      return [Position(x: x - 1, y: newY),
              Position(x: x, y: newY),
              Position(x: x + 1, y: newY)]
    case .South:
      let newY = y - 1
      return [Position(x: x - 1, y: newY),
              Position(x: x, y: newY),
              Position(x: x + 1, y: newY)]
    case .East:
      let newX = x + 1
      return [Position(x: newX, y: y - 1),
              Position(x: newX, y: y),
              Position(x: newX, y: y + 1)]
    case .West:
      let newX = x - 1
      return [Position(x: newX, y: y - 1),
              Position(x: newX, y: y),
              Position(x: newX, y: y + 1)]
    }
  }
  
  // Only determines if it could potentially move there, does not
  // handle when someone else has marked a spot
  func canMove(_ direction: Direction, elves: Set<Position>) -> Bool {
    let spaces = getSpaces(direction)
    return elves.filter({ spaces.contains($0) }).isEmpty
  }
  
  func getAllPositions() -> [Position] {
    [
      Position(x: x - 1, y: y + 1), // Top left
      Position(x: x, y: y + 1),     // Top
      Position(x: x + 1, y: y + 1), // Top right
      Position(x: x - 1, y: y),     // Left
      Position(x: x + 1, y: y),     // Right
      Position(x: x - 1, y: y - 1), // Bottom Left
      Position(x: x, y: y - 1),     // Bottom
      Position(x: x + 1, y: y - 1)  // Bottom right
    ]
  }
  
  func isAlone(elves: Set<Position>) -> Bool {
    let allSpaces = getAllPositions()
    return elves.filter({ allSpaces.contains($0) }).isEmpty
  }
}



/**
 Need a way to keep track of what is in the board
 And to keep track if someone has already claimed the spot
 OR we can just keep track of the elves?
 */

// Really need to pull this into the helpers haha
fileprivate extension [Direction] {
  mutating func moveFirstToLast() {
    let value = self.first!
    self.removeFirst()
    self.append(value)
  }
}

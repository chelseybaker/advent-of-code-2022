import Foundation
import Helpers

/**
 TODO
 - Remove the "type" and just keep track of rocks, don't need to also track air
 - Make it AoCPrintable again
 */

struct Day17: AoCPrintable {
  
  let inputString: String
  
  init(inputString: String) {
    self.inputString = inputString
  }
  
  private var shapeOrder = [ShapeType.HoriztonalLine,
                            .Plus,
                            .Corner,
                            .VerticalLine,
                            .Cube]
  
  func calculatePart1() throws -> Int {
    return try calculateProblem(rounds: 2022)
  }
  
  func calculatePart2() throws -> Int {
    return try calculateProblem(rounds: 1000000000000)
  }
  
  private func calculateProblem(rounds: Int) throws -> Int {
    var shapes = shapeOrder

    var gas = try inputString.map({ try Direction(String($0)) })
    
    // Creates teh floor (.Rock is used as floor)
    var grid: Grid = Array(0...6).map({ Space( position: Position(x: $0, y: 0)) })
    
    printGrid(grid)
    var floorY = 0
    
    for round in 1...rounds {
      if round % 1000 == 0 || round == 1 {
        print("Round \(round): floorY: \(floorY). \(rounds - round) to go")
      }
      
      let shape = shapes.moveFirstToLast()!
      
      var newObject = Rock(type: shape, floorY: floorY + 4)
      // Remove any objects from the grid that
      // have the same position
      
      var direction = gas.moveFirstToLast()!
      // printGrid(grid, newRock: newObject)
      var keepGoing = true
      while keepGoing {
        
        if newObject.canMove(direction, grid: grid) {
          newObject.move(direction, grid: grid)
          // print("Moving in direction \(direction)")
          //  printGrid(grid, newRock: newObject)
        } else {
          //print("Cannot move \(direction)")
        }
        
        if newObject.canMove(.Down, grid: grid) {
          newObject.move(.Down, grid: grid)
          // print("Trying to move down")
          // printGrid(grid, newRock: newObject)
        } else {
          keepGoing = false
          // print("Cannot move down")
        }
        
        if keepGoing {
          direction = gas.moveFirstToLast()!
        }
        
      }
      
      // Filter out objects that contain the rock positions
      grid = grid.filter({ !newObject.points.contains($0.position) })
      
      // Add to the grid
      grid = grid + newObject.points.map({ Space(position: $0) })
      
      floorY = grid.map({ $0.position.y }).sorted().last!
      
      // Every 10 rounds, clear the bottom rocks
      if round % 10 == 0 {
        grid = removeBottom(grid)
      }
    }
    // printGrid(grid)
    return floorY
  }
  
  private mutating func getNextShape(shapeOrder: inout [ShapeType]) -> ShapeType {
    let first = shapeOrder.removeFirst()
    shapeOrder.append(first)
    return first
  }
  
  private func removeBottom(_ grid: Grid) -> Grid {
    var counts: [Int: Int] = [:]
    
    for item in grid.map({ $0.position.y }) {
      counts[item] = (counts[item] ?? 0) + 1
    }
    
    counts[0] = nil
    
    guard counts.keys.filter({ counts[$0]! >= 6 }).count > 0 else {
      return grid
    }
    
    if let highestFullFloor = counts.keys.filter({ counts[$0]! >= 7 }).sorted().last {
      if highestFullFloor == 0 {
        return grid
      }
    //  print("FOUND FULL FLOOR: \(highestFullFloor)")
      let newGrid = grid
        .filter({ $0.position.y >= highestFullFloor })
      return newGrid
    }
    
    
    if let newBottomRow = counts.keys.filter({ counts[$0]! == 6 }).sorted().last {
      // print("FOUND ROW WITH 6")
      
      let rowPositions = grid.filter({ $0.position.y == newBottomRow }).map({ $0.position.x })
      
      let emptyCol = Array(0...6).filter({ !rowPositions.contains($0) }).first!
      
      let abovePosition = Position(x: emptyCol, y: newBottomRow + 1)
      if grid.filter({ $0.position == abovePosition }).isEmpty {
        // print(" slot above is not empty ")
      } else {
       //  print("DROPPING BOTTOM BELOW \(newBottomRow)")
        return grid.filter({ $0.position.y >= newBottomRow })
      }
    }
    
    return grid

  }
  
  fileprivate func printGrid(_ grid: Grid, newRock: Rock? = nil) {
    let allPositions = grid.map({ $0.position }) + (newRock?.points ?? [])
    let yValues = allPositions.map({ $0.y }).sorted()
    let lowY = yValues.first!
    let highY = yValues.last!
    
    let rockPositions = grid.map({ $0.position })
    
    for y in stride(from: highY, through: lowY, by: -1) {
      var row = ""
      for x in 0...6 {
        let position = Position(x: x, y: y)
        if let newRock = newRock, newRock.points.contains(position) {
          row.append("@")
        } else if rockPositions.contains(position) {
          row.append("#")
        } else {
          row.append(".")
        }
      }
      print(row)
    }
  }
}

// Once a row is filled, you can ignore it

fileprivate enum Direction {
  case Down
  case Left
  case Right
  
  init(_ stringValue: String) throws {
    if stringValue == "<" {
      self = .Left
      return
    }
    else if stringValue == ">" {
      self = .Right
      return
    }
    
    throw AoCError.GeneralError("Cannot parse \(stringValue) as Direction")
  }
}

fileprivate struct Position: Equatable {
  private let MinX = 0
  private let MaxX = 6
  
  private(set) var x: Int
  private(set) var y: Int
  
  mutating func move(_ direction: Direction) {
    switch direction {
    case .Down: y = y - 1
    case .Left: x = x - 1
    case .Right: x = x + 1
    }
  }
  
  func canMove(_ direction: Direction, grid: Grid) -> Bool {
    
    if direction == .Right && x == MaxX { return false }
    if direction == .Left && x == MinX { return false }
    
    var newPosition: Position
    
    switch direction {
    case .Right: newPosition = Position(x: x + 1, y: y)
    case .Left: newPosition = Position(x: x - 1, y: y)
    case .Down: newPosition = Position(x: x, y: y - 1)
    }
    
    return !grid
      .map({ $0.position }).contains(newPosition)
    
  }
}

fileprivate typealias Grid = [Space]

fileprivate enum ShapeType {
  case Plus
  case HoriztonalLine
  case Cube
  case VerticalLine
  case Corner
}

fileprivate struct Rock {
  var points: [Position]
  
  // floorY shoudl be the index of the floor, the init will add 1
  init(type: ShapeType, floorY: Int) {
    // Left edge is 2 units away so x = 2
    var points: [Position]
    
    switch type {
    case .HoriztonalLine: points = Array(2...5).map({ Position(x: $0, y: floorY) })
    case .VerticalLine: points = Array(floorY...(floorY + 3)).map({ Position(x: 2, y: $0) })
    case .Plus: points = [
      Position(x: 2, y: floorY + 1), // Left most
      Position(x: 3, y: floorY + 1), // Middle
      Position(x: 4, y: floorY + 1), // Right
      Position(x: 3, y: floorY + 2), // Top
      Position(x: 3, y: floorY) // Bottom
    ]
    case .Cube: points = [
      Position(x: 2, y: floorY), // bottom left
      Position(x: 3, y: floorY), // bottom right
      Position(x: 2, y: floorY + 1), // top left
      Position(x: 3, y: floorY + 1), // top right
    ]
    case .Corner: points = [
      Position(x: 2, y: floorY), // bottom row 1
      Position(x: 3, y: floorY), // bottom row 2
      Position(x: 4, y: floorY), // bottom row 3
      Position(x: 4, y: floorY + 1), // Right arm
      Position(x: 4, y: floorY + 2) // Right arm
    ]
    }
    
    self.points = points
  }
  
  mutating func move(_ direction: Direction, grid: Grid) {
    // First check if it can move
    if !canMove(direction, grid: grid) {
      return
    }
    
    for index in 0..<points.count {
      points[index].move(direction)
    }
    
  }
  
  func canMove(_ direction: Direction, grid: Grid) -> Bool {
    return !points
      .map({ $0.canMove(direction, grid: grid) })
      .contains(false)
    
  }
}

fileprivate struct Space {
  let position: Position
}

extension Grid {
  var bottomRow: Int {
    return self.map({ $0.position.y }).sorted().first ?? 0
  }
}

extension Array {
  // Pops the first item and then appends it to the end
  mutating func moveFirstToLast() -> Element? {
    guard count > 0 else {
      return nil
    }
    
    let first = self.removeFirst()
    append(first)
    return first
  }
}



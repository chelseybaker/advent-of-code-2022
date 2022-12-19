import Foundation
import Helpers

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
    return try calculateProblemBetter(rounds: 2022)
  }
  
  func calculatePart2() throws -> Int {
    return try calculateProblemBetter(rounds: 1000000000000)
  }
  
  private func calculateProblemBetter(rounds: Int) throws -> Int {
    // Bottom row of original rock
    var grid = ["#######"]
    let directions = try inputString.map({ try Direction(String($0)) })
    var shapeIndex = 0
    var directionIndex = 0
    var highY = 0
    var cache: [TowerCacheObject: TowerCacheObjectWithYDiff] = [:]
   
    var repeatingRounds: [Int] = []
    var repeatingRoundValues: [Int] = []
    var lastRoundCompleted: Int?
    
    for round in 1...rounds {
      let startingGrid = grid
      let shape = shapeOrder[shapeIndex]
      let startingTowerCache = TowerCacheObject(tower: startingGrid, directionIndex: directionIndex, shapeIndex: shapeIndex)
      if let cached = cache[startingTowerCache] {
        if repeatingRounds.contains(cached.originalRound) {
          lastRoundCompleted = round - 1
          break
        } else {
          repeatingRounds.append(cached.originalRound)
          repeatingRoundValues.append(cached.yChange)
        }
        
        grid = cached.tower
        directionIndex = cached.directionIndex
        shapeIndex = cached.shapeIndex
        highY += cached.yChange
        continue
      }
      
      let highestY = grid.getHighestY()
      var newRock = Rock(type: shape, floorY: highestY + 4)
      var keepGoing = true
      
      while keepGoing {
        if newRock.canMove(directions[directionIndex], grid: grid) {
          newRock.move(directions[directionIndex], grid: grid)
        }
        
        if newRock.canMove(.Down, grid: grid) {
          newRock.move(.Down, grid: grid)
        } else {
          keepGoing = false
        }
        
        directionIndex = (directionIndex + 1) % directions.count
      }
      
      grid = grid.addRock(at: newRock.points)
      
      let diff = grid.getHighestY() - startingGrid.getHighestY()
      highY += diff
      
      shapeIndex = (shapeIndex + 1) % shapeOrder.count
      grid = rmvBottom(grid: grid)
      if round >= 60 {
        let finalTowerCache = TowerCacheObjectWithYDiff(tower: grid, directionIndex: directionIndex, shapeIndex: shapeIndex, yChange: diff, originalRound: round)
        cache[startingTowerCache] = finalTowerCache
      }
    }
    
    if let lastRoundCompleted = lastRoundCompleted {
      let roundsToComplete = rounds - lastRoundCompleted
      let repeatingTotal = repeatingRoundValues.reduce(0, +)
      
      highY += (roundsToComplete / repeatingRounds.count) * repeatingTotal
      
      let remainder = roundsToComplete % repeatingRounds.count
      for idx in 0..<remainder {
        highY += repeatingRoundValues[idx]
      }
    }

    return highY
  }
  
  private func rmvBottom(grid: [String]) -> [String] {
    let count = 60
    if grid.count > count {
      return Array(grid[(grid.count - count)...])
    }
    return grid
  }
  
  private mutating func getNextShape(shapeOrder: inout [ShapeType]) -> ShapeType {
    let first = shapeOrder.removeFirst()
    shapeOrder.append(first)
    return first
  }
  
  fileprivate func printGrid(_ grid: [String], newRock: Rock? = nil) {
    let highY = newRock != nil ? newRock!.points.map({ $0.y }).sorted().last! : grid.count
    
    for y in stride(from: highY, through: 0, by: -1) {
      var row = ""
      for x in 0...6 {
        let position = Position(x: x, y: y)
        if let newRock = newRock, newRock.points.contains(position) {
          row.append("@")
        } else if y >= grid.count {
          row.append(".")
        } else {
          row.append(grid[y][x])
        }
      }
      print(row)
    }
  }
}

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

fileprivate struct Position: Equatable, Hashable {
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
  
  func canMove(_ direction: Direction, grid: [String]) -> Bool {
    
    if direction == .Right && x == MaxX { return false }
    if direction == .Left && x == MinX { return false }
    
    var newPosition: Position
    
    switch direction {
    case .Right: newPosition = Position(x: x + 1, y: y)
    case .Left: newPosition = Position(x: x - 1, y: y)
    case .Down: newPosition = Position(x: x, y: y - 1)
    }
    
    if newPosition.y >= grid.count { return true }
    return String(grid[newPosition.y][newPosition.x]) == "."
  }
}

// fileprivate typealias Grid = [Position]

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
  
  mutating func move(_ direction: Direction, grid: [String]) {
    // First check if it can move
    if !canMove(direction, grid: grid) {
      return
    }
    
    for index in 0..<points.count {
      points[index].move(direction)
    }
    
  }
  
  func canMove(_ direction: Direction, grid: [String]) -> Bool {
    return !points
      .map({ $0.canMove(direction, grid: grid) })
      .contains(false)
    
  }
}


fileprivate struct TowerCacheObject: Hashable {
  let tower: [String]
  let directionIndex: Int
  let shapeIndex: Int
  // let originalRound: Int
  
  init(tower: [String], directionIndex: Int, shapeIndex: Int) {
    self.tower = tower
    self.shapeIndex = shapeIndex
    self.directionIndex = directionIndex
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(tower)
    hasher.combine(directionIndex)
    hasher.combine(shapeIndex)
  }
}

fileprivate struct TowerCacheObjectWithYDiff {
  let tower: [String]
  let directionIndex: Int
  let shapeIndex: Int
  let yChange: Int
  let originalRound: Int
}

extension [String] {
  fileprivate func addRock(at positions: [Position]) -> [String] {
    var newGrid = self
    var highY = positions.map({ $0.y }).sorted().last!
    
    while (newGrid.count) <= highY {
      newGrid.append(".......")
    }
    
    for position in positions {
      var newRow = ""
      for indx in 0...6 {
        if indx == position.x {
          newRow.append("#")
        } else {
          newRow.append(newGrid[position.y][indx])
        }
      }
      newGrid[position.y] = newRow
    }
    
    return newGrid
  }
  
  func getHighestY() -> Int {
    for idx in stride(from: self.count - 1, to: 0, by: -1) {
      if self[idx].contains("#") { return idx }
    }
    return 0
  }
}


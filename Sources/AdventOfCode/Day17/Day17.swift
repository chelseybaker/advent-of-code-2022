import Foundation
import Helpers

/**
 TODO
 - Remove the "type" and just keep track of rocks, don't need to also track air
 - Make it AoCPrintable again
 */

struct Day17 {
  
  let inputString: String
  // Cache object and Int is the value of the floorY
  private var cache: [TowerCacheObject: [String]] = [:]
  
  init(inputString: String) {
    self.inputString = inputString
  }
  
  private var shapeOrder = [ShapeType.HoriztonalLine,
                            .Plus,
                            .Corner,
                            .VerticalLine,
                            .Cube]
  
  mutating func calculatePart1() throws -> Int {
    return try calculateProblemBetter(rounds: 2022)
  }
  
  fileprivate func removeEverythingAfter(_ row: Int, grid: Grid) -> Grid {
    return grid.filter({ $0.y >= row })
  }
  
//  func calculatePart2() throws -> Int {
//    return try calculateProblem(rounds: 1000000000000)
//  }
  
  
  mutating func calculatePart2() throws -> Int {
    return try calculateProblemBetter(rounds: 1000000000000)
  }
  
  mutating private func calculateProblemBetter(rounds: Int) throws -> Int {
    var grid = ["#######"]
    let directions = try inputString.map({ try Direction(String($0)) })
    var shapeIndex = 0
    var directionIndex = 0
    
    var highestY = 0
    
    for round in 1...rounds {
      print("== Round \(round) == ")
      let startingGrid = grid
      let shape = shapeOrder[shapeIndex]
      let tempTowerObject = TowerCacheObject(tower: grid, directionIndex: directionIndex, shape: shape)
      if let newGrid = self.cache[tempTowerObject] {
        grid = newGrid
        print("FOUND CACHE")
        continue
      }
      
//      grid.append(".......")
//      grid.append(".......")
//      grid.append(".......")
      
      
      var newRock = Rock(type: shape, floorY: highestY + 4)
      var keepGoing = true
      printGrid(grid, newRock: newRock)
      while keepGoing {
        if newRock.canMove(directions[directionIndex], grid: grid) {
          newRock.move(directions[directionIndex], grid: grid)
          print("Moving in direction \(directions[directionIndex])")
          printGrid(grid, newRock: newRock)
        } else {
          print("Cannot move \(directions[directionIndex])")
        }

        if newRock.canMove(.Down, grid: grid) {
          newRock.move(.Down, grid: grid)
          print("Moving down")
          printGrid(grid, newRock: newRock)
        } else {
          print("Cannot move down")
          keepGoing = false
        }
        
        if keepGoing {
          directionIndex = (directionIndex + 1) % directions.count
        }
      }
      let oldHighY = grid.getHighestY()
      // need to modify grid to add the rock positions
      grid = grid.addRock(at: newRock.points)
      let towerCache = TowerCacheObject(tower: startingGrid, directionIndex: directionIndex, shape: shape)
      self.cache[towerCache] = grid
      
      shapeIndex = (shapeIndex + 1) % shapeOrder.count
      
      highestY = highestY + grid.getHighestY() - oldHighY
    }
    
    return highestY
  }
  
  
  
  private func calculateProblem(rounds: Int) throws -> Int {
    var shapes = shapeOrder

    var gas = try inputString.map({ try Direction(String($0)) })
    
    // Creates teh floor (.Rock is used as floor)
    var grid: Grid = Array(0...6).map({  Position(x: $0, y: 0) })
    
    printGrid(grid)
    var floorY = 0
    
    for round in 1...rounds {
      if round % 1000 == 0 || round == 1 {
        print("Round \(round): floorY: \(floorY). \(rounds - round) to go")
      }
      let shape = shapes.moveFirstToLast()!
      let currentGrid = grid
      var newObject = Rock(type: shape, floorY: floorY + 4)
      
      // Remove any objects from the grid that
      // have the same position
      
      var direction = gas.moveFirstToLast()!
      let firstDirection = direction
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
      grid = grid.filter({ !newObject.points.contains($0) })
      
      // Add to the grid
      grid = grid + newObject.points
      
      floorY = grid.map({ $0.y }).sorted().last!
      
      
      
      // Every 10 rounds, clear the bottom rocks
      if round % 10 == 0 {
        grid = removeBottom(grid)
      }
      
      
//      if round > 40 {
//        grid = removeEverythingAfter(round - 40, grid: grid)
//        let towerObject = TowerCacheObject(tower: grid, windIndex: direction, shape: shape, floorY: <#T##Int#>)
//      }
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
    
    for item in grid.map({ $0.y }) {
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
        .filter({ $0.y >= highestFullFloor })
      return newGrid
    }
    
    
    if let newBottomRow = counts.keys.filter({ counts[$0]! == 6 }).sorted().last {
      // print("FOUND ROW WITH 6")
      
      let rowPositions = grid.filter({ $0.y == newBottomRow }).map({ $0.x })
      
      let emptyCol = Array(0...6).filter({ !rowPositions.contains($0) }).first!
      
      let abovePosition = Position(x: emptyCol, y: newBottomRow + 1)
      if grid.filter({ $0 == abovePosition }).isEmpty {
        // print(" slot above is not empty ")
      } else {
       //  print("DROPPING BOTTOM BELOW \(newBottomRow)")
        return grid.filter({ $0.y >= newBottomRow })
      }
    }
    
    return grid

  }
  
  fileprivate func printGrid(_ grid: Grid, newRock: Rock? = nil) {
    let allPositions = grid + (newRock?.points ?? [])
    let yValues = allPositions.map({ $0.y }).sorted()
    let lowY = yValues.first!
    let highY = yValues.last!
    
    let rockPositions = grid
    
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
  
  fileprivate func printGrid(_ grid: [String], newRock: Rock? = nil) {
    var highY = newRock != nil ? newRock!.points.map({ $0.y }).sorted().last! : grid.count
    
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
  
  func canMove(_ direction: Direction, grid: Grid) -> Bool {
    
    if direction == .Right && x == MaxX { return false }
    if direction == .Left && x == MinX { return false }
    
    var newPosition: Position
    
    switch direction {
    case .Right: newPosition = Position(x: x + 1, y: y)
    case .Left: newPosition = Position(x: x - 1, y: y)
    case .Down: newPosition = Position(x: x, y: y - 1)
    }
    
    return !grid.contains(newPosition)
    
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

fileprivate typealias Grid = [Position]

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
  
  mutating func move(_ direction: Direction, grid: [String]) {
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
  
  func canMove(_ direction: Direction, grid: [String]) -> Bool {
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
    return self.map({ $0.y }).sorted().first ?? 0
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

fileprivate struct TowerCacheObject: Hashable {
  let tower: [String]
  let directionIndex: Int
  let shape: ShapeType

  
  init(tower: [String], directionIndex: Int, shape: ShapeType) {
    self.tower = tower
    self.shape = shape
    self.directionIndex = directionIndex
  }
  
  // If you find a repeating one, you can just add that y? and 40 rounds?
  func hash(into hasher: inout Hasher) {
    hasher.combine(tower)
    hasher.combine(directionIndex)
    hasher.combine(shape)
  }
}

// I constantly truncate the tower to the top 40 lines and then cache the state (tower and the position in the current command and piece loops) and compare to that cache later. I do this for single steps but also for batches of steps. For a cached batch size of 100,000 pieces it solves in ~8s.

// cache keys are tower + position in current command + piece loops
// position in the input + current piece index

func memoize<Input: Hashable, Output>(_ function: @escaping (Input) -> Output) -> (Input) -> Output {
  // our item cache
  var storage = [Input: Output]()
  
  // send back a new closure that does our calculation
  return { input in
    if let cached = storage[input] {
      return cached
    }
    
    let result = function(input)
    storage[input] = result
    return result
  }
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
  
//  fileprivate func addShapeToGrid(shape: ShapeType) -> [String] {
//    switch shape {
//    case .HoriztonalLine: return self + ["..@@@@."]
//    case .VerticalLine: return self + ["..@....", "..@....", "..@....", "..@...."]
//    case .Plus: return self + ["...@...", "..@@@..", "...@..."]
//    case .Corner: return self + ["..@@@..", "....@..", "....@.."]
//    case .Cube: return self + ["..@@...", "..@@..."]
//    }
//  }
  
  fileprivate func determinePositionsOfShape(_ shape: ShapeType) -> [Position] {
    switch shape {
    case .HoriztonalLine: return [
      Position(x: 2, y: self.count + 1),
      Position(x: 3, y: self.count + 1),
      Position(x: 4, y: self.count + 1),
      Position(x: 5, y: self.count + 1)]
    case .VerticalLine: return [
      Position(x: 2, y: self.count + 1),
      Position(x: 2, y: self.count + 2),
      Position(x: 2, y: self.count + 3),
      Position(x: 2, y: self.count + 4),
    ]
    case .Cube: return [
      Position(x: 2, y: self.count + 1),
      Position(x: 2, y: self.count + 2),
      Position(x: 3, y: self.count + 1),
      Position(x: 3, y: self.count + 2),
    ]
    case .Corner: return [
      Position(x: 2, y: self.count + 1),
      Position(x: 3, y: self.count + 1),
      Position(x: 4, y: self.count + 1),
      Position(x: 4, y: self.count + 2),
      Position(x: 4, y: self.count + 3),
    ]
    case .Plus: return [
      Position(x: 3, y: self.count + 1), // bottom
      Position(x: 2, y: self.count + 2), // middle left
      Position(x: 3, y: self.count + 2), // middle middle
      Position(x: 4, y: self.count + 2), //middle right
      Position(x: 3, y: self.count + 3), // Top
    ]
    }
  }
  
  func getHighestY() -> Int {
    for idx in stride(from: self.count - 1, to: 0, by: -1) {
      if self[idx].contains("#") { return idx }
    }
    return 0
  }
}


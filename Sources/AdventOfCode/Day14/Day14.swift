import Foundation
import Helpers


struct Day14: AoCPrintable {
  let inputString: String
  
  init(inputString: String = Day14Input.Input) {
    self.inputString = inputString
  }
  
  func calculatePart1() throws -> Int {
    var takenPositions = Set(try inputString
      .components(separatedBy: "\n")
      .map({ try Rock(String($0)).allPositions })
      .flatMap({ $0 }))
    
    // y increases as it goes down
    let lowestY = takenPositions.map({ $0.y }).sorted().last!
    var sandCount = 0
    
    var nextSandPosition = sandRestingPlace(takenPositions: takenPositions, lowestY: lowestY)
    
    while nextSandPosition != nil {
      sandCount += 1
      takenPositions.insert(nextSandPosition!)
      nextSandPosition = sandRestingPlace(takenPositions: takenPositions, lowestY: lowestY)
    }
    
    return sandCount
  }
  
  func calculatePart2() throws -> Int {
    var takenPositions = Set(try inputString
      .components(separatedBy: "\n")
      .map({ try Rock(String($0)).allPositions })
      .flatMap({ $0 }))
    
    // y increases as it goes down
    let lowestY = takenPositions.map({ $0.y }).sorted().last! + 2
    var sandCount = 0
    
    var nextSandPosition = sandRestingPlace(takenPositions: takenPositions, lowestY: lowestY)
    
    let endPosition = Position(500, 0)
    
    while nextSandPosition != endPosition {
      sandCount += 1
      takenPositions.insert(nextSandPosition!)
      nextSandPosition = sandRestingPlace(takenPositions: takenPositions, lowestY: lowestY, hasFloor: true)
    }
    
    sandCount += 1
    
    return sandCount
  }
  
  private func sandRestingPlace(takenPositions: Set<Position>, lowestY: Int, hasFloor: Bool = false) -> Position? {
   
    var currentSandPosition = Position(500, 0)
    var isMoving = true

    while isMoving {
      if hasFloor && currentSandPosition.down.y == lowestY {
        return currentSandPosition
      }
      
      if currentSandPosition.y > lowestY { return nil }
  
      if !takenPositions.contains(currentSandPosition.down) {
        currentSandPosition = currentSandPosition.down
      } else if !takenPositions.contains(currentSandPosition.downLeft) {
        currentSandPosition = currentSandPosition.downLeft
      } else if !takenPositions.contains(currentSandPosition.downRight) {
        currentSandPosition = currentSandPosition.downRight
      } else {
        isMoving = false
      }
    }

    return currentSandPosition
  }
  
  
  
  fileprivate func generatePositionsBetween(_ a: Position, b: Position) -> Set<Position> {
    
    return []
  }
}
//
//  fileprivate func parseInput() throws -> [Rock] {
//    try inputString
//      .components(separatedBy: "\n")
//      .map({ String($0) })
//      .map({ try Rock($0) })
//
//  }
//
//  fileprivate func createCaveGrid(rocks: [Rock]) throws -> CaveGrid {
//    guard let highY = rocks.compactMap({ $0.highY }).sorted().last,
//          let highX = rocks.compactMap({ $0.highX }).sorted().last,
//          let lowY = rocks.compactMap({ $0.lowY }).sorted().first,
//          let lowX = rocks.compactMap({ $0.lowX }).sorted().first else {
//      throw AoCError.GeneralError("Could not parse rocks")
//    }
//
//    var caveGrid: CaveGrid = [:]
//
//    for y in lowY...highY {
//      caveGrid[y] = [:]
//      for x in lowX...highX {
//        caveGrid[y]![x] = .Air
//      }
//    }
//
//    for rock in rocks {
//      let points = rock.points
//      for index in 0..<(points.count - 1) {
//        let firstPoint = points[index]
//        let secondPoint = points[index + 1]
//
//        for x in firstPoint.x...secondPoint.x  {
//          print("x, y: \(x) \(firstPoint.y)")
//         // caveGrid[firstPoint.y][x] = .Rock
//        }
//
//        for y in firstPoint.y...secondPoint.y  {
//         // caveGrid[y][firstPoint.x] = .Rock
//        }
//      }
//    }
//
//    return caveGrid
//  }


//fileprivate enum UnitType {
//  case Rock
//  case Sand
//  case Air
//
//  var value: String {
//    switch self {
//    case .Rock: return "#"
//    case .Air: return "."
//    case .Sand: return "o"
//    }
//  }
//}

// outside is Y, inside is X
//fileprivate typealias CaveGrid = [Int: [Int: UnitType]]
//
//fileprivate struct GridPoint: Equatable {
//  let x: Int // moves right
//  let y: Int // moves down
//
//  init(x: Int, y: Int) {
//    self.x = x
//    self.y = y
//  }
//
//  init(_ stringValue: String) throws {
//    let components = stringValue.components(separatedBy: ",").map { String($0) }
//    guard let x = Int(components[0]), let y = Int(components[1]) else {
//      throw AoCError.GeneralError("Cannot parse to integers: \(stringValue)")
//    }
//
//    self.x = x
//    self.y = y
//  }
//}
//
//fileprivate struct Rock {
//  let points: [GridPoint]
//
//
//  var highY: Int? {
//    points.map({ $0.y }).sorted().last
//  }
//
//  var highX: Int? {
//    points.map({ $0.x }).sorted().last
//  }
//
//  var lowY: Int? {
//    points.map({ $0.y }).sorted().first
//  }
//
//  var lowX: Int? {
//    points.map({ $0.x }).sorted().first
//  }
//
//  init(_ stringValue: String) throws {
//    self.points = try stringValue.components(separatedBy: " -> ")
//      .map({ String($0) })
//      .map({ try GridPoint($0) })
//  }
//}

fileprivate struct Rock {
  private let points: [Position]
  
  let allPositions: [Position]
  
  init(_ value: String) throws {
    let stringPoints = value.components(separatedBy: " -> ")
    self.points = try stringPoints.map({ try Position(String($0)) })
    
    var positions: [Position] = []
    
    for index in 0..<(points.count - 1) {
      let a = points[index]
      let b = points[index + 1]
      
      if a.x == b.x {
        let min = min(a.y, b.y)
        let max = max(a.y, b.y)
        
        for y in min...max {
          positions.append(Position(a.x, y))
        }
        
      } else if a.y == b.y {
        let min = min(a.x, b.x)
        let max = max(a.x, b.x)
        
        for x in min...max {
          positions.append(Position(x, a.y))
        }
      } else {
        throw AoCError.GeneralError("a and b not on same plane")
      }
    }
    
    self.allPositions = positions
  }
}

fileprivate struct Position: Hashable {
  let x: Int
  let y: Int
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
  
  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }
  
  init(_ value: String) throws {
    // 498,4
    let components = value.components(separatedBy: ",")
    guard components.count == 2 else {
      throw AoCError.GeneralError("Cannot parse \(value) as position")
    }
    
    guard let x = Int(components[0]), let y = Int(components[1]) else {
      throw AoCError.GeneralError("Cannot parse \(value) as position")
    }
    
    self.x = x
    self.y = y
  }
  
  var down: Position {
    return Position(x, y + 1)
  }
  
  var downLeft: Position {
    return Position(x - 1, y + 1)
  }
  
  var downRight: Position {
    return Position(x + 1, y + 1)
  }
}

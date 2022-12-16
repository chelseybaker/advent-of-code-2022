import Foundation
import Helpers


struct Day14: AoCPrintable {
  
  let inputString: String
  
  func calculatePart1() throws -> Int {
    
    let rocks = try parseInput()
    let caveGrid = try createCaveGrid(rocks: rocks)
    
    printCaveGrid(caveGrid)
    
    throw AoCError.NotYetImplemented
  }
  
  func calculatePart2() throws -> Int {
    throw AoCError.NotYetImplemented
  }
  
  func parseInput() throws -> [Rock] {
    try inputString
      .components(separatedBy: "\n")
      .map({ String($0) })
      .map({ try Rock($0) })
    
  }
  
  func createCaveGrid(rocks: [Rock]) throws -> CaveGrid {
    guard let highY = rocks.compactMap({ $0.highY }).sorted().last,
          let highX = rocks.compactMap({ $0.highX }).sorted().last,
          let lowY = rocks.compactMap({ $0.lowY }).sorted().first,
          let lowX = rocks.compactMap({ $0.lowX }).sorted().first else {
      throw AoCError.GeneralError("Could not parse rocks")
    }
    
    var caveGrid: CaveGrid = [:]
    
    for y in lowY...highY {
      caveGrid[y] = [:]
      for x in lowX...highX {
        caveGrid[y]![x] = .Air
      }
    }
    
    for rock in rocks {
      let points = rock.points
      for index in 0..<(points.count - 1) {
        let firstPoint = points[index]
        let secondPoint = points[index + 1]
        
        for x in firstPoint.x...secondPoint.x  {
          print("x, y: \(x) \(firstPoint.y)")
          caveGrid[firstPoint.y][x] = .Rock
        }
        
        for y in firstPoint.y...secondPoint.y  {
          caveGrid[y][firstPoint.x] = .Rock
        }
      }
    }
    
    return caveGrid
  }
  
  func printCaveGrid(_ caveGrid: CaveGrid) {
    for y in 0..<caveGrid.count {
      print(caveGrid[y].map({ $0.value }).joined())
    }
  }
}

enum UnitType {
  case Rock
  case Sand
  case Air
  
  var value: String {
    switch self {
    case .Rock: return "#"
    case .Air: return "."
    case .Sand: return "o"
    }
  }
}

typealias CaveGrid = [Int: [Int: UnitType]] // outside is Y, inside is X

struct GridPoint: Equatable {
  let x: Int // moves right
  let y: Int // moves down
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
  
  init(_ stringValue: String) throws {
    let components = stringValue.components(separatedBy: ",").map { String($0) }
    guard let x = Int(components[0]), let y = Int(components[1]) else {
      throw AoCError.GeneralError("Cannot parse to integers: \(stringValue)")
    }
    
    self.x = x
    self.y = y
  }
}

struct Rock {
  let points: [GridPoint]
  
  
  var highY: Int? {
    points.map({ $0.y }).sorted().last
  }
  
  var highX: Int? {
    points.map({ $0.x }).sorted().last
  }
  
  var lowY: Int? {
    points.map({ $0.y }).sorted().first
  }
  
  var lowX: Int? {
    points.map({ $0.x }).sorted().first
  }
  
  init(_ stringValue: String) throws {
    self.points = try stringValue.components(separatedBy: " -> ")
      .map({ String($0) })
      .map({ try GridPoint($0) })
  }
}

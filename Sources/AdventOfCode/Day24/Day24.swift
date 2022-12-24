import Foundation
import Helpers

struct Day24: AoCPrintable {
  
  let inputString: String

  func calculatePart1() throws -> Int {
    let board = makeGrid()
    let start = Position(x: 1, y: 0)
    let end = Position(x: board[0].count - 2, y: board.count - 1)
    return calculateMinute(board: board, start: start, end: end, startTime: 0)
  }
  
  func calculatePart2() throws -> Int {
    let board = makeGrid()
    let start = Position(x: 1, y: 0)
    let end = Position(x: board[0].count - 2, y: board.count - 1)
    let trip1Time = calculateMinute(board: board, start: start, end: end, startTime: 0)
    let trip2Time = calculateMinute(board: board, start: end, end: start, startTime: trip1Time)
    let trip3Time = calculateMinute(board: board, start: start, end: end, startTime: trip2Time)

    return trip3Time

  }
  
  fileprivate func calculateMinute(board: [[Space]], start: Position, end: Position, startTime: Int) -> Int {
    var earliestMinute: Int? = nil
    
    var minute = startTime
    
    var possiblePositions: Set<Position> = [start]
    
    while earliestMinute == nil {
      print("Minute \(minute)")
      let nextMinute = minute + 1
      var newPaths: Set<Position> = []
      
      for path in possiblePositions {
        let currentPosition = path
        
        if currentPosition == end {
          earliestMinute = minute
          break
        }
        
        let nextPossiblePositions = availableMoves(from: currentPosition, at: nextMinute, board: board)
        
        if nextPossiblePositions.isEmpty {
          continue
        }
        
        nextPossiblePositions
          .forEach({ newPaths.insert($0.position) })
      }

      possiblePositions = newPaths
      minute = nextMinute
    }
    
    return earliestMinute!
  }

  fileprivate func printBoard(_ board: [[Space]], atTime time: Int, currentPosition: Position) {
    let width = board[0].count
    let height = board.count
    
    print("== Minute \(time) ==")
    for y in 0..<height {
      var line: [String] = []
      for x in 0..<width {
        line.append(board[y][x].valueForTime(time))
      }
      if currentPosition.y == y {
        line[currentPosition.x] = "E"
      }
      print(line.joined())
    }
  }
  
  fileprivate func makeGrid() -> [[Space]] {
    let stringMap = inputString
      .components(separatedBy: "\n")
      .map({ $0.map({ String($0) }) })

    
    let yIndices = Array(1..<(stringMap.count - 1))
    let xIndicies = Array(1..<(stringMap[0].count - 1))
    let width = stringMap[0].count - 2
    let height = stringMap.count - 2
    
    var spaces: [[Space]] = []
    for y in 0..<stringMap.count {
      spaces.append([])
      
      for x in 0..<stringMap[y].count {
        let position = Position(x: x, y: y)
        if stringMap[y][x] == "#" {
          let space = Space(position: position)
          spaces[y].append(space)
          continue
        }
        
        // get all horizonal blizzards
        let horizontalBlizards = xIndicies.compactMap({ try? Blizzard(fromValue: stringMap[y][$0], x: $0, y: y, height: height, width: width) })
          .filter({ $0.direction == .Left || $0.direction == .Right })
        
        let verticalBlizards = yIndices.compactMap({ try? Blizzard(fromValue: stringMap[$0][x], x: x, y: $0, height: height, width: width) })
          .filter({ $0.direction == .Up || $0.direction == .Down })
        let blizards = horizontalBlizards + verticalBlizards
        
        let space = Space(position: position, blizzards: blizards)
        spaces[y].append(space)
      }
    }
    
    return spaces
  }
  
  fileprivate func availableMoves(from currentPosition: Position,
                           at time: Int,
                           board: [[Space]]) -> [Space] {
    let x = currentPosition.x
    let y = currentPosition.y
    // Current Space
    var spaces: [Space] = []
    
    // Left
    if x > 0 {
      spaces.append(board[y][x - 1])
    }
    
    // Up
    if y > 0 {
      spaces.append(board[y - 1][x])
    }
    
    spaces.append(board[y][x])
    
    // Right
    if x < board[0].count - 1 {
      spaces.append(board[y][x + 1])
    }
    
    // Down
    if y < board.count - 1 {
      spaces.append(board[y + 1][x])
    }
    
    return spaces.filter({ $0.isEmptyAtTime(time) })
  }
}

fileprivate enum Direction {
  case Left
  case Right
  case Up
  case Down
  case None
  
  var value: String {
    switch self {
    case .Left: return "<"
    case .Right: return ">"
    case .Down: return "v"
    case .Up: return "^"
    case .None: return "-"
    }
  }
}

fileprivate struct Position: Equatable, Hashable {
  let x: Int
  let y: Int
}

fileprivate struct Space {
  let position: Position
  let blizzards: [Blizzard]? // Blizzards that cross paths with this position
  
  init(position: Position, blizzards: [Blizzard]? = nil) {
    self.position = position
    self.blizzards = blizzards
  }
  
  func isEmptyAtTime(_ time: Int) -> Bool {
    guard let blizzards = blizzards else { return false }
    return blizzards
      .filter({ $0.positionAtTime(time) == position })
      .isEmpty
  }
  
  func valueForTime(_ time: Int) -> String {
    guard let blizzards = blizzards else { return "#" }
    
    let blizzardsAtTime = blizzards
      .filter({ $0.positionAtTime(time) == position })
    
    if blizzardsAtTime.isEmpty { return "." }
    if blizzardsAtTime.count == 1 {
      return blizzardsAtTime.first!.direction.value
    } else {
      return "\(blizzardsAtTime.count)"
    }
  }
}

fileprivate struct Blizzard {
  let direction: Direction
  let maxDistance: Int // width if moves left/right, height if moves up/down
  let startingPosition: Position
  
  var x: Int {
    startingPosition.x
  }
  
  var y: Int {
    startingPosition.y
  }
  
  init(fromValue stringValue: String, x: Int, y: Int, height: Int, width: Int) throws {
    switch stringValue {
    case ">": direction = .Right
    case "<": direction = .Left
    case "^": direction = .Up
    case "v": direction = .Down
    default: throw AoCError.GeneralError("Cannot parse \(stringValue) as Direction")
    }
    
    switch direction {
    case .Up, .Down: maxDistance = height
    case .Left, .Right: maxDistance = width
    default: throw AoCError.GeneralError("Cannot parse \(stringValue) as Direction")
    }
    
    startingPosition = Position(x: x, y: y)
  }
  
  func positionAtTime(_ time: Int) -> Position {
    // Subtracting 1 then re adding because it's mod, but everything is offset by 1
    switch direction {
    case .Up: return Position(x: x, y: mod(y - 1 - time, maxDistance) + 1)
    case .Down: return Position(x: x, y: mod(y - 1 + time, maxDistance) + 1)
    case .Left:  return Position(x: mod(x - 1 - time, maxDistance) + 1, y: y)
    case .Right:  return Position(x: mod(x - 1 + time, maxDistance) + 1, y: y)
      // Not a real case really
    case .None: return startingPosition
    }
  }
}

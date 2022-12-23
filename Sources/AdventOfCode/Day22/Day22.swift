import Foundation
import Helpers

struct Day22: AoCPrintable {
  
  let inputString: String
  
  func calculatePart1() throws -> Int {
    let input = inputString
      .components(separatedBy: "\n\n")
      .map({ String($0) })
    
    let board = try createBoard(inputString: input[0])
    let steps = parseSteps(inputString: input[1])

    var currentPosition = CurrentPosition(
      position: board[0][0].position,
      facingDirection: .Right)
    
//    print("initial board")
//    printBoard(board, currentPosition: currentPosition)
    for step in steps {
      // print("Step \(step) of \(steps)")
      print(step.printValue)
      currentPosition = try nextPosition(board, step: step, currentPosition: currentPosition)
      // printBoard(board, currentPosition: currentPosition)
      // print("\n")
    }
    
    // To finish providing the password to this strange input device, you need to determine numbers for your final row, column, and facing as your final position appears from the perspective of the original map. Rows start from 1 at the top and count downward; columns start from 1 at the left and count rightward. (In the above example, row 1, column 1 refers to the empty space with no tile on it in the top-left corner.) Facing is 0 for right (>), 1 for down (v), 2 for left (<), and 3 for up (^). The final password is the sum of 1000 times the row, 4 times the column, and the facing.
    
    let row = (currentPosition.position.y + 1) * 1000
    let col = (currentPosition.position.x + 1) * 4
    let facing = currentPosition.facingDirection.value
    
    return row + col + facing
  }
  
  func calculatePart2() throws -> Int {
    throw AoCError.NotYetImplemented
  }
  
  private func parseSteps(inputString: String) -> [Step] {
    var directions: [Step] = []
    var steps = ""
    for char in inputString {
      if let turn = Rotate(fromString: String(char)) {
        if !steps.isEmpty {
          directions.append(Distance(value: Int(steps)!))
          steps = ""
        }
        directions.append(turn)
      } else {
        steps += String(char)
      }
    }
    
    if !steps.isEmpty {
      directions.append(Distance(value: Int(steps)!))
    }
    
    return directions
  }
  
  /// Creates the intial board. Pass in the full string, do not break up beforehand
  private func createBoard(inputString: String) throws -> [[BoardSpace]] {
    let blocks = inputString
      .components(separatedBy: "\n")
      .map({ $0.map({String($0) }) })
    
    var board: [[BoardSpace]] = []
    
    for y in 0..<blocks.count {
      board.append([])
      for x in 0..<blocks[y].count {
        if let space = try BoardSpace(fromValue: blocks[y][x], x: x, y: y) {
          board[y].append(space)
        }
      }
    }
    
    return board
  }
  
  private func nextPosition(_ board: [[BoardSpace]],
                            step: Step,
                            currentPosition: CurrentPosition) throws -> CurrentPosition {
    // each board's rows contain only the existing values for that row
    
    if let turn = step as? Rotate {
      let newDirection = currentPosition.facingDirection.turn(turn)
      return CurrentPosition(position: currentPosition.position,
                             facingDirection: newDirection)
    }
    
    guard let distance = step as? Distance else {
      throw AoCError.GeneralError("Cannot parse step")
    }

    // if there's no movement, you can just return the current position
    if distance.value == 0 { return currentPosition }
    
    // Direction we are moving
    let direction = currentPosition.facingDirection
    
    // Path of places on the board to move
    let path: [BoardSpace]
    
    switch direction {
    case .Right:
      let row = board[currentPosition.position.y]
      let currentPositionIndex = row.firstIndex(where: { $0.position.x == currentPosition.position.x })!
      let rowLength = board[currentPosition.position.y].count
      let start = currentPositionIndex + 1
      let end = currentPositionIndex + distance.value
      path = Array(start...end)
        .map({ $0 % rowLength })
        .map({ row[$0] })
    case .Left:
      let row = Array(board[currentPosition.position.y].reversed())
      let currentPositionIndex = row.firstIndex(where: { $0.position.x == currentPosition.position.x })!
      let rowLength = board[currentPosition.position.y].count
      let start = currentPositionIndex + 1
      let end = currentPositionIndex + distance.value
      path = Array(start...end)
        .map({ $0 % rowLength })
        .map({ row[$0] })
    case .Down: // Down is positive
      // TODO: May need to optimize
      let column = board
        .flatMap({ $0.filter({ $0.position.x == currentPosition.position.x }) })
        .sorted(by: { $0.position.y < $1.position.y })
      
      let colIndex = column.firstIndex(where: { $0.position.y == currentPosition.position.y })!
      
      let colLength = column.count
      let start = colIndex + 1
      let end = colIndex + distance.value
      path = Array(start...end)
        .map({ $0 % colLength })
        .map({ column[$0] })
    case .Up:
      // TODO: May need to optimize
      // Column is in REVERSE order
      let column = board
        .flatMap({ $0.filter({ $0.position.x == currentPosition.position.x }) })
        .sorted(by: { $0.position.y > $1.position.y })
      
      let colIndex = column.firstIndex(where: { $0.position.y == currentPosition.position.y })!
      
      let colLength = column.count
      let start = colIndex + 1
      let end = colIndex + distance.value
      path = Array(start...end)
        .map({ $0 % colLength })
        .map({ column[$0] })
    }
    
    // If there are no wall points, just return the ending position
    guard let nextWallIndex = path.firstIndex(where: { $0.type == .Wall }) else {
      return CurrentPosition(position: path.last!.position, facingDirection: currentPosition.facingDirection)
    }
    
    // Can't move
    if nextWallIndex == 0 { return currentPosition }
    
    let previousIndex = (nextWallIndex - 1) % path.count
    let newPosition = path[previousIndex].position
    return CurrentPosition(position: newPosition,
                           facingDirection: currentPosition.facingDirection)
  }
  
  private func printBoard(_ board: [[BoardSpace]],
                          currentPosition: CurrentPosition) {
    let maxX = board
      .flatMap({ $0.compactMap({ $0.position.x }) })
      .sorted()
      .last!
    
    for y in 0..<board.count {
      var row = ""
      for x in 0...maxX {
        if currentPosition.position.x == x && currentPosition.position.y == y {
          row.append(currentPosition.facingDirection.printValue)
        } else if let space = board[y].filter({ $0.position.x == x }).first {
          row.append(space.type.printValue)
        } else {
          row.append(" ")
        }
      }
      print(row)
    }
  }
}

fileprivate struct Position: Equatable {
  let x: Int
  let y: Int
}

fileprivate enum BoardSpaceType {
  case Tile
  case Wall
  
  var printValue: String {
    switch self {
    case .Tile: return "."
    case .Wall: return "#"
    }
  }
  
  init(fromString stringValue: String) throws {
    switch stringValue {
    case ".": self = .Tile
    case "#": self = .Wall
    default: throw AoCError.GeneralError("Cannot parse \(stringValue) as BoardSpaceType")
    }
  }
}

fileprivate struct BoardSpace {
  let position: Position
  let type: BoardSpaceType
  
  init?(fromValue stringValue: String, x: Int, y: Int) throws {
    if stringValue == " " { return nil }
    position = Position(x: x, y: y)
    type = try BoardSpaceType(fromString: stringValue)
  }
}

fileprivate protocol Step {
  var printValue: String { get }
}

fileprivate enum Rotate: Step {
  case Left
  case Right
  
  var printValue: String {
    switch self {
    case .Left: return "Rotating left"
    case .Right: return "Rotating right"
    }
  }
  
  init?(fromString stringValue: String) {
    switch stringValue {
    case "L": self = .Left
    case "R": self = .Right
    default: return nil
    }
  }
}

fileprivate struct CurrentPosition {
  let position: Position
  let facingDirection: Direction
}

fileprivate struct Distance: Step {
  let value: Int
  
  var printValue: String {
    return "Moving \(value) steps"
  }
}

fileprivate enum Direction {
  case Up
  case Down
  case Left
  case Right
  
  var printValue: String {
    switch self {
    case .Up: return "^"
    case .Down: return "v"
    case .Left: return "<"
    case .Right: return ">"
    }
  }
  
  func turn(_ direction: Rotate) -> Direction {
    if direction == .Left {
      switch self {
      case .Up: return .Left
      case .Left: return .Down
      case .Down: return .Right
      case .Right: return .Up
      }
    } else {
      switch self {
      case .Up: return .Right
      case .Left: return .Up
      case .Down: return .Left
      case .Right: return .Down
      }
    }
  }
  
  var value: Int {
    // Facing is 0 for right (>), 1 for down (v), 2 for left (<), and 3 for up (^).
    switch self {
    case .Right: return 0
    case .Down: return 1
    case .Left: return 2
    case .Up: return 3
    }
  }
}

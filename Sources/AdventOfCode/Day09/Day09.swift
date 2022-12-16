import Foundation
import Helpers

fileprivate struct Position: Hashable {
  let x: Int
  let y: Int
  
  var location: String {
    "(\(x), \(y))"
  }
}

fileprivate enum Direction: String {
  case Right = "R"
  case Up = "U"
  case Left = "L"
  case Down = "D"
}

struct Day09: AoCPrintable {
  
  let inputString: String
  
  init(inputString: String = Day09Input.Input) {
    self.inputString = inputString
  }
  
  func calculatePart1() throws -> Int {
    return try doKnots(count: 2)
  }
  
  func calculatePart2() throws -> Int {
    return try doKnots(count: 10)
  }
  
  func doKnots(count: Int) throws -> Int {
    let steps = inputString.components(separatedBy: "\n")
    
    var knots = (0..<count).map({ _ in Position(x: 0, y: 0) })
    
    printBoard(knots: knots)
    
    // Always position of the last knot in the array
    let lastKnotPosition = count - 1
    
    var tailPositions: Set<Position> = Set(arrayLiteral: knots[lastKnotPosition])
    
    for step in steps {
      print("Step \(step)")
      let direction = Direction(rawValue: step.components(separatedBy: " ")[0])!
      let count = Int(step.components(separatedBy: " ")[1])!
      
      for _ in 0..<count {
        knots[0] = newHeadPosition(knots[0], direction: direction)
        
        for index in 1..<knots.count {
          var newIndexKnotPosition = try newTrailingKnotPosition(knots[index], head: knots[index - 1])
         
          if index == lastKnotPosition {
            tailPositions.insert(newIndexKnotPosition)
          }
          
          while !tailDoesNotNeedToMove(tail: newIndexKnotPosition, head: knots[index - 1]) {
            newIndexKnotPosition = try newTrailingKnotPosition(newIndexKnotPosition, head: knots[index - 1])
            if index == lastKnotPosition {
              tailPositions.insert(newIndexKnotPosition)
            }
          }
          
          knots[index] = newIndexKnotPosition
        }
        
        tailPositions.insert(knots[lastKnotPosition])
      }
      
      //printBoard(knots: knots)
    }
    
    //printLastKnotTrail(knotPositions: tailPositions)
    return tailPositions.count
  }
  
  private func newHeadPosition(_ head: Position, direction: Direction) -> Position {
    switch direction {
    case .Right: return Position(x: head.x + 1, y: head.y)
    case .Left: return Position(x: head.x - 1, y: head.y)
    case .Up: return Position(x: head.x, y: head.y + 1)
    case .Down: return Position(x: head.x, y: head.y - 1)
    }
  }
  
  fileprivate func newTrailingKnotPosition(_ tail: Position, head: Position) throws -> Position {
    if tailDoesNotNeedToMove(tail: tail, head: head) { return tail }
    
    if head.x == tail.x {
      if head.y > tail.y {
        return Position(x: tail.x, y: tail.y + 1)
      } else {
        return Position(x: tail.x, y: tail.y - 1)
      }
    } else if head.y == tail.y {
      if head.x > tail.x {
        return Position(x: tail.x + 1, y: tail.y)
      } else {
        return Position(x: tail.x - 1, y: tail.y)
      }
    }
    
    if head.x > tail.x && head.y > tail.y {
      return Position(x: tail.x + 1, y: tail.y + 1)
    } else if head.x < tail.x && head.y < tail.y {
      return Position(x: tail.x - 1, y: tail.y - 1)
    } else if head.x > tail.x && head.y < tail.y {
      return Position(x: tail.x + 1, y: tail.y - 1)
    } else if head.x < tail.x && head.y > tail.y {
      return Position(x: tail.x - 1, y: tail.y + 1)
    }
    
    throw AoCError.GeneralError("Could not determine position")
    
  }
  
  private func tailDoesNotNeedToMove(tail: Position, head: Position) -> Bool {
    let xDiff = abs(tail.x - head.x)
    let yDiff = abs(tail.y - head.y)
    return yDiff <= 1 && xDiff <= 1
  }
  
  private func printBoard(knots: [Position]) {
    print("Head: \(knots.first!.location). Tail: \(knots.last!.location)")
    let lowX = knots.map({ $0.x }).sorted().first! - 1
    let highX = knots.map({ $0.x }).sorted().last! + 1
    let lowY = knots.map({ $0.y }).sorted().first! - 1
    let highY = knots.map({ $0.y }).sorted().last! + 1
    
    
    for y in stride(from: highY + 1, to: lowY - 1, by: -1) {
      let printable = (lowX...highX).map({ x in
        let posish = Position(x: x, y: y)
        if let index = knots.firstIndex(of: posish) {
          let distance = knots.distance(from: knots.startIndex, to: index)
          if distance == 0 { return "H" }
          if distance == knots.count - 1 { return "T" }
          return "\(distance)"
        }
        return "."
      }).joined()
      
      print(printable)
    }
  }
  
  fileprivate func printLastKnotTrail(knotPositions: Set<Position>) {
    let knotsArray = Array(knotPositions).sorted(by: { $0.x < $1.x && $0.y < $1.y})
    
    let lowX = knotsArray.map({ $0.x }).sorted().first! - 1
    let highX = knotsArray.map({ $0.x }).sorted().last! + 1
    let lowY = knotsArray.map({ $0.y }).sorted().first! - 1
    let highY = knotsArray.map({ $0.y }).sorted().last! + 1
    
    
    for y in stride(from: highY + 1, to: lowY - 1, by: -1) {
      let printable = (lowX...highX).map({ x in
        let posish = Position(x: x, y: y)
        if knotsArray.contains(posish) { return "#" }
        return "."
      }).joined()
      
      print(printable)
    }
  }
}

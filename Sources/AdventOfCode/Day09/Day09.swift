import Foundation
import Helpers

struct Position: Hashable {
  let x: Int
  let y: Int
  
  var location: String {
    "(\(x), \(y))"
  }
}

enum Direction: String {
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
    return doKnots(count: 2)
//    let steps = inputString.components(separatedBy: "\n")
//
//    var knots = [Position(x: 0, y: 0), Position(x: 0, y: 0)]
//
//    var tailPositions: Set<Position> = Set(arrayLiteral: knots[1])
//
//    for step in steps {
//      let components = step.components(separatedBy: " ")
//      let direction = Direction(rawValue: components[0])!
//      let count = Int(components[1])!
//
//      for _ in 0..<count {
//        knots[0] = newHeadPosition(knots[0], direction: direction)
//
//        for index in 1..<knots.count {
//          knots[index] = newTrailingKnotPosition(knots[index], head: knots[index - 1], direction: direction)
//        }
//
//        tailPositions.insert(knots[1])
//
//      }
//    }
//
//    return tailPositions.count
  }
  
  func calculatePart2() throws -> Int {
    return doKnots(count: 10)
    
    let steps = inputString.components(separatedBy: "\n")
    
    var knots = (0...9).map({ _ in Position(x: 0, y: 0) })
    
    let tailPositions: Set<Position> = Set(arrayLiteral: knots[9])
    printBoard(knots: knots)
    
    for step in steps {
      let components = step.components(separatedBy: " ")
      let direction = Direction(rawValue: components[0])!
      let count = Int(components[1])!

      
      for _ in 0..<count {
        // move the head
        knots[0] = newHeadPosition(knots[0], direction: direction)
        
        let oldKnot1 = knots[1]
        knots[1] = newTrailingKnotPosition(knots[1], head: knots[0], direction: direction)
        var direction = directionJustMoved(oldPosition: oldKnot1, newPosition: knots[1])
        
        for index in 2..<knots.count {
    
          if direction != nil {
            let oldKnot = knots[index]
            knots[index]  = newTrailingKnotPosition(knots[index], head: knots[index - 1], direction: direction!)
            direction = directionJustMoved(oldPosition: oldKnot, newPosition: knots[index])
          }
          
        }
      }
    }
    
    return tailPositions.count
  }
  
  func doKnots(count: Int) -> Int {
    let steps = inputString.components(separatedBy: "\n")
    
    var knots = (0..<count).map({ _ in Position(x: 0, y: 0) })
    
    let lastKnotPosition = count - 1
    
    var tailPositions: Set<Position> = Set(arrayLiteral: knots[lastKnotPosition])
    printBoard(knots: knots)
    
    for step in steps {
      print("STEP: \(step)")
      let components = step.components(separatedBy: " ")
      let direction = Direction(rawValue: components[0])!
      let count = Int(components[1])!
      
      for _ in 0..<count {
        // move the head
        knots[0] = newHeadPosition(knots[0], direction: direction)
        let oldKnot1 = knots[1]
        let knewKnot1 = newTrailingKnotPosition(knots[1], head: knots[0], direction: direction)
        
        knots[1] = knewKnot1
        // Problem with the direction because it moves diagnol
        // and that shouldn't be a direction
        var direction = directionJustMoved(oldPosition: oldKnot1, newPosition: knots[1])
        
        if let direction = direction {
          print("Direction jsut moved for tail knot: \(direction)")
        } else {
          print("Tail knot did not move")
        }
       
        if knots.count <= 2 {
          tailPositions.insert(knots[lastKnotPosition])
          continue
        }
        
        for index in 2..<knots.count {
          if direction != nil {
            let oldKnot = knots[index]
            knots[index]  = newTrailingKnotPosition(knots[index], head: knots[index - 1], direction: direction!)
            direction = directionJustMoved(oldPosition: oldKnot, newPosition: knots[index])
          }
        }
        
        tailPositions.insert(knots[lastKnotPosition])
      }
    }
    
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
  
  func newTrailingKnotPosition(_ tail: Position, head: Position, direction: Direction) -> Position {
    if tailDoesNotNeedToMove(tail: tail, head: head) { return tail }

    switch direction {
    case .Right: return Position(x: head.x - 1, y: head.y)
    case .Left: return Position(x: head.x + 1, y: head.y)
    case .Up: return Position(x: head.x, y: head.y - 1)
    case .Down: return Position(x: head.x, y: head.y + 1)
    }
    
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
    
    
    for y in stride(from: highY, to: lowY, by: -1) {
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
  
  private func directionJustMoved(oldPosition: Position, newPosition: Position) -> Direction? {
    if oldPosition == newPosition { return nil }
    if newPosition.x > oldPosition.x { return .Right }
    if newPosition.x < oldPosition.x { return .Left }
    if newPosition.y > oldPosition.y { return .Up }
    if newPosition.y < oldPosition.y { return .Down }
    return nil
  }
}

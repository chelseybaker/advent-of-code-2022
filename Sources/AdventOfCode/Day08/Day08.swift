import Foundation
import Helpers

struct Day08: AoCPrintable {
  
  let inputString: String
  
  func calculatePart1() throws -> Int {
    let matrix: [[Int]] = inputString
      .components(separatedBy: "\n")
      .map({ Array($0).map({ String($0) }).map({ Int($0)! }) })
    
    var count = 0
    
    for y in 0..<matrix.count {
      for x in 0..<matrix[y].count {
        
        // Edges are always visible
        if y == 0 || y == (matrix.count - 1) {
          count += 1
          continue
        }
        
        if x == 0 || x == (matrix[y].count - 1) {
          count += 1
          continue
        }
        
        let treeHeight = matrix[y][x]
        
        let visibleFromLeft = matrix[y][0..<x]
          .filter({ treeHeight <= $0 })
          .count == 0
        
        let visibleFromRight = matrix[y][(x + 1)...]
          .filter({ treeHeight <= $0 })
          .count == 0
        
        let visibleFromTop = (0...(y - 1))
          .map({ matrix[$0][x] })
          .filter({ treeHeight <= $0 })
          .count == 0
        
        let visibleFromBottom = ((y + 1)...(matrix.count - 1))
          .map({ matrix[$0][x] })
          .filter({ treeHeight <= $0 })
          .count == 0
        
        if visibleFromRight || visibleFromLeft || visibleFromTop || visibleFromBottom {
          count += 1
        }
        
      }
    }
    
    return count
  }
  
  func calculatePart2() throws -> Int {
    let matrix: [[Int]] = inputString
      .components(separatedBy: "\n")
      .map({ Array($0).map({ String($0) }).map({ Int($0)! }) })

    var highestTreeCount = -1
    
    for y in 0..<matrix.count {
      for x in 0..<matrix[y].count {
        
        if x == 0 || x == (matrix[y].count - 1) {
          continue
        }
        
        if y == 0 || y == (matrix.count - 1) {
          continue
        }

        let treeHeight = matrix[y][x]
        
        let rightSide = Array(matrix[y][(x + 1)...])
        let rightIndex = rightSide.firstIndex(where: { $0 >= treeHeight })
        let rightValue = rightIndex != nil ? rightSide.distance(from: rightSide.startIndex, to: rightIndex!) + 1 : (matrix[y].count - x - 1)
        
        let leftSide = Array(matrix[y][0...(x - 1)].reversed())
        let leftIndex = leftSide.firstIndex(where: { $0 >= treeHeight })
        let leftValue = leftIndex != nil ? leftSide.distance(from: leftSide.startIndex, to: leftIndex!) + 1 : x
        
        let topSide = Array((0...(y - 1)).map({ matrix[$0][x] }).reversed())
        let topIndex = topSide.firstIndex(where: { $0 >= treeHeight })
        let topValue = topIndex != nil ? topSide.distance(from: topSide.startIndex, to: topIndex!) + 1 : y
        
        let bottomSide = ((y + 1)...(matrix[y].count - 1)).map({ matrix[$0][x] })
        let bottomIndex = bottomSide.firstIndex(where: { $0 >= treeHeight })
        let bottomValue = bottomIndex != nil ? bottomSide.distance(from: bottomSide.startIndex, to: bottomIndex!) + 1 : matrix.count - y - 1
        
        let treeValue = topValue * rightValue * leftValue * bottomValue
        
        if treeValue > highestTreeCount {
          highestTreeCount = treeValue
        }
      }
    }
    
    return highestTreeCount
  }
}

import Foundation
import Helpers

struct Day12: AoCPrintable {
  let inputString: String
  
  func calculatePart1() throws -> Int {
    let grid = createDijkstraGrid()
    
    guard let startNode = grid
      .flatMap({ $0 })
      .filter({ $0.value == "S" })
      .first else {
      throw AoCError.GeneralError("Did not correctly parse input")
    }
    
    return startNode.distance!
  }
  
  func calculatePart2() throws -> Int {
    let grid = createDijkstraGrid()
    let aValues: [Node] = grid
      .flatMap({ $0 })
      .filter({ $0.distance != nil })
      .filter({ $0.value == "S" || $0.value == "a" })
    
    let sorted = aValues.sorted(by: { $0.distance! < $1.distance! })
    return sorted.first!.distance!
  }
  
  private func createDijkstraGrid() -> [[Node]] {
    let letterGrid = inputString
      .components(separatedBy: "\n")
      .map({ Array($0).map({ String($0) }) })
    
    var nodeGrid = [[Node]]()
    var currentNode: Node? = nil
    
    for rowIndex in 0..<letterGrid.count {
      var rowVertex = [Node]()
      for columnIndex in 0..<letterGrid[rowIndex].count {
        let vertex = Node(row: rowIndex, col: columnIndex, value: letterGrid[rowIndex][columnIndex])
        
        if vertex.value == "E" {
          vertex.distance = 0
          currentNode = vertex
        }
        
        rowVertex.append(vertex)
      }
      nodeGrid.append(rowVertex)
    }
    
    while currentNode != nil {
      let newDistance = currentNode!.distance! + 1
      
      let neighbors = currentNode!.getUnvisitedNeighbors(nodeGrid)
      
      for nIndx in 0..<neighbors.count {
        let neighbor = neighbors[nIndx]
        if !neighbor.canTravelTo(currentNode!) { continue }
        if neighbor.distance == nil || newDistance < neighbor.distance! {
          neighbor.distance = newDistance
        }
      }
      
      currentNode!.visited = true
      currentNode = nodeGrid
        .flatMap({ $0 })
        .filter({ !$0.visited && $0.distance != nil })
        .sorted(by: { $0.distance! < $1.distance! })
        .first
    }
    
    return nodeGrid
  }
}

fileprivate class Node {
  let row: Int // Y position, outter array
  let col: Int // X position, inner array
  let value: String
  var distance: Int? = nil // Consider starting with infinity
  var visited = false
  
  init(row: Int, col: Int, value: String) {
    self.row = row
    self.col = col
    self.value = value
  }
}

extension Node: Hashable {
  static func == (lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(row)
    hasher.combine(col)
  }
}

fileprivate extension Node {
  func getAdjascentNodes(_ nodes: [[Node]]) -> [Node] {
    var verticies: [Node] = []
    
    let topRow = 0
    let bottomRow = nodes.count - 1
    
    if row != topRow { verticies.append(nodes[row - 1][col]) }
    if self.row != bottomRow { verticies.append(nodes[row + 1][col]) }
    
    let leftRow = 0
    let rightRow = nodes[row].count - 1
    
    if self.col != leftRow { verticies.append(nodes[row][col - 1]) }
    
    if self.col != rightRow { verticies.append(nodes[row][col + 1]) }
    
    
    return verticies
  }
  
  func getUnvisitedNeighbors(_ nodes: [[Node]]) -> [Node] {
    getAdjascentNodes(nodes).filter({ !$0.visited })
  }
}

fileprivate extension Node {
  // vertex is at most one higher than self
  func canTravelTo(_ node: Node) -> Bool {
    // S is at elevation a
    if self.value == "S" { return node.value == "a" || node.value == "b" }
    // E is at elevation z
    if node.value == "E" { return self.value == "y" || self.value == "z" }
    if node.value == "S" { return self.value == "a" }
    if node.value <= self.value { return true }
    // Determine if vertex.value is one above self.value
    
    let letters = "abcdefghijklmnopqrstuvwxyz".map({ String($0) })
    let indexOfSelf = letters.firstIndex(of: self.value)
    let indexOfVertex = letters.firstIndex(of: node.value)
    return letters.distance(from: indexOfSelf!, to: indexOfVertex!) <= 1
  }
}

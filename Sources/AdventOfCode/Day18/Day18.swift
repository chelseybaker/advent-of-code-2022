import Foundation
import Helpers

struct Day18: AoCPrintable {
  let inputString: String
  
  func calculatePart1() throws -> Int {
    let lavaCubes = Set(try inputString
      .components(separatedBy: "\n")
      .map({ try Cube(fromString: $0) }))
    
    
    for cube in lavaCubes {
      let touchingCubes = lavaCubes.filter({ cube.unknownSides.contains( $0.coordinate) })
      
      for var touchedCube in touchingCubes {
        cube.markAsTouching(&touchedCube)
      }
    }
    
    return lavaCubes.map({ $0.unknownSides.count }).reduce(0, +)
  }
  
  func calculatePart2() throws -> Int {
    let lavaCubes = Set(try inputString
      .components(separatedBy: "\n")
      .map({ try Cube(fromString: $0) }))
    
    for cube in lavaCubes {
      let touchingCubes = lavaCubes.filter({ cube.unknownSides.contains( $0.coordinate) })
      
      for var touchedCube in touchingCubes {
        cube.markAsTouching(&touchedCube)
      }
    }
    
    let xValues = lavaCubes.map({ $0.coordinate.x }).sorted()
    let yValues = lavaCubes.map({ $0.coordinate.y }).sorted()
    let zValues = lavaCubes.map({ $0.coordinate.z }).sorted()
    
    let lowX = xValues.first!
    let highX = xValues.last!
    let lowY = yValues.first!
    let highY = yValues.last!
    let lowZ = zValues.first!
    let highZ = zValues.last!
    
    
    var allAirCubes: Set<Cube> = []
    
    for x in lowX...highX {
      for y in lowY...highY {
        for z in lowZ...highZ {
          let newCube = Cube(x: x, y: y, z: z)
          if lavaCubes.contains(newCube) { continue }
          allAirCubes.insert(newCube)
        }
      }
    }
    
    var outsideAirCubes = allAirCubes.filter({
      $0.coordinate.x == lowX ||
      $0.coordinate.x == highX ||
      $0.coordinate.y == lowY ||
      $0.coordinate.y == highY ||
      $0.coordinate.z == lowZ ||
      $0.coordinate.z == highZ
    })
    
    var insideAirCubes = allAirCubes - outsideAirCubes
    
    var keepGoing = true
    while keepGoing {
      keepGoing = false
      for insideAirCube in insideAirCubes {
        let outsideCoordinates: Set<Coordinate> = Set(outsideAirCubes.map({ $0.coordinate }))
        
        let unknownSides: Set<Coordinate> = insideAirCube.unknownSides
        
        if unknownSides.overlaps(outsideCoordinates) {
          insideAirCubes.remove(insideAirCube)
          outsideAirCubes.insert(insideAirCube)
          keepGoing = true
        }
      }
    }
    
    let lavaUnknownSides = lavaCubes.flatMap({ $0.unknownSides })
    let insideCubes = insideAirCubes.map({ $0.coordinate })
    let outsideOnly: [Coordinate] = lavaUnknownSides.filter({ !insideCubes.contains($0) })
    
    return outsideOnly.count
  }
  
}

fileprivate class Coordinate {
  let x: Int
  let y: Int
  let z: Int
  
  init(x: Int, y: Int, z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }
}

fileprivate class Cube {
  let coordinate: Coordinate
  
  let allSides: Set<Coordinate>
  
  var unknownSides: Set<Coordinate>
  
  var touchingCubes: Set<Cube> = []
  
  init(x: Int, y: Int, z: Int) {
    
    self.coordinate = Coordinate(x: x, y: y, z: z)
    
    self.allSides = Set([
      Coordinate(x: x + 1, y: y, z: z), // right
      Coordinate(x: x - 1, y: y, z: z), // left
      Coordinate(x: x, y: y + 1, z: z), // top
      Coordinate(x: x, y: y - 1, z: z), // bottom
      Coordinate(x: x, y: y, z: z + 1), // front
      Coordinate(x: x, y: y, z: z - 1), // back
    ])
    
    self.unknownSides = Set([
      Coordinate(x: x + 1, y: y, z: z), // right
      Coordinate(x: x - 1, y: y, z: z), // left
      Coordinate(x: x, y: y + 1, z: z), // top
      Coordinate(x: x, y: y - 1, z: z), // bottom
      Coordinate(x: x, y: y, z: z + 1), // front
      Coordinate(x: x, y: y, z: z - 1), // back
    ])
  }
  
  convenience init(fromString value: String) throws {
    let components = value.components(separatedBy: ",")
    guard components.count == 3 else {
      throw AoCError.GeneralError("Cannot parse \(value) as Cube")
    }
    
    guard let x = Int(components[0]), let y = Int(components[1]), let z = Int(components[2]) else {
      throw AoCError.GeneralError("Cannot parse \(value) as Cube")
    }
    
    self.init(x: x, y: y, z: z)
  }
  
  func markSideAsKnown(_ coordinate: Coordinate) {
    unknownSides = unknownSides.filter({ $0 != coordinate })
  }
  
  func markAsTouching(_ cube: inout Cube) {
    self.unknownSides = self.unknownSides.filter({ $0 != cube.coordinate })
    self.touchingCubes.insert(cube)
    
    cube.unknownSides = cube.unknownSides.filter({ $0 != self.coordinate })
    cube.touchingCubes.insert(self)
  }
}

extension Coordinate: Equatable {
  static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
  }
}

extension Coordinate: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
    hasher.combine(z)
  }
}

extension Cube: Equatable {
  static func == (lhs: Cube, rhs: Cube) -> Bool {
    lhs.coordinate == rhs.coordinate
  }
}

extension Cube: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(coordinate)
  }
}

extension Set where Element == Cube {
  static func - (lhs: Set<Cube>, rhs: Set<Cube>) -> Set<Cube> {
    return lhs.filter({ !rhs.contains($0) })
  }
}

extension Set where Element == Coordinate {
  // true if the sets contain at least one overlapping element
  func overlaps(_ coordinateSet: Set<Coordinate>) -> Bool {
    for item in coordinateSet {
      if self.contains(item) { return true }
    }
    return false
  }
}

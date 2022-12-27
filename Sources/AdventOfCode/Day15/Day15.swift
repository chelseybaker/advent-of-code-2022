import Foundation
import Helpers
import RegexBuilder

struct Day15: AoCPrintable {
  
  let inputString: String
  
  func calculatePart1() throws -> Int {
    let sensors = try inputString
      .components(separatedBy: "\n")
      .map({ try Sensor($0) })
    let yRow = sensors.count == 14 ? 10 : 2000000
    return calculateNoBeacon(sensors: sensors, yRow: yRow).count
  }
  
  func calculatePart2() throws -> Int {
    let sensors = try inputString
      .components(separatedBy: "\n")
      .map({ try Sensor($0) })
  
      let min = 0
      let max = sensors.count == 14 ? 20 : 4000000
    
    for y in min...max {
      let xs = allMissingXsForY(sensors: sensors, yRow: y, min: min, max: max)
      if xs.count == 2 {
        let beaconPosition = Position(x: xs[0].upperBound + 1, y: y)
        return beaconPosition.x * 4000000 + beaconPosition.y
      } else if xs.count > 1 {
        throw AoCError.GeneralError("Problem with logic")
      }
    }
    
    throw AoCError.GeneralError("Problem with logic")
  }
  
  fileprivate func allMissingXsForY(sensors: [Sensor], yRow: Int, min: Int? = nil, max: Int? = nil) -> Array<ClosedRange<Int>> {
    let xRanges = sensors.compactMap { getXsForY(sensor: $0, yRow: yRow) }
    var xSet = Set<ClosedRange<Int>>(xRanges)
  
    xSet.mergeRanges(min: min, max: max)
    
    return Array(xSet).sorted(by: { $0.lowerBound < $1.lowerBound })
  }
  
  fileprivate func getXsForY(sensor: Sensor, yRow: Int) -> ClosedRange<Int>? {
    if !sensor.overlapsYRow(yRow) { return nil }
    let sensorPosition = sensor.sensorPosition
    
    let distance = abs(yRow - sensorPosition.y)
    let diff = abs(distance - sensor.manhattanDistance)
    
    let boxXMin = -diff + sensorPosition.x
    let boxXMax = diff + sensorPosition.x
    return (boxXMin...boxXMax)
  }
  
  fileprivate func calculateNoBeacon(sensors: [Sensor], yRow: Int, low: Int? = nil, high: Int? = nil, includeBeacons: Bool? = false) -> Set<Int> {

    let xs = Set(sensors
      .filter({ $0.overlapsYRow(yRow) })
      .flatMap({ $0.calculateAllPositions(overlappingRow: yRow, low: low, high: high, includeBeacons: includeBeacons) })
      .map({ $0.x }))
    
    return xs
  }
}

fileprivate struct Position: Equatable {
  let x: Int
  let y: Int
}

fileprivate struct Sensor {
  let sensorPosition: Position
  let beaconPosition: Position
  let manhattanDistance: Int
  
  init(_ value: String) throws {
    guard #available(macOS 13.0, *) else {
      throw AoCError.GeneralError("Must be using macOS 13 to use the regex ")
    }
    let negativeNumRegex = #/[-|0-9]/#
    let reg = Regex {
      "Sensor at x="
      Capture {
        OneOrMore(negativeNumRegex)
      }
      ", y="
      Capture {
        OneOrMore(negativeNumRegex)
      }
      ": closest beacon is at x="
      Capture {
        OneOrMore(negativeNumRegex)
      }
      ", y="
      Capture {
        OneOrMore(negativeNumRegex)
      }
      Optionally{
        One(.newlineSequence)
      }
    }
    
    let matches = value.matches(of: reg)
    guard matches.count == 1 else {
      throw AoCError.GeneralError("Cannot parse string as Sensor")
    }
    
    let match = matches[0]
    
    let (_, sensorX, sensorY, beaconX, beaconY) = match.output

    guard let sX = Int(sensorX), let sY = Int(sensorY), let bX = Int(beaconX), let bY = Int(beaconY) else {
      throw AoCError.GeneralError("Cannot parse string as Sensor")
    }
    
    self.sensorPosition = Position(x: sX, y: sY)
    self.beaconPosition = Position(x: bX, y: bY)
    
    let manhattenDistance = abs(sX - bX) + abs(sY - bY)
    
    self.manhattanDistance = manhattenDistance
  }
  
  func overlapsYRow(_ yRow: Int) -> Bool {
    // sensor y = 0, manhattan = 9, yrow = -5
    if self.sensorPosition.y == yRow { return true }
    
    if self.sensorPosition.y > yRow && self.sensorPosition.y - manhattanDistance < yRow { return true }
    
    // sensor y = 0, manhattan = 9, yrow = 5
    if self.sensorPosition.y < yRow && self.sensorPosition.y + manhattanDistance > yRow { return true }
    
    return false
  }
  
  func calculateAllPositions(overlappingRow: Int, low: Int? = nil, high: Int? = nil, includeBeacons: Bool? = false) -> [Position] {
    var positions: [Position] = []

    let distance = abs(overlappingRow - sensorPosition.y)
    let diff = abs(distance - manhattanDistance)
    let boxXMin = -diff + sensorPosition.x
    let boxXMax = diff + sensorPosition.x
    
    let minX = low != nil ? max(low!, boxXMin) : boxXMin
    let maxX = high != nil ? min(high!, boxXMax) : boxXMax
    
    for x in minX...maxX {
      positions.append(Position(x: x, y: overlappingRow))
    }
    
    if let low = low, let high = high {
      positions = positions.filter({ $0.x >= low && $0.x <= high && $0.y >= low && $0.y <= high })
    }
    
    if let includeBeacons = includeBeacons, includeBeacons {
      return positions
    }
    
    return positions.filter({ $0 != beaconPosition })
  }
}

extension Set<ClosedRange<Int>> {
  mutating func mergeRanges(min: Int?, max: Int?) {
    let sortedArray = Array(self).sorted(by: {$0.lowerBound < $1.lowerBound })
    let reducedSets = sortedArray.reduce([] as [ClosedRange<Int>]) { arr, range in
      guard let overlaps = arr.first(where: { $0.overlaps(range) }) else {
        return arr + [range]
      }
      let newRange = (Swift.min(overlaps.lowerBound, range.lowerBound))...(Swift.max(overlaps.upperBound, range.upperBound))
      return arr.filter({ $0 != overlaps }) + [newRange]
    }
    
    guard let min = min, let max = max else {
      self = Set(reducedSets)
      return
    }
    
    self = Set(reducedSets.map({ (Swift.max(min, $0.lowerBound))...(Swift.min(max, $0.upperBound)) }))
  }
}

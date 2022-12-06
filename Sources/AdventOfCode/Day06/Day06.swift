import Foundation
import Helpers

struct Day06: AoCPrintable {
  
  let inputString: String
  
  func calculatePart1() throws -> Int {
    calculatePacketStart(from: inputString, markerCount: 4)
  }
  
  func calculatePart2() throws -> Int {
    calculatePacketStart(from: inputString, markerCount: 14)
  }
  
  private func calculatePacketStart(from inputString: String, markerCount: Int) -> Int {
    for i in 0..<(inputString.count - markerCount - 1) {
      let set = Set(inputString[i...(i + markerCount - 1)])
      if set.count == markerCount { return i + markerCount }
    }
    return 0
  }
}

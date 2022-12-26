import Foundation
import Helpers
import RegexBuilder

@available(macOS 13.0, *)
struct Day16: AoCPrintable {
  
  let inputString: String
  
  /**
   
   Use Dijextra but doing the highest number?
   to A? 
   */
  
  func calculatePart1() throws -> Int {
//    let valves = try inputString.components(separatedBy: "\n").map({ try Valve(fromString: $0) })
//    
//    var currentValve = valves.filter({ $0.name == "AA" }).first!
//    
//    var pressureRelease = 0
//    
//    for minute in 1...30 {
//      print("== Minute \(minute) ")
//      let numberOfOpenValves = valves.filter({ $0.open }).count
//      
//      if numberOfOpenValves == 0 {
//        print("No valves open")
//      } else {
//        let valves = valves.filter({$0.open})
//        for valve in valves {
//          print("Valve \(valve.name) is releasing \(valve.flowRate) pressure ")
//        }
//      }
//      
//      pressureRelease += valves.filter({ $0.open }).map({ $0.flowRate }).reduce(0, +)
//      
//      print("Currently releasing \(pressureRelease) pressure ")
//      if currentValve.open || currentValve.name == "AA" {
////        let nextValve = valves
////          .filter({ currentValve.leadsTo.contains($0.name) && !$0.open })
////          .sorted(by: { $0.flowRate > $1.flowRate })
////          .first!
//        // one minute to move, one minute to open
//        print("Moving to valve \(nextValve.name)")
//        currentValve = nextValve
//      } else {
//        currentValve.setOpen()
//        print("You open valve \(currentValve.name)")
//      }
//    }
    
    throw AoCError.NotYetImplemented
  }
  
  func calculatePart2() throws -> Int {
    throw AoCError.NotYetImplemented
  }
}

@available(macOS 13.0, *)
class Valve {
  let name: String
  let flowRate: Int
  let leadsTo: [String]
  private(set) var open = false
  
  init(fromString valueString: String) throws {
    let reg = Regex {
      "Valve "
      Capture {
        OneOrMore(.word)
      }
      " has flow rate="
      Capture {
        OneOrMore(.digit)
      }
      ChoiceOf {
        "; tunnels lead to valves "
        "; tunnel leads to valve "
        "; tunnels lead to valve "
        "; tunnel leads to valves "
      }
      Capture {
        OneOrMore {
          NegativeLookahead { .newlineSequence }
          CharacterClass.any
        }
      }
      Optionally{
        One(.newlineSequence)
      }
    }
    
    let matches = valueString.matches(of: reg)
    guard matches.count == 1 else {
      throw AoCError.GeneralError("Cannot parse string as Valve")
    }
    let match = matches[0]
    
    let (_, valve, flow, tunnels) = match.output
    self.name = String(valve)
    self.flowRate = Int(flow)!
    self.leadsTo = tunnels.components(separatedBy: ", ").map({ String($0) })
  }
  
  func setOpen() {
    self.open = true
  }
}

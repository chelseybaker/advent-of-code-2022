import Foundation
import Helpers

struct Day10: AoCPrintable {
  
  let inputString: String
  /**
   addx V takes two cycles to complete. After two cycles, the X register is increased by the value V. (V can be negative.)
   noop takes one cycle to complete. It has no other effect.
   */
  
  // 20th, 60th, 100th, 140th, 180th, and 220th cycles.
  func calculatePart1() throws -> Int {
    let steps = inputString.components(separatedBy: "\n")
    
    var cycle = 0 // Cycle is updated after instructions
    var currentStrength = 1
    var signalStrengths: [Int] = [currentStrength]
    
    // Signal strength at cycle x is signalStrengths[x - 1]
    for step in steps {
      if step.starts(with: "noop") {
        signalStrengths.append(currentStrength)
        cycle += 1
      } else if step.starts(with: "addx") {
        let amount = Int(step.components(separatedBy: " ")[1])!
        
        for _ in 0...1 {
          signalStrengths.append(currentStrength)
          cycle += 1
        }
        
        currentStrength += amount
      }
    }
    
    return [20, 60, 100, 140, 180, 220].map({ signalStrengths[$0] * $0 }).reduce(0, +)
    
  }

  // The X register controls the horizontal position of a sprite.
  // Specifically, the sprite is 3 pixels wide, and
  // the X register sets the horizontal position of the middle of that sprite.
  
  // So current strength is the middle pixel
  // So if the cycle == currentStrength -1, current strength or current strength + 1, draw a #
  //

  func calculatePart2() throws -> Int {
    let steps = inputString.components(separatedBy: "\n")
    
    var cycle = 0 // Cycle is updated after instructions
    var currentStrength = 1
    var signalStrengths: [Int] = [currentStrength]
    
    // Signal strength at cycle x is signalStrengths[x - 1]
    for step in steps {
      if step.starts(with: "noop") {
        signalStrengths.append(currentStrength)
        cycle += 1
      } else if step.starts(with: "addx") {
        let amount = Int(step.components(separatedBy: " ")[1])!
        
        for _ in 0...1 {
          signalStrengths.append(currentStrength)
          cycle += 1
        }
        
        currentStrength += amount
      }
    }
    
    // Cycle is index
    var pixels: [String] = []
    for index in 1..<signalStrengths.count {
        print("Cycle \(index) Row \((index - 1) / 40), position \((index - 1) % 40) is \(signalStrengths[index])")
      
      let row = (index - 1) / 40
      let position = (index - 1) % 40
      let signalStrength = signalStrengths[index]
      
      if [signalStrength - 1, signalStrength, signalStrength + 1].contains(position) {
        pixels.append("#")
      } else {
        pixels.append(".")
      }
    }
    
    for row in 0..<6 {
      let line = String(pixels[(row * 40)..<(row * 40 + 40)].joined())
      print(line)
    }
    return 0
  }
  
}

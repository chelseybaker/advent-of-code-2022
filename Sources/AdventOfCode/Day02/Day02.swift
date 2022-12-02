// https://adventofcode.com/2022/day/2

import Foundation
import Helpers

enum RPS {
  case Rock
  case Paper
  case Scissors
  
  init(from letter: String) throws {
    switch letter {
    case "A", "X": self = .Rock
    case "B", "Y": self = .Paper
    case "C", "Z": self = .Scissors
    default: throw AoCError.GeneralError("Invalid letter: \(letter)")
    }
  }
  
  init(from outcome: GameOutcome, opponent: RPS) throws {
    switch outcome {
    case .Draw: self = opponent
    case .Win: self = opponent.losesTo
    case .Lose: self = opponent.defeats
    }
  }
  
  // Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock.
  var defeats: RPS {
    switch self {
    case .Rock: return .Scissors
    case .Paper: return .Rock
    case .Scissors: return .Paper
    }
  }
  
  var losesTo: RPS {
    switch self {
    case .Scissors: return .Rock
    case .Rock: return .Paper
    case .Paper: return .Scissors
    }
  }
  
  var score: Int {
    switch self {
    case .Rock: return 1
    case .Paper: return 2
    case .Scissors: return 3
    }
  }
  
  func outcome(with opponent: RPS) -> GameOutcome {
    if self == opponent { return .Draw }
    if self.defeats == opponent { return .Win }
    return .Lose
  }
}

enum GameOutcome: String {
  case Lose = "X"
  case Draw = "Y"
  case Win = "Z"
  
  var score: Int {
    switch self {
    case .Lose: return 0
    case .Draw: return 3
    case .Win: return 6
    }
  }
}

struct Day02: AoCPrintable {
  
  private let inputString: String
  
  init(inputString: String = Day02Input.Input) {
    self.inputString = inputString
  }
  
  func calculatePart1() throws -> Int {
    let rounds = inputString.split(separator: "\n")
    
    return rounds.map({ round in
      let components = round.components(separatedBy: " ")
      let opponent = try! RPS(from: components[0])
      let myself = try! RPS(from: components[1])
      return myself.outcome(with: opponent).score + myself.score
    }).reduce(0, +)
  }
  
  func calculatePart2() throws -> Int {
    let rounds = inputString.split(separator: "\n")
    
    return rounds.map({ round in
      let components = round.components(separatedBy: " ")
      let opponent = try! RPS(from: components[0])
      let outcome = GameOutcome(rawValue: components[1])!
      let myself = try! RPS(from: outcome, opponent: opponent)
      return myself.score + outcome.score
    }).reduce(0, +)
  }
}

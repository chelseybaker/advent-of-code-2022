//
//  AoCPrintable.swift
//  
//
//  Created by Chelsey Baker on 11/27/22.
//

import Foundation

public protocol AoCPrintable {
  func calculatePart1() throws -> Int
  
  func calculatePart2() throws -> Int
}

public extension AoCPrintable {
  func prettyPrint() {
    let part1Int = try? calculatePart1()
    let part2Int = try? calculatePart2()
    
    let part1 = part1Int != nil ? "\(part1Int!)" : "---"
    let part2 = part2Int != nil ? "\(part2Int!)" : "---"
    
    let day = String(describing: Self.self)
    
    print("\(day)")
    print("Part 1: \(part1)")
    print("Part 2: \(part2)")
  }
}

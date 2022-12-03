import Foundation
import Helpers

print("Advent of Code 2022")
let days: [AoCPrintable] = [Day01(), Day02(), Day03()]
for day in days {
  day.prettyPrint()
}

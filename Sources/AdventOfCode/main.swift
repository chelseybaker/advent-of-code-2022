import Foundation
import Helpers

print("Advent of Code 2022")

let days: [AoCPrintable] = [
  Day01(), Day02(), Day03(), Day04(), Day06(), Day07(),
  Day08(), Day13()
]

for day in days {
  day.prettyPrint()
}

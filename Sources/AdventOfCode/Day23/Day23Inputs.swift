import Foundation
import Helpers

struct Day23Input {
  static let PracticeSmall = """
.....
..##.
..#..
.....
..##.
.....
"""
  
  static let Practice = """
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
"""
  
  static let Input = """
#.#.#.#.......##.#.####......#...###.#.#..#.#.##.#.#...#...###.#.######...
.##.###.###.#...###.#.........#...##.##.#.#...#...##.....##.##.#.#.#...#.#
#####.#....##..#.##.####....##.###.....###.##..#..##..#.#.#...###.##.#...#
..#..######..##.##..##...###.#...#.####.#.##.##...###...##...#.#...#.#..#.
####..##.##.#.#....#.#.#.....#######..#...#####.##....#.##..##.#.###.#.###
##..###....##..#.##.###.#####.#.#..##..#......##.##..###.##.#.####.#.#.###
..###...#.#.###.##.#.#..#...##.#..#.###.##..#...#..###...#.####.#.#...##.#
...#.#....##.##.......#.#...#.......#.#....#..###...##...###..#...#.###.##
..#.....###..##.#..##.#..##.#.##.#.#.#.#.###...##.####.#.##.##...#.####..#
##.##.######..##...#...#.#.#.#.....#.#.#..#..#....##..#.....#.#.#...#...#.
#####.#.#.###..##.##.#...##.#.#.#.####....#..#.####.#####.#.###...#.###.#.
.#.###.#.###..#..#.#.#########...###.......##..#..##.#......####...#......
###..........##...#.##.#..#.###.#..####.###.#.###.##..##..#####....####..#
..#.##.....####.#..#.##.##...###.#.###.#.#.######..##.#.######....#..##..#
#....#####.####..####..###.####..#.....####....#.###.###..#...#.###....#..
##..#..#..#....##...#..#.#..#..........##.#.###..#.##.#...#...#...##..##..
#.##..##.#....#.#.#..#....##.#....##.##.#..###.#...##.##....#..#####.###.#
..###......#.#.##.##...##...#####..##..#.#..#..###..#.#.#.###.#.###.######
#.#..#......#.#.##.###.###...#..###..#.#.#.##.##.###...##..#.##.....#..###
#..#....#.##..#.#.#..#.####.###.###.##..#.##########...#######..#######...
.#....####.##.#..##......#...##.##..####....###....##.##.###.##.#.#####.#.
###....###..####..#.##..#...#.#.###......#.#........###..#.#..##....#..###
.#..#.#..#.#####..##..###..#..####.###.#..#.##..#..###.......###.###...#.#
##.#..##..##.#...#...#.##........#..####.##.##.##.###..#..##.##.#...##.###
.#...###.....##.#.#....#..#.##.##.#.#...#..######.###...##.#.##...#...###.
..#..#..##.##.#.........###..#..###.....#..##.##..#.###..##.###.####..##..
..#...###...##.#.##......###.####.##..#...#.#...###.#.##..#...#.##.###.##.
###.#.#.....##.....###...####.#...##.#.######.##...#..##....#......##.....
.###........#.#...###.###.#..#.#.#.#.###.#...##.###.......#.##.#.###...#.#
....###...##.##.#...##..###..#.##......#.########...##.##.##.#...#.###....
###.##.#.#..##..##........#.#.....##.##.#...#..#.####....#..##.##.###...#.
##..#.#..#..###..##...##.#.#.###.####...#.#####..##..###..#..#..########..
####.##.##..####.#..#.#....##.##..#....#.#..#...####.#.#..####..#.#...##..
##..###.#..####....#.#.#.####...#..####...###.####...#.#.#.###.##.##.####.
#........#..##.####...##..#.#.#.##.###..#..####..##..#...##.#.##.#.#....##
#.#...#.####.#..#.##.##.....#.##...##.#..#####..####.#####..#...##...#...#
####.......#.#.##.###.#.#.####.#.#......#.#..####..###.#........#.##.#....
....###.##..##..###.#......#####.##.#....##.##...#..#.###.##.##...#......#
###....##..#.#..#...##..#.#.###.##.#.....####.##.#.#..#..##.#.##.###...###
#.######.###.##...##.##..#.#####.#.#.#..##..#.#.#..#.#####.#..#..#.#.###.#
..##.#####.#.##...#...##.#.#..##..##....####..###..#..##.....#.#####.##...
###..####..#.#####.#...#.###.#.##..##.##...#.##.###.#.##...##..#######...#
.#####.#......#...###.###.###....#.#.....####.#.#..##.#.#.....##...###...#
..##.....#.##....##......#.##....#..#.#..#...#.###.###.##.###.#.#..##...#.
.#...#.#..##.#....##.#.##.##..#.#.#...##..##.#..#..###...##...#..#..###...
...#.#...#..#.#..#.......##.#.##.#######..#..#.###.#....###.##...#..##..##
...######.#.###..#...#.#.#...#..#....#..#.###....#.#..#...##..####.#..#.#.
..#####.#..#.##.#.#..#.#.###.#.#....#.##.##.#...#..#.###..#..#..#..#.##...
..##.#.#..#...##.......#..#...#.##.#.....#..#####.###....##.##.###.#.#..##
#..###...#.##..###.........###..#..###.#.#..#..#..#...####.#.##.#....##.#.
###..##.....#.#.#...#...#..#.#....###.###.#####.###.###.##.#..##.#.#.###..
###.#.#.#.##.##.##..#...#.##.#..#.###..###.....#.....#.#.#.####.#.##..#.##
#..##.....#.######.#...###.#.##.#..#.##...#.####....#.....####.#..##...##.
#.......#.....#..###.#.##.##...##..#.####..##..#.#..##...#..####.#..##....
...#...#.#..###.#....#.#.##.##.#...###..######.......#####......#.....#..#
..###.###.###..#.#.##..##.#.....###...##.###.#...##..#..#..##..#..########
..#.....#..#...###.##.#.#.###...#####.#..#.#.###.##.##.#...##.#.####.....#
......##.#.#.#..#..#..#..##..##.#..##########......#..##...#.###.....#..#.
...#..#.#.#######....#....#..#.....#...#...#######.#..#..####.####..##..##
#..##.##..###.#.###.#...##.#.##...##.####..####.###..#...##.#.##..#######.
#..#..#.##..##.#..#..#...##....#.#######..#..#.#..###..#......#.##.#####..
.#.#..#...#..##......#.#.#.##..#..##.#....###.#.###.##.####...#...#.....#.
#.#.#.....#..######.####.##.#.####.#####...#####...###..##....##.#..#.##..
.#..###.##.###..##...###.##....####.##...###..#....##.##...#.#..#.##....##
.#....#...##.#######.#..#.....####....#..#.#..##....##..#######.####.###.#
#####.##.....#.#........##.####...#.##.##..##..####...#.####.###.#....###.
#.#######.##......#..##.##.##..##...#.####....###.#...........##.##.#.....
##.####..#.#.#....#....#.####..#.#.#...######.#.###.##..#.......###...#.##
#.#.#.#..#...#.##..##..#...##.#........##..#.#.###..#.###..###..#.####.#..
..#..##.#.#..######.###.##.##.#####.###....##......#.#.#.#.##.#..##..#.##.
.#...#..#####.#..###..#.####.##.......#...#..#..#..#..#...##.#.#.###..#..#
#..##.#..#....###.........###..#..##...#....####.#....#..###.#.#..##.##.#.
##.##..#.#.#.###.#....###...##...##...##.##.##..#.#...##....#.#######...##
#..#.#.#.#######....#..#.#....#.#.##.....#.####...####.#.####.#.#..#...#.#
"""

}

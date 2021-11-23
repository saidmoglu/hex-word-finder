//
//  grid.swift
//  word finder
//
//  Created by Mustafa Said Mehmetoglu on 11/21/21.
//

import Foundation

struct Pos: Hashable {
  var row = 0
  var x = 0
  static func == (lhs: Pos, rhs: Pos) -> Bool {
    return lhs.row == rhs.row && lhs.x == rhs.x
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(row)
    hasher.combine(x)
  }
}

class Square: Hashable {
  
  static let MAXROW = 1000
  var letter: String = "A"
  var neighbors: [Pos] = []
  var hidden: Bool = false
  var pos: Pos = Pos(row: 0, x: 0)
  var tag = 0
  
  // pos as x:
  // Row 0:          0 1 2 3 4 5 ...
  // Row 1:        -1 0 1 2 3 4 5 ...
  // Row 2:     -2-1 0 1 2 3 4 5 ...
  // Neighbors of x:
  // row: x-1 and x+1
  // (row-1): (x-1 and x) +(row mod 2)
  // (row+1): same as row-1
  
  init(row: Int, x: Int){
    self.pos = Pos(row: row, x: x)
    self.neighbors = [Pos(row: row, x: x-1), Pos(row: row, x: x+1),
                      Pos(row: row-1, x: x-1 + row % 2),Pos(row: row-1, x: x + row % 2),
                      Pos(row: row+1, x: x-1 + row % 2),Pos(row: row+1, x: x + row % 2)]
    self.tag = Square.posToTag(pos: Pos(row: row, x: x))
  }
  convenience init(row: Int, x:Int, letter:String){
    self.init(row: row, x: x)
    self.letter = letter
  }
  convenience init(row: Int, x:Int, letter:String, hidden:Bool){
    self.init(row: row, x: x, letter: letter)
    self.hidden = hidden
  }
  
  static func tagToPos(tag: Int)->Pos{
    let row = Int((Double(tag)/Double(Square.MAXROW)).rounded())
    let x = tag - row*Square.MAXROW
    return Pos(row: row, x: x)
  }
  static func posToTag(pos: Pos)->Int{
    return pos.row*Square.MAXROW + pos.x
  }
  
  static func == (lhs: Square, rhs: Square) -> Bool {
    return lhs.pos == rhs.pos
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(pos)
  }
}

class Grid {
  var squares: [Pos:Square] = [:]
  let MAXMIDDLE = 100
  let letterGenerator = LetterGenerator(lang: "EN")
  var selected: [Pos] = []
  
  // Num of squares at start, end and middle
  init(start: Int, mid: Int, end: Int){
    if mid<=start || mid <= end || start<1 || end<1 || mid>MAXMIDDLE {
      return
    }
    var row = -1
    var startx = 0
    for count in start...mid {
      row+=1
      startx-=row%2
      for i in startx..<(startx+count){
        squares[Pos(row: row, x: i)] = Square(row: row, x: i, letter: letterGenerator.randomLetter())
      }
    }
    for count in (end...(mid-1)).reversed() {
      startx+=row%2
      row+=1
      for i in startx..<(startx+count){
        squares[Pos(row: row, x: i)] = Square(row: row, x: i, letter: letterGenerator.randomLetter())
      }
    }
  }
  
  func selectSquare(pos: Pos){
    selected.append(pos)
  }
  func selectSquare(tag: Int){
    self.selectSquare(pos: Square.tagToPos(tag: tag))
  }
  func squareIsSelected(tag: Int)->Bool{
    return selected.contains(Square.tagToPos(tag: tag))
  }
  func canSelectSquare(tag: Int)->Bool{
    return selected.isEmpty || (!selected.contains(Square.tagToPos(tag: tag)) && squares[selected.last!]?.neighbors.contains(Square.tagToPos(tag: tag)) == true)
  }
  func getSelectedString()->String{
    let tmp = selected.map{ squares[$0]?.letter ?? ""}
    return tmp.joined(separator: "")
  }
  func clearAllSelected(){
    self.selected.removeAll()
  }
}

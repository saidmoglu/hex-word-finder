//
//  letterGenerator.swift
//  word finder
//
//  Created by Mustafa Said Mehmetoglu on 11/22/21.
//

// Original English
//["E":56.88,"A":43.31,"R":38.64,"I":38.45,"O":36.51,"T":35.43,"N":33.92,"S":29.23,"L":27.98,"C":23.13,"U":18.51,"D":17.25,"P":16.14,"M":15.36,"H":15.31,"G":12.59,"B":10.56,"F":9.24,"Y":9.06,"W":6.57,"K":5.61,"V":5.13,"X":1.48,"Z":1.39,"J":1.00,"Q":1.0]
// Original Turkish
// ["A":11.56,"E":9.39,"İ":8.61,"R":6.81,"N":6.80,"L":6.08,"K":4.70,"D":4.62,"I":3.84,"O":3.59,"M":3.44,"U":3.42,"T":3.30,"S":3.27,"B":2.83,"Y":2.73,"Ü":1.77,"V":1.73,"Ş":1.56,"G":1.50,"Z":1.43,"Ç":1.35,"H":1.33,"C":1.12,"Ğ":0.91,"P":0.75,"Ö":0.71,"F":0.53,"J":0.16]

import Foundation

class LetterGenerator {
  var letters = ["E":66.88]
  var fullLetters:[String] = []
  init(lang: String){
    switch lang {
    case "EN":
      letters = ["E":66.88,"A":43.31,"R":68.64,"I":38.45,"O":36.51,"T":35.43,"N":33.92,"S":59.23,"L":27.98,"C":23.13,"U":18.51,"D":17.25,"P":16.14,"M":15.36,"H":15.31,"G":12.59,"B":10.56,"F":9.24,"Y":9.06,"W":6.57,"K":5.61,"V":5.13,"X":1.48,"Z":1.39,"J":1.00,"Q":1.0]
    case "TR":
      letters = ["A":11.56,"E":9.39,"İ":8.61,"R":6.81,"N":6.80,"L":6.08,"K":4.70,"D":4.62,"I":3.84,"O":3.59,"M":3.44,"U":3.42,"T":3.30,"S":3.27,"B":2.83,"Y":2.73,"Ü":1.77,"V":1.73,"Ş":1.56,"G":1.50,"Z":1.43,"Ç":1.35,"H":1.33,"C":1.12,"Ğ":0.91,"P":0.75,"Ö":100.71,"F":0.53,"J":0.16]
    default:
      letters = ["A":1]
    }
    for letter in letters.keys {
      fullLetters.append(contentsOf: Array.init(repeating: letter, count: Int((letters[letter] ?? 1.0)*10.0)))
    }
  }
  func randomLetter() -> String{
    return fullLetters.randomElement() ?? "E"
  }
}

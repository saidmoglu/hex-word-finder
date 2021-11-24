//
//  ViewController.swift
//  word finder
//
//  Created by Mustafa Said Mehmetoglu on 11/21/21.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  let cellId = "FoundWordCell"
  var foundWords: [String] = []
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return foundWords.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
    cell.textLabel?.text = foundWords[indexPath.row]
    return cell
  }
  
  @IBOutlet weak var gameGridView: UIView!
  let cellReuseIdentifier = "cell"
  @IBOutlet var tableView: UITableView!
  
  var wordArray: [String]?
  var trie = Trie()
  
  var grid: Grid = Grid(start: 0, mid: 0, end: 0)
  
  override var prefersStatusBarHidden: Bool { return true }
  
  func createWordArray() {
    guard wordArray == nil else {
      return
    }
    let resourcePath = Bundle.main.resourcePath! as NSString
    let fileName = "enable1.txt"
    let filePath = resourcePath.appendingPathComponent(fileName)
    
    var data: String?
    do{
      data=try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
    } catch{}
    wordArray = data!.components(separatedBy: "\n")
    
    func filterer (str: String) -> Bool {
      return str.utf16.count>2 && str.rangeOfCharacter(from: CharacterSet.lowercaseLetters.inverted) == nil
    }
    
    wordArray = wordArray?.filter(filterer)
  }
  
  /// Inserts words into a trie.  If the trie is non-empty, don't do anything.
  func insertWordsIntoTrie() {
    guard let wordArray = wordArray, trie.count == 0 else { return }
    for word in wordArray {
      trie.insert(word: word)
    }
    print(trie.count)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(CharacterSet.lowercaseLetters.description)
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    tableView.delegate = self
    tableView.dataSource = self
    createWordArray()
    insertWordsIntoTrie()
    let start = 2
    let mid = 5
    let end = 2
    grid = Grid(start: start, mid: mid, end: end)
    
    let startpos = Int(gameGridView.frame.width)/2-Int((Double(start)/2.0)*Double(LetterView.side))
    for square in grid.squares.values{
      let xpos = startpos+Int(Double(square.pos.x*LetterView.side)*sqrt(3.0)/2.0)+(Int(Double(LetterView.side)*sqrt(3.0)/4.0)*(square.pos.row%2))
      let ypos = 50+Int(Double(square.pos.row*LetterView.side)*0.75)
      let squareView = LetterView(frame: CGRect(x: xpos, y: ypos, width: LetterView.side, height: LetterView.side))
      squareView.setLetter(letter: square.letter)
      squareView.tag = square.tag
      gameGridView.addSubview(squareView)
    }
    
    let panGR = UIPanGestureRecognizer(target: self, action: #selector(panHandling(gestureRecognizer:)))
    gameGridView.addGestureRecognizer(panGR)
  }
  
  func findSubview(point: CGPoint) -> LetterView?{
    for case let subview as LetterView in gameGridView.subviews {
      if subview.frame.contains(point) {
        return subview
      }
    }
    return nil
  }
  
  @objc func panHandling(gestureRecognizer: UIPanGestureRecognizer) {
    
    let point = gestureRecognizer.location(in: gameGridView)
    let subviewT = findSubview(point: point)
    
    if subviewT != nil {
      let subview = subviewT!
      if(grid.canSelectSquare(tag: subview.tag)){
        grid.selectSquare(tag: subview.tag)
        subview.highlight()
      }
    }
    
    if gestureRecognizer.state == .ended {
      let result = grid.getSelectedString()
      print(result)
      for asubview in gameGridView.subviews{
        if(grid.selected.contains(Square.tagToPos(tag: asubview.tag)) && asubview is LetterView){
          (asubview  as! LetterView).deHighlight()
        }
      }
      grid.clearAllSelected()
      
      if trie.contains(word: result) && !foundWords.contains(result) {
        foundWords.insert(result, at: 0)
        tableView.reloadData()
      }
    }
  }
}

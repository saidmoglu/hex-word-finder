//
//  CustomView.swift
//  word finder
//
//  Created by Mustafa Said Mehmetoglu on 11/21/21.
//

import UIKit

class LetterView: UIView {
  
  static let side = 84
  let shapeLayer = CAShapeLayer()
  let letterLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .clear
    
    letterLabel.frame=CGRect(x: 0, y: 0, width: 20, height: 14)
    letterLabel.center=CGPoint(x:self.bounds.width/2, y:self.bounds.height/2)
    drawRectangle()
    self.addSubview(letterLabel)
  }
  
  private func drawRectangle() {
    let hexside = Double(LetterView.side)/2.0
    let path = UIBezierPath()
    let ox = self.bounds.origin.x
    let oy = self.bounds.origin.y
    path.move(to: CGPoint(x: ox, y: oy+hexside/2.0))
    path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y+hexside))
    path.addLine(to: CGPoint(x: path.currentPoint.x+hexside*(sqrt(3)/2.0), y:path.currentPoint.y+hexside/2.0))
    path.addLine(to: CGPoint(x: path.currentPoint.x+hexside*(sqrt(3)/2.0), y: path.currentPoint.y-hexside/2.0))
    path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y-hexside))
    path.addLine(to: CGPoint(x: path.currentPoint.x-hexside*(sqrt(3)/2.0), y: path.currentPoint.y-hexside/2.0))
    path.addLine(to: CGPoint(x: path.currentPoint.x-hexside*(sqrt(3)/2.0), y: path.currentPoint.y+hexside/2.0))
    
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = UIColor.black.cgColor
    shapeLayer.fillColor = UIColor.orange.cgColor
    shapeLayer.lineWidth = 4
    self.layer.addSublayer(shapeLayer)
    
  }
  
  func setLetter(letter: String){
    self.letterLabel.text = letter
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func highlight(){
    shapeLayer.fillColor = UIColor.darkGray.cgColor
    let animationScaleFactor: CGFloat = 1.5
    // Scale up the letter if it's selected.
    let transform = CGAffineTransform(scaleX: animationScaleFactor, y: animationScaleFactor)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [], animations: {
      self.letterLabel.transform = transform
    }) { (_) in }
  }
  
  func deHighlight(){
    shapeLayer.fillColor = UIColor.orange.cgColor
    let animationScaleFactor: CGFloat = 1.0
    let transform = CGAffineTransform(scaleX: animationScaleFactor, y: animationScaleFactor)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5, options: [], animations: {
      self.letterLabel.transform = transform
    }) { (_) in }
  }
}

//
//  CircleView.swift
//  swiftQuadtreeToy
//
//  Created by Nate on 8/3/16.
//  Copyright © 2016 Nate Schickler. All rights reserved.
//

import UIKit

class CircleView: UIView {
	
	let size: CGFloat = 7
	let lineWidth: CGFloat = 1
	var fillColor: UIColor!
	var path: UIBezierPath!
	
	init(origin: CGPoint) {
		super.init(frame: CGRectMake(0.0, 0.0, size, size))
		
		self.fillColor = randomColor()
		self.path = circlePath()
		
		self.center = origin
		
		self.backgroundColor = UIColor.clearColor()
		
		initGestureRecognizers()
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func initGestureRecognizers() {
		let panGR = UIPanGestureRecognizer(target: self, action: #selector(CircleView.didPan(_:)))
		addGestureRecognizer(panGR)
		
		let rotationGR = UIRotationGestureRecognizer(target: self, action: #selector(CircleView.didRotate(_:)))
		addGestureRecognizer(rotationGR)
	}
	
	func randomColor() -> UIColor {
		let hue:CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
		return UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.8)
	}
	
	func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
		return CGPointMake(radius * cos(angle) + offset.x, radius * sin(angle) + offset.y)
	}
	
	func trianglePathInRect(rect:CGRect) -> UIBezierPath {
		let path = UIBezierPath()
		
		path.moveToPoint(CGPointMake(rect.width / 2.0, rect.origin.y))
		path.addLineToPoint(CGPointMake(rect.width,rect.height))
		path.addLineToPoint(CGPointMake(rect.origin.x,rect.height))
		path.closePath()
		
		
		return path
	}
	
	func circlePath() -> UIBezierPath {
		return UIBezierPath(ovalInRect: CGRectInset(self.bounds,lineWidth,lineWidth))
	}
	
	func didPan(panGR: UIPanGestureRecognizer) {
		self.superview!.bringSubviewToFront(self)
		
		var translation = panGR.translationInView(self)
		translation = CGPointApplyAffineTransform(translation, self.transform)
		
		self.center.x += translation.x
		self.center.y += translation.y
		
		panGR.setTranslation(CGPointZero, inView: self)
	}
	
	func didRotate(rotationGR: UIRotationGestureRecognizer) {
		self.superview!.bringSubviewToFront(self)
		let rotation = rotationGR.rotation
		self.transform = CGAffineTransformRotate(self.transform, rotation)
		
		rotationGR.rotation = 0.0
	}
	
	override func drawRect(rect: CGRect) {
		self.fillColor.setFill()
		self.path.fill()
		
		path.fill()
		
		UIColor.blackColor().setStroke()
		
		path.lineWidth = self.lineWidth
		
		path.stroke()
	}	
}

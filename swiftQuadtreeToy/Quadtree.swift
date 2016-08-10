//
//  Quadtree.swift
//  swiftQuadtreeToy
//
//  Created by Nate on 8/3/16.
//  Copyright © 2016 Nate Schickler. All rights reserved.
//

import UIKit

/**
A quadtree than can render itself and holds UIView objects
*/
class Quadtree<T>: UIView {
	
	typealias Object = (T, CGRect)
	
	let lineColor: UIColor! = UIColor.cyanColor()
	let lineWidth: CGFloat = 1
	var path: UIBezierPath!
	
	var depth: Int8
	let maxDepth: Int8 = 5
	let nodeCapacity = 2
	
	var objects = [Object]()
	
	var NW: Quadtree<T>? = nil
	var NE: Quadtree<T>? = nil
	var SW: Quadtree<T>? = nil
	var SE: Quadtree<T>? = nil
	
	init(bounds: CGRect, depth: Int8) {
		self.depth = depth
		super.init(frame: bounds)
		
		let insetRect = CGRectInset(frame, lineWidth / 2, lineWidth / 2)
		self.path = UIBezierPath(roundedRect: insetRect, cornerRadius: 10)
		self.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
		
		self.backgroundColor = UIColor.clearColor()
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func insert(object:T, rect:CGRect)->Bool{
		if(!frame.contains(rect)) {
			return false
		}
		
		if(objects.count < nodeCapacity || depth == maxDepth) {
			objects.append((object, rect))
			return true
		}
		
		if(NW == nil) {
			subdivide()
		}
		
		if (NW!.insert(object, rect: rect) ||
			NE!.insert(object, rect: rect) ||
			SW!.insert(object, rect: rect) ||
			SE!.insert(object, rect: rect)) {
			return true
		}
		
		return false
	}
	
	func subdivide(){
		NW = Quadtree(bounds: CGRectMake(frame.minX, frame.midY, frame.width/2, frame.height/2), depth: depth + 1)
		NE = Quadtree(bounds: CGRectMake(frame.midX, frame.midY, frame.width/2, frame.height/2), depth: depth + 1)
		SW = Quadtree(bounds: CGRectMake(frame.minX, frame.minY, frame.width/2, frame.height/2), depth: depth + 1)
		SE = Quadtree(bounds: CGRectMake(frame.midX, frame.minY, frame.width/2, frame.height/2), depth: depth + 1)
		
		superview?.addSubview(NW!)
		superview?.addSubview(NE!)
		superview?.addSubview(SW!)
		superview?.addSubview(SE!)

	}
	
	func clear(){
		NW?.clear()
		NE?.clear()
		SW?.clear()
		SE?.clear()
		objects.removeAll()
	}
	
	func countChildren()->Int{
		var count: Int  = 1
		if(NW != nil){
			count = count + (NW!.countChildren())
			count = count + (NE!.countChildren())
			count = count + (SW!.countChildren())
			count = count + (SE!.countChildren())
		}
		
		return count
	}
	
	override func drawRect(rect: CGRect) {
		let insetRect = CGRectInset(rect, lineWidth / 2, lineWidth / 2)
		
		let path = UIBezierPath(rect: insetRect)
		
		UIColor.clearColor().setFill()
		path.fill()
		
		path.lineWidth = self.lineWidth
		lineColor.setStroke()
		path.stroke()
	}
}
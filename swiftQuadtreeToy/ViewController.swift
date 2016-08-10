//
//  ViewController.swift
//  swiftQuadtreeToy
//
//  Created by Nate on 8/3/16.
//  Copyright © 2016 Nate Schickler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var circleArray = [CircleView]()
	var quadtree: Quadtree<CircleView>?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let tapGR = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(_:)))
		self.view.addGestureRecognizer(tapGR)
		
		quadtree = Quadtree(bounds: self.view.frame, depth: 0)
		
		self.view.addSubview(quadtree!)
	}
	
	func didTap(tapGR: UITapGestureRecognizer) {
		
		let tapPoint = tapGR.locationInView(self.view)
		
		let shapeView = CircleView(origin: tapPoint)
		circleArray.append(shapeView)
		quadtree!.clear()
		for shape in circleArray{
			quadtree!.insert(shape, rect: shape.frame)
		}
		
		self.view.addSubview(shapeView)
	}
	
	override func shouldAutorotate() -> Bool {
		return false
	}
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return .Portrait
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


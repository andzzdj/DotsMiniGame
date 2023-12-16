//
//  DotCell.swift
//  praksadots
//
//  Created by Webelinx Praksa 2 on 22.3.22..
//

import UIKit

class DotCell: UICollectionViewCell
{
    
    var circleBackgroundColor = UIColor.red.cgColor
    func set(dotColour: Int)
    {
        
        switch dotColour
        {
        case 0:
            circleBackgroundColor = UIColor.blue.cgColor
        case 1:
            circleBackgroundColor = UIColor.cyan.cgColor
        case 2:
            circleBackgroundColor = UIColor.yellow.cgColor
        case 3:
            circleBackgroundColor = UIColor.green.cgColor
        case 4:
            circleBackgroundColor = UIColor.red.cgColor
        default:
            circleBackgroundColor = UIColor.clear.cgColor
        }
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext()
        {
            context.setLineWidth(5.0);
            
            
            //UIColor.red.set()
                
            let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
            let radius = (frame.size.width - 10)/2
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
            
            //context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
            context.setFillColor(circleBackgroundColor)
            context.fillPath()
            //context.strokePath()
        }
    }
    
    func animate()
    {
        self.isHidden = false
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
                        animation.fromValue = 0
                        animation.toValue = 1
        self.layer.add(animation, forKey: "transform.scale")
    }
    
    func setVisible(_ visible: Bool)
    {
        if visible
        {
            self.isHidden = false
        }
        else
        {
            self.isHidden = true
        }
    }
}

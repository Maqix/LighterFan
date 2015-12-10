//
//  MQXButton.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 09/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//
import UIKit

class MQXButton: UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configuraPulsante()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configuraPulsante()
    }
    
    func configuraPulsante()
    {
        let backgroundColor = UIColor.blackColor()
        let accentColor = UIColor.yellowColor()
        self.layer.backgroundColor = backgroundColor.CGColor
        self.layer.borderColor = accentColor.CGColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 4
        self.setTitleColor(accentColor, forState: .Normal)
        //self.titleLabel?.font = UIFont(name: "Avenir Next", size: 20.0)
    }
}

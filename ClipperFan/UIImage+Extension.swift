//
//  UIImage+Extension.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 09/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

extension Double {
    var isInteger:Bool {
        return self == Double(Int(self))
    }
}


extension UIImage {
    func crop(var rect: CGRect) -> UIImage {
        
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        rect.origin.x*=self.scale
        rect.origin.y+=100
        rect.origin.y*=self.scale
        
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, rect)
        let image = UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}

extension UIImage
{
    ///Per ottenere scale -> UIScreen.mainScreen.scale
    func filledImageWithColor(color: UIColor, scale: CGFloat) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextSetBlendMode(context, .ColorBurn)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        CGContextDrawImage(context, rect, self.CGImage)
        CGContextSetBlendMode(context, .Normal)
        CGContextAddRect(context, rect)
        CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
        let coloredImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return coloredImg
        
    }
    
    func imageByApplyingAlpha(alpha: CGFloat, scale: CGFloat) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        CGContextScaleCTM(ctx, 1, -1)
        CGContextTranslateCTM(ctx, 0, -area.size.height)
        CGContextSetBlendMode(ctx, .Multiply)
        CGContextSetAlpha(ctx, alpha)
        CGContextDrawImage(ctx, area, self.CGImage)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func mergeWithImage(backImage: UIImage) -> UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: backImage.size.width, height: backImage.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        backImage.drawInRect(rect)
        self.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

public extension UIColor{
    
    func isEqualToColor(color: UIColor, withTolerance tolerance: CGFloat = 0.0) -> Bool{
        
        var r1 : CGFloat = 0
        var g1 : CGFloat = 0
        var b1 : CGFloat = 0
        var a1 : CGFloat = 0
        var r2 : CGFloat = 0
        var g2 : CGFloat = 0
        var b2 : CGFloat = 0
        var a2 : CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return
            fabs(r1 - r2) <= tolerance &&
                fabs(g1 - g2) <= tolerance &&
                fabs(b1 - b2) <= tolerance &&
                fabs(a1 - a2) <= tolerance
    }
    
}

@IBDesignable
class PaddedLabel: UILabel {
    
    @IBInspectable var inset:CGSize = CGSize(width: 0, height: 0)
    
    var padding: UIEdgeInsets {
        var hasText:Bool = false
        if let t = text?.characters.count where t > 0 {
            hasText = true
        }
        else if let t = attributedText?.length where t > 0 {
            hasText = true
        }
        
        return hasText ? UIEdgeInsets(top: inset.height, left: inset.width, bottom: inset.height, right: inset.width) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override func intrinsicContentSize() -> CGSize {
        let superContentSize = super.intrinsicContentSize()
        let p = padding
        let width = superContentSize.width + p.left + p.right
        let heigth = superContentSize.height + p.top + p.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let p = padding
        let width = superSizeThatFits.width + p.left + p.right
        let heigth = superSizeThatFits.height + p.top + p.bottom
        return CGSize(width: width, height: heigth)
    }
}
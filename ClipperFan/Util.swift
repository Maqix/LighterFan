//
//  Util.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 07/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import Foundation
import UIKit

class Util: NSObject
{
    class func invokeAlertMethod(strTitle: NSString, strBody: NSString, delegate: AnyObject?)
    {
        let alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    class func tagliaImmagineInset(immagine: UIImage, dx: Int,dy: Int) -> UIImage
    {
        let rect = CGRectInset(CGRect(origin: CGPointZero, size: immagine.size), CGFloat(dx), CGFloat(dy))
        return immagine.crop(rect)
        //return squareCropImageToSideLength(immagine, sideLength: CGFloat(delta))
    }
    
    class  func squareCropImageToSideLength(let sourceImage: UIImage, let sideLength: CGFloat) -> UIImage
    {
            // input size comes from image
            let inputSize: CGSize = sourceImage.size
            
            // round up side length to avoid fractional output size
            let sideLength: CGFloat = ceil(sideLength)
            
            // output size has sideLength for both dimensions
            let outputSize: CGSize = CGSizeMake(sideLength, sideLength)
            
            // calculate scale so that smaller dimension fits sideLength
            let scale: CGFloat = max(sideLength / inputSize.width,
                sideLength / inputSize.height)
            
            // scaling the image with this scale results in this output size
            let scaledInputSize: CGSize = CGSizeMake(inputSize.width * scale,
                inputSize.height * scale)
            
            // determine point in center of "canvas"
            let center: CGPoint = CGPointMake(outputSize.width/2.0,
                outputSize.height/2.0)
            
            // calculate drawing rect relative to output Size
            let outputRect: CGRect = CGRectMake(center.x - scaledInputSize.width/2.0,
                center.y - scaledInputSize.height/2.0,
                scaledInputSize.width,
                scaledInputSize.height)
            
            // begin a new bitmap context, scale 0 takes display scale
            UIGraphicsBeginImageContextWithOptions(outputSize, true, 0)
            
            // optional: set the interpolation quality.
            // For this you need to grab the underlying CGContext
            let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
            CGContextSetInterpolationQuality(ctx, .High)
            
            // draw the source image into the calculated rect
            sourceImage.drawInRect(outputRect)
            
            // create new image from bitmap context
            let outImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // clean up
            UIGraphicsEndImageContext()
            
            // pass back new image
            return outImage
    }
    
    
    func stitchImages(images: [UIImage], isVertical: Bool) -> UIImage {
        var stitchedImages : UIImage!
        if images.count > 0 {
            var maxWidth = CGFloat(0), maxHeight = CGFloat(0)
            for image in images {
                if image.size.width > maxWidth {
                    maxWidth = image.size.width
                }
                if image.size.height > maxHeight {
                    maxHeight = image.size.height
                }
            }
            var totalSize : CGSize, maxSize = CGSizeMake(maxWidth, maxHeight)
            if isVertical {
                totalSize = CGSizeMake(maxSize.width, maxSize.height * (CGFloat)(images.count))
            } else {
                totalSize = CGSizeMake(maxSize.width  * (CGFloat)(images.count), maxSize.height)
            }
            UIGraphicsBeginImageContext(totalSize)
            for image in images {
                var rect : CGRect, offset = (CGFloat)((images as NSArray).indexOfObject(image))
                if isVertical {
                    rect = CGRectMake(0, maxSize.height * offset, maxSize.width, maxSize.height)
                } else {
                    rect = CGRectMake(maxSize.width * offset, 0 , maxSize.width, maxSize.height)
                }
                image.drawInRect(rect)
            }
            stitchedImages = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return stitchedImages
    }
    
    func immagineQuadrataFromArray(var images: [UIImage]) -> UIImage
    {
        var arrayRighe = [UIImage]()
        let numeroImmagini = images.count
        let latoDouble = sqrt(Double(numeroImmagini))
        var matrice = UIImage()
        //Se le immagini non sono un numero "quadrato" aggiungo immagini vuote fino ad ottenerlo
        print("\(latoDouble).isInteger = \(latoDouble.isInteger)")
        if (latoDouble.isInteger)
        {
            //Il lato viene decrementato di 1 perchè gli array partono da 0
            let lato = Int(sqrt(Float(numeroImmagini))) - 1
            let latoVero = lato + 1
            //Costruisco l'array di righe
            var partenza = 0
            for i in 0...lato
            {
                print("Giro \(i): Partenza = \(partenza) Partenza+LatoVero = \(partenza+lato) Lato: \(lato) LatoVero \(latoVero)")
                
                let immaginiRiga = images[partenza...partenza+lato]
                
                let riga = stitchImages(Array(immaginiRiga), isVertical: false)
                arrayRighe.append(riga)
                if (partenza%latoVero==0)
                {
                    partenza += latoVero
                }
            }
            //Unisco le righe verticalmente per ottenere una matrice
            matrice = stitchImages(arrayRighe, isVertical: true)
        }else
        {
            
            //Trovo il più piccolo numero che è un "quadrato" maggiore di numeroImmagini
            var esci = false
            var quadratoMinimo = numeroImmagini
            while (!esci)
            {
                quadratoMinimo++
                if (sqrt(Double(quadratoMinimo)).isInteger)
                {
                    print("Quadrato Minimo = \(quadratoMinimo)")
                    esci = true
                }
            }
            let numeroImmaginiDaAggiungere = quadratoMinimo - numeroImmagini
            
            
            
            var imagesCompleto = [UIImage]()
            imagesCompleto += images
            for _ in 1...(quadratoMinimo-numeroImmagini)
            {
                var imageBlank = images[0].copy() as! UIImage
                imageBlank = imageBlank.filledImageWithColor(UIColor.whiteColor(), scale: UIScreen.mainScreen().scale)
                imagesCompleto.append(imageBlank)
            }
            
            print("Ho un array di \(images.count) immagini\nil numero quadrato maggiore più piccolo è \(quadratoMinimo)\nquindi aggiungo \(numeroImmaginiDaAggiungere) immagni\n e ora l'array ha \(imagesCompleto.count) immagini")
            
            
            let lato = Int(sqrt(Float(imagesCompleto.count))) - 1
            let latoVero = lato + 1
            //Costruisco l'array di righe
            var partenza = 0
            arrayRighe = [UIImage]()
            for _ in 0...lato
            {
                //print("Giro \(i): Partenza = \(partenza) Partenza+Lato = \(partenza+lato)")
                let immaginiRiga = imagesCompleto[partenza...partenza+lato]
                let riga = stitchImages(Array(immaginiRiga), isVertical: false)
                arrayRighe.append(riga)
                if (partenza%latoVero==0)
                {
                    partenza += latoVero
                }
            }
            //Unisco le righe verticalmente per ottenere una matrice
            matrice = stitchImages(arrayRighe, isVertical: true)
        }
        
        
        return matrice
    }
}
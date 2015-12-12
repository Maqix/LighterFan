//
//  EsportaCollezioneViewController.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 11/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

class EsportaCollezioneViewController: UIViewController {
    
    @IBOutlet weak var buttonGeneraImmagine: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let selectorAggiornaProgressBar = NSSelectorFromString("aggiornaProgressBar")
    
    var arrayImmagini = [UIImage]()
    
    var valoreProgresso = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        impostaTapSullImmagine()
    }
    
    var hud = MBProgressHUD()
    
    func impostaTapSullImmagine()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(img: AnyObject)
    {
        EXPhotoViewer.showImageFrom(imageView)
    }

    @IBAction func premutoGeneraImmagine(sender: AnyObject)
    {
        UIView.animateWithDuration(1.0)
            {
                self.buttonGeneraImmagine.hidden = true
        }
        imageView.image = nil
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = .DeterminateHorizontalBar
        hud.labelText = "Do una lucidata..."
        valoreProgresso = 0.0
        //Eseguo la generazione dell'immagine in background per non bloccare la UI
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //Qui il lavoro in Background
            self.arrayImmagini = ClipperController.getClippersImages()
            let immagine = self.immagineFromArray(self.arrayImmagini)
            dispatch_async(dispatch_get_main_queue()) {
                //Quando ho finito, aggiorno la UI
                self.hud.hide(true)
                self.imageView.image = immagine
                self.valoreProgresso = 0
                self.aggiornaProgressBar()
            }
        }
    }

    @IBAction func premutoShare(sender: AnyObject)
    {
        if let immagine = imageView.image
        {
            let vc = UIActivityViewController(activityItems: [immagine], applicationActivities: nil)
            self.presentViewController(vc, animated: true, completion: nil)
        }else
        {
            Util.invokeAlertMethod("Attenzione", strBody: "Genera l'immagine prima di condividerla!", delegate: self)
        }
    }
    
    func aggiornaProgressBar()
    {
        hud.progress = Float(self.valoreProgresso)
    }

    ///Restituisce una immagine quadrata formata dalle immagini dell'array,
    ///se il numero di immagini non è un quadrato, gli spazi
    ///mancanti sono bianchi
    func immagineFromArray(images: [UIImage]) -> UIImage
    {
        struct Dimensioni
        {
            let righe: Int
            let colonne: Int
            
            init(r: Int, c: Int)
            {
                self.righe = r
                self.colonne = c
            }
        }
        //Per poter generare una immagine col dato aspect ratio 1:N, il
        //numero di immagini in ingresso deve avere questa proprietà
        // sqrt(immagini/ratio) = X.0 (ovvero deve essere un quadrato perfetto)
        func isNumeroOttimale(numero: Double, ratio: Double) -> Bool
        {
            let risposta: Bool
            let numeroDivisoRatio = numero / ratio
            let radice = sqrt(numeroDivisoRatio)
            if (radice.isInteger)
            {
                risposta = true
            }else
            {
                risposta = false
            }
            return risposta
        }
        //Riempie un array con immagini bianche pari alla sua prima immagine fino ad ottenere
        //il numero di immagini voluto
        func arrayRiempitoFinoA(numeroDaRaggiungere: Int, array: [UIImage]) -> [UIImage]
        {
            if (array.count < numeroDaRaggiungere)
            {
                var nuovoArray = [UIImage]()
                nuovoArray += array
                
                for _ in 1...(numeroDaRaggiungere-array.count)
                {
                    var imageBlank = UIImage(named: "clipperSample")!
                    imageBlank = imageBlank.imageByApplyingAlpha(0.5, scale: UIScreen.mainScreen().scale)
                    nuovoArray.append(imageBlank)
                }
                
                return nuovoArray
            }else
            {
                return array
            }
        }
        //Calcola righe e colonne in base al numero di elementi ed il ratio
        func dimensioniFromNumero(numero: Double, ratio: Double) -> Dimensioni
        {
            let righe: Int
            let colonne: Int
            if (isNumeroOttimale(numero, ratio: ratio))
            {
                righe = Int(sqrt(numero/ratio))
            }else
            {
                righe = Int(sqrt(numero/ratio)) + 1
            }
            //Imposto le colonne in base alle righe
            colonne = righe * Int(ratio)
            return Dimensioni(r: righe,c: colonne)
        }
        //Decide il ratio ottimale in base al numero in ingresso tra 1:2, 1:3, 1:4
        func ratioOttimaleFromNumero(numero: Double) -> Double
        {
            let ratio:Double
            
            let distanzaCon2 = (dimensioniFromNumero(numero, ratio: 2).righe * dimensioniFromNumero(numero, ratio: 2).colonne) - Int(numero)
            let distanzaCon3 = (dimensioniFromNumero(numero, ratio: 3).righe * dimensioniFromNumero(numero, ratio: 3).colonne) - Int(numero)
            let distanzaCon4 = (dimensioniFromNumero(numero, ratio: 4).righe * dimensioniFromNumero(numero, ratio: 4).colonne) - Int(numero)
            
            let distanzaOttimale = min(distanzaCon2, min(distanzaCon3,distanzaCon4))
            
            switch distanzaOttimale
            {
            case distanzaCon2:
                ratio = 2
                break;
            case distanzaCon3:
                ratio = 3
                break;
            case distanzaCon4:
                ratio = 4
                break;
            default:
                ratio = 3
            }
            
            return ratio
        }
        
        let numeroImmaginiIngresso = Double(images.count)
        let ratio = ratioOttimaleFromNumero(numeroImmaginiIngresso)
        let righe = dimensioniFromNumero(numeroImmaginiIngresso, ratio: ratio).righe
        let colonne = dimensioniFromNumero(numeroImmaginiIngresso, ratio: ratio).colonne
        let numeroTotaleImmagini = righe * colonne
        let arrayNormalizzato = arrayRiempitoFinoA(numeroTotaleImmagini, array: images)
        //Per aggiornare la progressBar conto quante immagini ho elaborato
        var immaginiElaborate = 0
        
        //Può unire immagini in riga o in colonna
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
                    
                    //Se sto unendo le immagini in riga
                    if (!isVertical)
                    {
                        //AGGIORNO LA PROGRESSBAR
                        immaginiElaborate++
                        valoreProgresso = Double(immaginiElaborate)/Double(numeroTotaleImmagini+(numeroTotaleImmagini/3))
                        self.performSelectorOnMainThread(selectorAggiornaProgressBar, withObject: nil, waitUntilDone: true)
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
        
        var arrayRighe = [UIImage]()
        var partenza = 0
        for _ in 1...righe
        {
            let immaginiRiga = Array(arrayNormalizzato[partenza...(partenza+colonne-1)])
            partenza += colonne
            let immagineRiga = stitchImages(immaginiRiga, isVertical: false)
            arrayRighe.append(immagineRiga)
        }
        let immagineSenzaSfondo = stitchImages(arrayRighe, isVertical: true)
        
        hud.labelText = "Preparo il set..."
        valoreProgresso += (1-(valoreProgresso/100))/6
        self.performSelectorOnMainThread(selectorAggiornaProgressBar, withObject: nil, waitUntilDone: true)
        
        let immagineNera = (immagineSenzaSfondo.copy() as! UIImage).filledImageWithColor(UIColor.blackColor(), scale: UIScreen.mainScreen().scale)
        
        hud.labelText = "Scatto la foto..."
        valoreProgresso += (1-(valoreProgresso/100))/6
        self.performSelectorOnMainThread(selectorAggiornaProgressBar, withObject: nil, waitUntilDone: true)
        
        let immagineFinale = immagineSenzaSfondo.mergeWithImage(immagineNera)

        valoreProgresso += Double(numeroTotaleImmagini)
        self.performSelectorOnMainThread(selectorAggiornaProgressBar, withObject: nil, waitUntilDone: true)
        
        return immagineFinale
    }
    
}

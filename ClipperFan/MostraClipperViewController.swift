//
//  MostraClipperViewController.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 07/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit
import AVFoundation

class MostraClipperViewController: UIViewController {

    @IBOutlet weak var immagineIV: UIImageView!
    @IBOutlet weak var descrizioneTF: UITextField!
    @IBOutlet weak var nomeTF: UITextField!
    
    @IBOutlet var textFields: [UITextField]!

    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var buttons: [MQXButton]!
    
    @IBOutlet weak var immagineSfondo: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var clipper: ClipperData? = ClipperData()
    
    var delegate: LanciatoreMostraClipper?
    
    var salvare = false;
    
    lazy var imagePicker = UIImagePickerController()
    
    lazy var imageEditor = DemoImageEditor()
    lazy var library =  ALAssetsLibrary()
    
    var coloriImmagine = [UIColor]()
    var coloriGradiente = [UIColor]()
    var primaryColor = UIColor()
    var secondaryColor = UIColor()
    var gradientColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        impostaTapSullImmagine()
        
        imagePicker.delegate = self
        
        riempiDati()
        
        configuraColori()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        if(salvare)
        {
            clipper?.nome = nomeTF.text!
            clipper?.descrizione = descrizioneTF.text!
            clipper?.immagine = immagineIV.image
            clipper?.immagineSfocata = Util.tagliaImmagineInset(immagineIV.image!, dx:10, dy:150).applyLightEffect()
            ClipperController.inserisciClipper(clipper!)
            delegate?.reloadTable()
        }
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configuraColori()
    {
        immagineIV.layer.cornerRadius = 4
        immagineIV.clipsToBounds = true
        immagineIV.setNeedsDisplay()
        
        let immagine = Util.tagliaImmagineInset(immagineIV.image!, dx:10, dy:150)
        //immagineIV.image = immagine
        coloriImmagine = ColorsFromImage(immagine, withFlatScheme: false)
        
        coloriGradiente = [coloriImmagine[0],coloriImmagine[2],coloriImmagine[4]]
        
        primaryColor = coloriImmagine[0]
        secondaryColor = coloriImmagine[1]
        
        /*
        gradientColor = GradientColor(.TopToBottom, frame: self.view.frame, colors: coloriImmagine)
        
        self.view.backgroundColor = gradientColor
        */
        immagineSfondo.image = clipper?.immagineSfocata
        /*
        //BLUR STUFF
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let view = UIVisualEffectView(effect: blur)
        view.frame = self.view.frame
        self.view.addSubview(view)
        self.view.sendSubviewToBack(view)
        */
        
        
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        
        for label in labels
        {
            if (clipper?.nome != "Nessun nome")
            {
                label.textColor = UIColor.blackColor()
            }
        }
        
        for button in buttons
        {
            if (clipper?.nome != "Nessun nome")
            {
                button.backgroundColor = secondaryColor
                button.layer.borderColor = primaryColor.CGColor
                button.setTitleColor(ContrastColorOf(secondaryColor, returnFlat: false), forState: .Normal)
            }
        }
        
        for textField in textFields
        {
            textField.layer.borderWidth = 1
            if (clipper?.nome != "Nessun nome")
            {
                textField.textColor = UIColor.blackColor()
                textField.layer.borderColor = UIColor.blackColor().CGColor
            }else
            {
                textField.layer.borderColor = UIColor.blackColor().CGColor
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        //
    }
    
    func impostaTapSullImmagine()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        immagineIV.userInteractionEnabled = true
        immagineIV.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func riempiDati()
    {
        immagineIV.image = clipper?.immagine
        descrizioneTF.text = clipper?.descrizione == "Nessuna descrizione" ? "" : clipper?.descrizione
        nomeTF.text = clipper?.nome == "Nessun nome" ? "" : clipper?.nome
    }
    
    func imageTapped(img: AnyObject)
    {
        //show the action sheet (i.e. the little pop-up box from the bottom that allows you to choose whether you want to pick a photo from the photo library or from your camera)
        
        let optionMenu = UIAlertController(title: nil, message: "Scegli dove prendere l'immagine", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let photoLibraryOption = UIAlertAction(title: "Galleria", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            print("from library")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            self.imagePicker.modalPresentationStyle = .Popover
            
            
            //IMAGE EDITING STUFF
            let libreria = ALAssetsLibrary()
            self.imageEditor = DemoImageEditor.init(nibName: "DemoImageEditor", bundle: nil)
            self.imageEditor.checkBounds = true
            self.imageEditor.rotateEnabled = true
            self.library = libreria
            let completionBlock = {(assetUrl: NSURL!, error: NSError!) in
                
                if (error != nil)
                {
                    Util.invokeAlertMethod("Errore Salvataggio", strBody: "Ci sono stati problemi con il salvataggio della foto", delegate: self)
                }
            
            }
            let doneCallBack = { (editedImage: UIImage!,canceled: Bool) in
            
                print("doneCalBack closure")
                if (!canceled)
                {
                    let imageOrientation = ALAssetOrientation(rawValue: editedImage.imageOrientation.rawValue)
                    self.immagineIV.image = editedImage
                    self.library.writeImageToSavedPhotosAlbum(editedImage.CGImage, orientation: imageOrientation!, completionBlock: completionBlock)
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            
            }
            self.imageEditor.doneCallback = doneCallBack
            //IMAGE EDITING STUFF
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let cameraOption = UIAlertAction(title: "Scatta una foto", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            print("take a photo")
            //shows the camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            self.imagePicker.modalPresentationStyle = .Popover
            
            //IMAGE EDITING STUFF
            let libreria = ALAssetsLibrary()
            self.imageEditor = DemoImageEditor.init(nibName: "DemoImageEditor", bundle: nil)
            self.imageEditor.checkBounds = true
            self.imageEditor.rotateEnabled = true
            self.library = libreria
            let completionBlock = {(assetUrl: NSURL!, error: NSError!) in
                
                if (error != nil)
                {
                    Util.invokeAlertMethod("Errore Salvataggio", strBody: "Ci sono stati problemi con il salvataggio della foto", delegate: self)
                }
                
            }
            let doneCallBack = { (editedImage: UIImage!,canceled: Bool) in
                
                print("doneCalBack closure")
                if (!canceled)
                {
                    let imageOrientation = ALAssetOrientation(rawValue: editedImage.imageOrientation.rawValue)
                    self.immagineIV.image = editedImage
                    self.library.writeImageToSavedPhotosAlbum(editedImage.CGImage, orientation: imageOrientation!, completionBlock: completionBlock)
                }
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            self.imageEditor.doneCallback = doneCallBack
            //IMAGE EDITING STUFF
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        let cancelOption = UIAlertAction(title: "Annulla", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
            //self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        //Adding the actions to the action sheet. Here, camera will only show up as an option if the camera is available in the first place.
        optionMenu.addAction(photoLibraryOption)
        optionMenu.addAction(cancelOption)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
            optionMenu.addAction(cameraOption)} else {
            print ("I don't have a camera.")
        }
        
        //Now that the action sheet is set up, we present it.
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func premutoAnnulla(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func premutoSalva(sender: AnyObject)
    {
        salvare = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resignKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MostraClipperViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //The UIImagePickerController is a view controller that gets presented modally. When we select or cancel the picker, it runs the delegate, where we handle the case and dismiss the modal.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //handle media here i.e. do stuff with photo
        
        print("imagePickerController called")
        /*
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        immagineIV.image = chosenImage
        */
        
        //IMAGE EDITING STUFF
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //IMAGE RESIZING STUFF
        
        //let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.2, 0.2))
        let size = AVMakeRectWithAspectRatioInsideRect(image.size, CGRect(x: 0, y: 0, width: 80*3, height: 320*3))
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size.size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size.size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image = scaledImage
        //IMAGE RESIZING STUFF
        
        if (picker.sourceType == .Camera)
        {
            let completionBlock = {(assetUrl: NSURL!, error: NSError!) in
                
                if (error != nil)
                {
                    Util.invokeAlertMethod("Errore Salvataggio", strBody: "Ci sono stati problemi con il salvataggio della foto", delegate: self)
                }else
                {
                    let assetURL = assetUrl
                    
                    self.library.assetForURL(assetURL, resultBlock: { (asset: ALAsset!) in
                        let preview = UIImage(CGImage: asset.aspectRatioThumbnail().takeUnretainedValue())
                        self.imageEditor.sourceImage = image
                        self.imageEditor.previewImage = preview
                        self.imageEditor.reset(false)
                        self.presentViewController(self.imageEditor, animated: true, completion: nil)
                        
                        }, failureBlock: { (error: NSError!) in
                            print("Non sono riuscito ad ottenere l'asset dalla libreria")
                    })

                }
                
            }
            self.library.writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!, completionBlock: completionBlock)
        }else
        {
            let assetURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            
            self.library.assetForURL(assetURL, resultBlock: { (asset: ALAsset!) in
                let preview = UIImage(CGImage: asset.aspectRatioThumbnail().takeUnretainedValue())
                self.imageEditor.sourceImage = image
                self.imageEditor.previewImage = preview
                self.imageEditor.reset(false)
                self.presentViewController(self.imageEditor, animated: true, completion: nil)
                
                }, failureBlock: { (error: NSError!) in
                    print("Non sono riuscito ad ottenere l'asset dalla libreria")
            })

        }
        //IMAGE EDITING STUFF
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //what happens when you cancel
        //which, in our case, is just to get rid of the photo picker which pops up
        dismissViewControllerAnimated(true, completion: nil)
    }
}

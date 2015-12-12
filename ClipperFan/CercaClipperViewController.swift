//
//  CercaClipperViewController.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 12/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

class CercaClipperViewController: UIViewController {
    
    let colorPickerVC = SwiftColorPickerViewController()
    
    @IBOutlet weak var coloreSceltoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ruotatoSchermo", name: UIDeviceOrientationDidChangeNotification, object: nil)

        // Do any additional setup after loading the view.
        coloreSceltoView.layer.borderColor = FlatBlack().CGColor
        coloreSceltoView.layer.borderWidth = 0.7
        coloreSceltoView.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ruotatoSchermo()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func premutoScegliColore(sender: AnyObject)
    {
        colorPickerVC.delegate = self
        colorPickerVC.modalPresentationStyle = .Popover
        colorPickerVC.numberColorsInXDirection = 6
        colorPickerVC.numberColorsInYDirection = 2
        colorPickerVC.coloredBorderWidth = 10
        colorPickerVC.view.backgroundColor = FlatYellow()
        let popVC = colorPickerVC.popoverPresentationController!;
        popVC.sourceRect = sender.convertRect(sender.frame, toView: self.view)
        popVC.sourceView = self.view
        popVC.permittedArrowDirections = .Any;
        popVC.delegate = self;
        
        self.presentViewController(colorPickerVC, animated: true, completion: {
            print("Reade<");
        })
    }
    
}

extension CercaClipperViewController:  UIPopoverPresentationControllerDelegate, SwiftColorPickerDelegate
{
    
    
    // MARK: popover presenation delegates
    
    // this enables pop over on iphones
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.None
    }
    
    // MARK: Color Picker Delegate
    
    func colorSelectionChanged(selectedColor color: UIColor) {
        
        coloreSceltoView.backgroundColor = color
    }

}

//
//  MostraClipperViewController.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 07/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

class MostraClipperViewController: UIViewController {

    @IBOutlet weak var immagineIV: UIImageView!
    @IBOutlet weak var descrizioneTF: UITextField!
    @IBOutlet weak var nomeTF: UITextField!
    
    var clipper: ClipperData? = ClipperData()
    var salvare = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        immagineIV.image = clipper?.immagine
        descrizioneTF.text = clipper?.descrizione == "Nessuna descrizione" ? "" : clipper?.descrizione
        nomeTF.text = clipper?.nome == "Nessun nome" ? "" : clipper?.nome
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        if(salvare)
        {
            clipper?.nome = nomeTF.text!
            clipper?.descrizione = descrizioneTF.text!
            clipper?.immagine = immagineIV.image
            ClipperController.inserisciClipper(clipper!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

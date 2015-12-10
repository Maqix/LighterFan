//
//  ClipperCellTableViewCell.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 07/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

class ClipperCellTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelDescrizione: PaddedLabel!
    @IBOutlet private weak var labelNome: PaddedLabel!
    @IBOutlet private weak var immagine: UIImageView!
    
    @IBOutlet weak var immagineSfondo: UIImageView!
    ///La variabile che fa da interfaccia alle IBOutlet
    var datiClipper: ClipperData? {
        didSet {
            labelNome.text = datiClipper?.nome
            labelDescrizione.text = datiClipper?.descrizione
            immagine.image = datiClipper?.immagine
            
            //Configuro la cella con i colori del clipper
            //let immagineColori = Util.tagliaImmagineInset(immagine.image!, dx:10, dy:150)
            //immagine.image = immagineColori
            //let coloriImmagine = ColorsFromImage(immagineColori, withFlatScheme: false)
            
            /*
            let gradientColor = GradientColor(.TopToBottom, frame: self.frame, colors: coloriImmagine)
            
            self.backgroundColor = gradientColor
            
            //BLUR STUFF
            let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let view = UIVisualEffectView(effect: blur)
            view.frame = self.frame
            self.sendSubviewToBack(view)
            */
            immagineSfondo.image = datiClipper?.immagineSfocata
            
            //let coloreMedio = AverageColorFromImage((datiClipper?.immagine)!)
            //let contrastColor = ContrastColorOf(coloreMedio, returnFlat: false)
            labelDescrizione.textColor = UIColor.blackColor()
            labelNome.textColor = UIColor.blackColor()
            labelNome.layer.cornerRadius = 4
            labelDescrizione.layer.cornerRadius = 4
            labelDescrizione.layer.borderColor = UIColor.blackColor().CGColor
            labelDescrizione.layer.borderWidth = 2
            labelNome.layer.borderColor = UIColor.blackColor().CGColor
            labelNome.layer.borderWidth = 2
            labelNome.clipsToBounds = true
            labelDescrizione.clipsToBounds = true

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var frame = self.frame
        var size = frame.size
        size.height -= 10
        size.width -= 10
        frame.size = size
        let backgroundView = UIView(frame: frame)
        backgroundView.backgroundColor = FlatYellow().lightenByPercentage(1)
        backgroundView.layer.borderColor = FlatBlack().CGColor
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.cornerRadius = 4
        self.selectedBackgroundView = backgroundView
        // Initialization code
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.layer.borderColor = FlatBlack().CGColor
        self.layer.borderWidth = 2
        self.backgroundView?.alpha = 0.5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

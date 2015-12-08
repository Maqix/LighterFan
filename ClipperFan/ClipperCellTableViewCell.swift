//
//  ClipperCellTableViewCell.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 07/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

class ClipperCellTableViewCell: UITableViewCell {

    @IBOutlet private weak var labelDescrizione: UILabel!
    @IBOutlet private weak var labelNome: UILabel!
    @IBOutlet private weak var immagine: UIImageView!
    
    ///La variabile che fa da interfaccia alle IBOutlet
    var datiClipper: ClipperData? {
        didSet {
            labelNome.text = datiClipper?.nome
            labelDescrizione.text = datiClipper?.descrizione
            immagine.image = datiClipper?.immagine
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView(frame: self.frame)
        backgroundView.backgroundColor = UIColor.yellowColor()
        self.selectedBackgroundView = backgroundView
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

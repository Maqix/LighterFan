//
//  ClipperCollectionViewCell.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 09/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

class ClipperCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak private var imageView: UIImageView!
    
    @IBOutlet weak var nomeLabel: UILabel!
    ///La variabile che fa da interfaccia alle IBOutlet
    var datiClipper: ClipperData? {
        didSet {
            nomeLabel.text = datiClipper?.nome
            imageView.image = datiClipper?.immagine
        }
    }
    
}

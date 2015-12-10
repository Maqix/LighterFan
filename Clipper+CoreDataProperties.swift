//
//  Clipper+CoreDataProperties.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 07/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Clipper {

    @NSManaged var id: NSNumber?
    @NSManaged var nome: String?
    @NSManaged var descrizione: String?
    @NSManaged var immagine: NSData?
    @NSManaged var immagineSfocata: NSData?

}

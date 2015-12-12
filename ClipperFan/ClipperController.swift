//
//  ClipperController.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 07/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

///La struct usata come interfaccia tra il sistema ed il salvataggio su Core Data
struct ClipperData
{
    var id:             Int
    var nome:           String
    var descrizione:    String
    var immagine:       UIImage?
    var immagineSfocata: UIImage?
    
    init(clipper: Clipper)
    {
        id = (clipper.id?.integerValue)!
        nome = clipper.nome!
        descrizione = clipper.descrizione!
        if let data = clipper.immagine
        {
            if let immagine = UIImage(data: data)
            {
                self.immagine = immagine
            }
        }
        if let data = clipper.immagineSfocata
        {
            if let immagine = UIImage(data: data)
            {
                self.immagineSfocata = immagine
            }
        }
    }
    
    init()
    {
        id = 0
        nome = "Nessun nome"
        descrizione = "Nessuna descrizione"
        immagine = UIImage(named: "clipperSample")
        immagineSfocata = Util.tagliaImmagineInset((UIImage(named: "clipperSample"))!, dx:30, dy:250).applyLightEffect()
    }
}

///La classe che si interfaccia con Core Data internamente, ma usa solo ClipperData per comunicare
class ClipperController
{
    //MARK: Lettura
    class func getIdLibero() -> Int
    {
        return (getClippers().count + 1)
    }
    
    class func getClipperById(id: Int) -> ClipperData
    {
        let clippers = getClippers()
        var clipper = ClipperData()
        for clipperCorrente in clippers
        {
            if (clipper.id == id)
            {
                clipper = clipperCorrente
            }
        }
        return clipper
    }
    
    class func getClippersImages() -> [UIImage]
    {
        return ClipperController.getClippers().map { $0.immagine! }
    }
    
    class func getClippers() -> [ClipperData]
    {
        /*
        print("Chiamate FAKE getClippers()")
        var array = [ClipperData]()
        
        for i in 1...100
        {
            var clipper = ClipperData()
            clipper.nome = "Clipper \(i)"
            array.append(clipper)
        }
        
        return array
        */
        return getClippersBakcup()
    }
    
    class func getClippersBakcup() -> [ClipperData]
    {
        var array = [ClipperData]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        let richiesta = NSFetchRequest(entityName: "Clipper")
        
        do {
            //print("Chiedo i clipper a Core Data")
            let risultati = try moc.executeFetchRequest(richiesta) as! [Clipper]
            //print("Ho ottenuto i clipper da Core Data")
            for risultato in risultati
            {
                if (risultato.id != nil && risultato.nome != nil)
                {
                    array.append(ClipperData(clipper: risultato))
                }
            }
        }catch let error as NSError
        {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return array
    }
    
    //MARK: Inserimento
    class func inserisciClipper(clipperData: ClipperData)
    {
        if (clipperData.id == 0)
        {
            //Ottengo i riferimenti alle componenti di Core Data
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let moc = appDelegate.managedObjectContext
            let entita = NSEntityDescription.entityForName("Clipper", inManagedObjectContext: moc)
            
            //Ottengo il clipper da inserire
            let clipper = Clipper(entity: entita!, insertIntoManagedObjectContext: moc)
            
            //Lo valorizzo
            clipper.id = getIdLibero()
            clipper.nome = clipperData.nome
            clipper.descrizione = clipperData.descrizione
            if let immagine = clipperData.immagine
            {
                if let pngRepresentation = UIImagePNGRepresentation(immagine)
                {
                    let data = NSData(data: pngRepresentation)
                    clipper.immagine = data
                }
            }
            if let immagineSfocata = clipperData.immagineSfocata
            {
                if let pngRepresentation = UIImagePNGRepresentation(immagineSfocata)
                {
                    let data = NSData(data: pngRepresentation)
                    clipper.immagineSfocata = data
                }
            }
            
            //E lo salvo
            appDelegate.saveAction(self)
        }else
        {
            aggiornaClipper(clipperData)
        }
    }
    
    //MARK: Rimozione
    class func eliminaClipper(clipperData: ClipperData)
    {
        let fetchRequest = NSFetchRequest(entityName: "Clipper")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        if let fetchResults = try! moc.executeFetchRequest(fetchRequest) as? [Clipper] {
            
            for clipperCorrente in fetchResults
            {
                if (clipperCorrente.id == clipperData.id)
                {
                    moc.deleteObject(clipperCorrente)
                    try! moc.save()
                }
            }
        }
    }
    
    //MARK: Aggiornamento
    private class func aggiornaClipper(clipperData: ClipperData)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        let richiesta = NSFetchRequest(entityName: "Clipper")
        
        do {
            let risultati = try moc.executeFetchRequest(richiesta) as! [Clipper]
            for risultato in risultati
            {
                if (risultato.id == clipperData.id)
                {
                    risultato.nome = clipperData.nome
                    risultato.descrizione = clipperData.descrizione
                    if let immagine = clipperData.immagine
                    {
                        if let pngRepresentation = UIImagePNGRepresentation(immagine)
                        {
                            let data = NSData(data: pngRepresentation)
                            risultato.immagine = data
                        }
                    }
                    if let immagineSfocata = clipperData.immagineSfocata
                    {
                        if let pngRepresentation = UIImagePNGRepresentation(immagineSfocata)
                        {
                            let data = NSData(data: pngRepresentation)
                            risultato.immagineSfocata = data
                        }
                    }
                    //E lo salvo
                    appDelegate.saveAction(self)
                }
            }
        }catch let error as NSError
        {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }

}

//MARK: - Metodi di test
extension ClipperController
{
    class func testaController()
    {
        print("Array di clippers: ")
        var clippers = ClipperController.getClippers()
        print(clippers)
        
        print("Creo un ClipperData")
        var clipper = ClipperData()
        clipper.nome = "ClipperMan"
        clipper.descrizione = "Un clipper qualsiasi"
        
        print("ClipperController.inserisciClipper(clipper)")
        ClipperController.inserisciClipper(clipper)
        
        print("Array di clippers: ")
        clippers = ClipperController.getClippers()
        print(clippers)
        
        clipper = clippers.first!
        print("Inserisco il clipper modificato")
        clipper.nome = "ClipperMaqix"
        ClipperController.inserisciClipper(clipper)
        
        print("Array di clippers: ")
        clippers = ClipperController.getClippers()
        print(clippers)
        
        print("ClipperController.eliminaClipper(clipper)")
        ClipperController.eliminaClipper(clipper)
        
        print("Array di clippers: ")
        clippers = ClipperController.getClippers()
        print(clippers)
    }
    
    class func aggiungiDatiEsempio()
    {
        var clipper = ClipperData()
        clipper.nome = "ClipperMan"
        clipper.descrizione = "Un clipper qualsiasi"
        ClipperController.inserisciClipper(clipper)
    }
}
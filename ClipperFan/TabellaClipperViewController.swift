//
//  TabellaClipperViewController.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 08/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

protocol LanciatoreMostraClipper
{
    func reloadTable()
}

class TabellaClipperViewController: UIViewController, LanciatoreMostraClipper {

    @IBOutlet weak var tableView: UITableView!
    
    var clipperArray = ClipperController.getClippers()
    
    var cellaSelezionata = 0

    func reloadTable() {
        clipperArray = ClipperController.getClippers()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        reloadTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "clipperCellToMostraClipper")
        {
            let vc = segue.destinationViewController as! MostraClipperViewController
            vc.delegate = self
            vc.clipper = clipperArray[cellaSelezionata]
        }else if (segue.identifier == "esportaCellToEsportaCollezione")
        {

        }else
        {
            let vc = segue.destinationViewController as! MostraClipperViewController
            vc.delegate = self
        }
    }

}

extension TabellaClipperViewController: UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clipperArray.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row > 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("ClipperCell", forIndexPath: indexPath) as! ClipperCellTableViewCell
            cell.datiClipper = clipperArray[indexPath.row-1]
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("EsportaCell", forIndexPath: indexPath) as! EsportaCollezioneTableViewCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row > 0)
        {
            return 200
        }else
        {
            return 53
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row > 0)
        {
            cellaSelezionata = indexPath.row - 1
            performSegueWithIdentifier("clipperCellToMostraClipper", sender: self)
        }else
        {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }

    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.row > 0)
        {
            return true
        }else
        {
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        if (indexPath.row > 0)
        {
            let delete = UITableViewRowAction(style: .Default, title: "Elimina") { action, index in
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                ClipperController.eliminaClipper(self.clipperArray[indexPath.row - 1])
                self.clipperArray.removeAtIndex(indexPath.row - 1)
                tableView.reloadData()
            }
            return [delete]
        }else
        {
            return nil
        }

    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.row > 0)
        {
            return true
        }else
        {
            return false
        }
    }

}

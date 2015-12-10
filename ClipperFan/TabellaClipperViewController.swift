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
        return clipperArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClipperCell", forIndexPath: indexPath) as! ClipperCellTableViewCell
        cell.datiClipper = clipperArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cellaSelezionata = indexPath.row
        performSegueWithIdentifier("clipperCellToMostraClipper", sender: self)
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let delete = UITableViewRowAction(style: .Default, title: "Elimina") { action, index in
            print("Delete")
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            ClipperController.eliminaClipper(self.clipperArray[indexPath.row])
            self.clipperArray.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
        return [delete]
    }

}

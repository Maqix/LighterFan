//
//  ViewController.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 06/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }

    override func viewWillDisappear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
        super.viewDidDisappear(animated)
    }

}


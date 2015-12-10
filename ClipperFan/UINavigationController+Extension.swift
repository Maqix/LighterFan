//
//  UINavigationController+Extension.swift
//  ClipperFan
//
//  Created by Marcello Quarta on 09/12/15.
//  Copyright © 2015 Maqix Corp. All rights reserved.
//

import Foundation
import UIKit

///Una estensione per fare in modo che i singoli ViewControllers possono decidere se ruotare o meno
extension UINavigationController
{
    public override func shouldAutorotate() -> Bool {
        return (self.topViewController?.shouldAutorotate())!
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return (self.topViewController?.supportedInterfaceOrientations())!
    }
}
//
//  utils.swift
//  EIL App
//
//  Created by STEPAN ULYANIN on 4/12/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import Foundation
import UIKit

class Utils {

    // arert view function
    class func showAlertController(in parentController: UIViewController, withTitle title: String, andMessage message: String, andActionTitle actionTitle: String) {
        
        // create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // ok action for the controller
        let action = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            
            // dismiss the alert controller on OK
            alertController.dismiss(animated: true, completion: nil)
        }
        
        // add the action to the alert controller
        alertController.addAction(action)
        
        // present the controller as a child of the root controller (navigation controller)
        parentController.present(alertController, animated: true, completion: nil)
    }
}

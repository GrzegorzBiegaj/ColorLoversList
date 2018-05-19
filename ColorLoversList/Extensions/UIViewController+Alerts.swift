//
//  UIViewController+Alerts.swift
//  ColorLoversList
//
//  Created by Grzesiek on 09/01/2018.
//  Copyright © 2018 Grzesiek. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String, message: String, okAction: ((UIAlertAction) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: okAction))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

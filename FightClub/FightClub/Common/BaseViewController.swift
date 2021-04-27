//
//  BaseViewController.swift
//  FightClub
//
//  Created by Anagha Wadkar on 27/04/21.
//

import Foundation
import UIKit

extension UIViewController {
    /**
     Presents alert with custom information
     */
    func showAlert(title: String, message: String, primaryActionTitle: String = "OK", primaryActionhandler: (() -> Void)? = nil,  secondaryActionTitle: String? = nil, secondaryActionhandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let primaryAction = UIAlertAction(title: primaryActionTitle, style: .default) { (action) in
            primaryActionhandler?()
        }
        alert.addAction(primaryAction)
        if secondaryActionTitle != nil {
            let secondaryAction = UIAlertAction(title: secondaryActionTitle, style: .default) { (action) in
                secondaryActionhandler?()
            }
            alert.addAction(secondaryAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Presents common alert for Errors
     */
    func showAlertForError() {
        let alert = UIAlertController(title: "Something Went Wrong", message: "Please try again later", preferredStyle: .alert)
        let primaryAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(primaryAction)
        present(alert, animated: true, completion: nil)
    }
}

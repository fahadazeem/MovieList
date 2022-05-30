//
//  Alert+Extension.swift
//  MovieListApp
//
//  Created by Junaid Butt on 26/05/2022.
//

import Foundation
import UIKit
import Toast_Swift

extension UIViewController {
    //Error Alert
    func showAlert(title: String,
                   message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAaction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertVC.addAction(okAaction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func showActivityView() {
        self.view.isUserInteractionEnabled = false
        self.view.makeToastActivity(.center)
    }
    
    func hideActivityView() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.view.hideToastActivity()
        }
    }
}




class Alert: NSObject {//This is shared class
static let shared = Alert()

    //Show alert
    func alert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }

    private override init() {
    }
}



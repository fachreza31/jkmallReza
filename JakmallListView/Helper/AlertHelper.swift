//
//  AlertHelper.swift
//  JakmallListView
//
//  Created by Fachreza Audrian Naufal on 1/12/19.
//  Copyright © 2019 Fachreza Audrian Naufal. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {

    class func showAlert(title: String, message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertTableView(title: String, message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        vc.present(alert, animated: true, completion: nil)
    }

}

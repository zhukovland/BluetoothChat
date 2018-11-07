//
//  AlertClass.swift
//  BluetoothChat
//
//  Created by Mikhail on 07/11/2018.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import UIKit


class AlertClass {
    
    
public func presentAlertControllerWhenWhatToRename (fromController controller: UIViewController, mainAction: @escaping () -> () ) -> UIAlertController {

    let alertController = UIAlertController(title:  "Введите ваше имя", message: "", preferredStyle: .alert)
    alertController.addTextField { textField in
        textField.placeholder = "Новое имя"
        textField.isSecureTextEntry = false
    }
    
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
        mainAction()
        let textField = alertController.textFields?.first
       UserDefaults().set(textField?.text, forKey: "name")
    }))
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    return alertController

    
    }
}



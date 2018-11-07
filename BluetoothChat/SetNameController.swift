//
//  SetNameController.swift
//  BluetoothChat
//
//  Created by Mikhail on 07/11/2018.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import UIKit

class SetNameController: UIViewController {

    @IBOutlet var nameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func go(_ sender: Any) {
        
        if nameText.text != "" {
    UserDefaults().set(nameText.text, forKey: "name")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

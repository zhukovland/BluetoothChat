//
//  ChatViewController.swift
//  BluetoothChat
//
//  Created by Mikhail on 06/11/2018.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import UIKit
import CoreBluetooth

class ChatViewController: UIViewController {
    
    
    @IBOutlet var massageText: UITextField!
    @IBOutlet var chat: UITableView!
    @IBOutlet var sendMessageView: UIView!
    
    var centralManager: CBCentralManager?
    var peripheralManager = CBPeripheralManager()
    var canSendMassage = false
    var cellINeed = ChatCell()
    var changeName = false
    
    var massageArray = [MessageOptions]()

    override func viewDidLoad() {
        super.viewDidLoad()
        chat.delegate = self
        chat.dataSource = self
        chat.separatorStyle = .none
        chat.allowsSelection = false
        chat.rowHeight = UITableView.automaticDimension
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        hideKeyBoardWhenTapped()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMoveFromBack), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMoveToBack), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func appMoveFromBack() {
        self.sendMessageFunc("Online")
    }
    
    @objc func appMoveToBack() {
        self.sendMessageFunc("Offline")
         self.view.endEditing(true)
    }
    
    
    @IBAction func settings(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendMassage(_ sender: Any) {
        
        if massageText.text != "" && canSendMassage {
            sendMessageFunc(massageText.text!)
            self.view.endEditing(true)
        }
    }

    
    
    func sendMessageFunc(_ withText: String) {
        peripheralManager.stopAdvertising()
        let advertisementData = String(format: "%@: %@", UserDefaults().string(forKey: "name") ?? "", withText)
        massageArray.append(MessageOptions(messageText: advertisementData, isItMyMessage: true))
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
        chat.reloadData()
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.massageArray.count - 1, section: 0)
            self.chat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.massageText.text = ""
        }
    }
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return massageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if massageArray[indexPath.row].isItMyMessage  {
            cellINeed = tableView.dequeueReusableCell(withIdentifier: "chatCell2", for: indexPath) as! ChatCell
        }
        else {
              cellINeed = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        }
        cellINeed.isItMyMessage = massageArray[indexPath.row].isItMyMessage
        cellINeed.massageText.text = "\(massageArray[indexPath.row].messageText)  "

        return cellINeed

    }
}

extension ChatViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: nil)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let m = advertisementData[CBAdvertisementDataLocalNameKey] {
            print(m)
            massageArray.append(MessageOptions(messageText: m as! String, isItMyMessage: false))
            chat.reloadData()
            let indexPath = IndexPath(row: self.massageArray.count - 1, section: 0)
            self.chat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }

    }
    
}

extension ChatViewController:CBPeripheralManagerDelegate {

    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == .poweredOn {
            canSendMassage = true
        }
    }
}


extension ChatViewController {
    
    func hideKeyBoardWhenTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyBoard))
        tap.cancelsTouchesInView = false
        chat.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= keyboardSize.height
        
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y += keyboardSize.height
            

        }
    }
    
    
}

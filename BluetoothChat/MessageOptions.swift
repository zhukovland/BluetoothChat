//
//  MassageOptions.swift
//  BluetoothChat
//
//  Created by Mikhail on 06/11/2018.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import Foundation

struct MessageOptions {
    
    var messageText = ""
    var isItMyMessage = false
    
    public init(messageText: String, isItMyMessage: Bool) {
        
        self.messageText = messageText
        self.isItMyMessage = isItMyMessage
    }
    
}

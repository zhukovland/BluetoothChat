//
//  ChatCell.swift
//  BluetoothChat
//
//  Created by Mikhail on 06/11/2018.
//  Copyright © 2018 Mikhail. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet var massageText: UILabel!

    @IBOutlet var leftLayout: NSLayoutConstraint!
    
    @IBOutlet var rightLayout: NSLayoutConstraint!
    
    var isItMyMessage = false {
        didSet {
            if isItMyMessage {
                massageText.backgroundColor = .gray
            }
            else {
                massageText.backgroundColor = .blue
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        massageText.layer.cornerRadius = 8.0
        massageText.clipsToBounds = true
        massageText.textColor = .white

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

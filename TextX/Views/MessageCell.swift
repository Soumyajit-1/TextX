//
//  MessageCell.swift
//  TextX
//
//  Created by Soumyajit Pal on 04/12/23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var messageLable: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var meAvatar: UIImageView!
    @IBOutlet weak var youAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = messageLable.frame.size.height/4
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

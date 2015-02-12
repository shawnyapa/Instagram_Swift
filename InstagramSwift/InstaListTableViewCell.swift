//
//  InstaListTableViewCell.swift
//  InstagramSwift
//
//  Created by Shawn Yapa on 2/10/15.
//  Copyright (c) 2015 Shawn Yapa. All rights reserved.
//

import UIKit
import Alamofire

class InstaListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var caption: UITextView?
    @IBOutlet weak var thumbnailImage: UIImageView?
    var request: Alamofire.Request?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

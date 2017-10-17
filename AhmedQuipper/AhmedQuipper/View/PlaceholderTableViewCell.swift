//
//  PlaceholderTableViewCell.swift
//  AhmedQuipper
//
//  Created by Ahmed Bakir on 2017/10/17.
//  Copyright © 2017 Ahmed Bakir. All rights reserved.
//

import UIKit
import FontAwesome_swift

class PlaceholderTableViewCell: UITableViewCell {

    @IBOutlet weak var iconLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // To use FontAwesome for icons in labels, we need to change the font 
        
        self.iconLabel?.font = UIFont.fontAwesome(ofSize: StoryboardConstants.placeholderIconSize)
        self.iconLabel?.text = String.fontAwesomeIcon(name: .cloudDownload)
    }

}

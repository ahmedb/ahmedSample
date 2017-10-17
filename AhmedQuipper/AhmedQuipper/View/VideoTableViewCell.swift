//
//  VideoTableViewCell.swift
//  AhmedQuipper
//
//  Created by Ahmed Bakir on 2017/10/09.
//  Copyright © 2017 Ahmed Bakir. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var durationLabel: UILabel?
    @IBOutlet weak var presenterLabel: UILabel?
    
    @IBOutlet weak var thumbnailImageView: UIImageView?
    @IBOutlet weak var cardView: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Set the shadow for the cell, this should execute after the border is rounded, to generate a rounded shadow
        
        cardView?.layer.masksToBounds = false
        cardView?.layer.shadowColor = UIColor.black.cgColor
        cardView?.layer.shadowRadius = 1.0
        cardView?.layer.shadowOpacity = 0.5
        cardView?.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Set a rounded border for the cell
        
        cardView?.layer.borderColor = UIColor.lightGray.cgColor
        cardView?.layer.borderWidth = 1.0
        cardView?.layer.cornerRadius = 4.0
    }

}

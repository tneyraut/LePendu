//
//  TableViewCellWithSwitch.swift
//  CellLibrary
//
//  Created by Thomas Mac on 06/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class TableViewCellWithSwitch: UITableViewCell {

    internal let switchObject = UISwitch()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let decalage = CGFloat(10.0)
        
        self.switchObject.frame = CGRectMake(self.frame.size.width - self.switchObject.frame.size.width - decalage, (self.frame.size.height - self.switchObject.frame.height) / 2, self.switchObject.frame.size.width, self.switchObject.frame.size.height)
        
        self.imageView?.frame = CGRectMake(decalage, decalage, self.frame.size.height - 2 * decalage, self.frame.size.height - 2 * decalage)
        
        self.textLabel?.frame = CGRectMake((self.imageView?.frame.size.width)! + 2 * decalage, 0.0, self.frame.size.width - (self.imageView?.frame.size.width)! - 4 * decalage - self.switchObject.frame.width, self.frame.size.height)
        
        self.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        
        self.layer.borderWidth = 2.5
        self.layer.cornerRadius = 7.5
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
        
        self.addSubview(self.switchObject)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

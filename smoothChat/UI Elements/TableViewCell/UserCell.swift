//
//  UserCell.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {

    @IBOutlet weak var lblUser: UILabel!
    var user : [String:Any]!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
    }
    
}

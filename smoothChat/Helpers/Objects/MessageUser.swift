//
//  User.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import MessengerKit

struct MessageUser: MSGUser {
    var avatar: UIImage?
    
    var displayName: String
    
    var isSender: Bool
}

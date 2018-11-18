//
//  BorderedButon.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import UIKit

class BorderedButon: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = Constants.mainBorderColor
        self.layer.borderWidth = Constants.mainBorderWidth
    } 

}

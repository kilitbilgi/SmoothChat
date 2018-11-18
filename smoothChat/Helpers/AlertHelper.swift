//
//  AlertHelper.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import UIKit
import PMAlertController

class AlertHelper: NSObject {
    
    static let shared = AlertHelper()
    
    private override init() {}
    
    func showError(vc:UIViewController,title:String,description:String){
        let alertVC = PMAlertController(title: title, description: description, image: nil, style: .alert)
        
        alertVC.addAction(PMAlertAction(title: NSLocalizedString("Close", comment: "") , style: .cancel))
        
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    func showSuccess(vc:UIViewController,title:String,description:String,completion:(() -> Void)?){
        let alertVC = PMAlertController(title: title, description: description, image: nil, style: .alert)
        
        alertVC.addAction(PMAlertAction(title: NSLocalizedString("Continue", comment: "") , style: .default, action: completion))
        
        vc.present(alertVC, animated: true, completion: nil)
    }
    
    func areYouSure(vc:UIViewController){
        let alertVC = PMAlertController(title: NSLocalizedString("Are you sure", comment: ""), description: NSLocalizedString("Realy want to logout?", comment: ""), image: nil, style: .alert)
        
        alertVC.addAction(PMAlertAction(title: NSLocalizedString("Cancel", comment: "") , style: .cancel))
        
        alertVC.addAction(PMAlertAction(title: NSLocalizedString("Accept", comment: "") , style: .default){
            FirebaseHelper.shared.logout(source: vc)
        })
        
        vc.present(alertVC, animated: true, completion: nil)
        
    }
}

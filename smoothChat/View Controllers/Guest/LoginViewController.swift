//
//  ViewController.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.login()
        self.register()
    }
    
    private func login(){
        
        self.btnLogin.rx.tap.bind{
            if let email = self.tfEmail.text, let password = self.tfPassword.text {
                
                FirebaseHelper.shared.login(data: ["email":email,"password":password]) { (success) in
                    if success {
                        AlertHelper.shared.showSuccess(vc: self, title: NSLocalizedString("Success", comment: ""), description: "Login Success", completion: {
                            let vc = VCHelper.shared.getVC(sbName: "User", id: "UsersViewController")
                            vc.title = NSLocalizedString("Users", comment: "")
                            VCHelper.shared.presentVCWithNav(source: self, dest: vc)
                        })
                    }else{
                        //Show error dialog
                        AlertHelper.shared.showError(vc: self, title: NSLocalizedString("Error", comment: ""), description: "Login Failed")
                    }
                }
                
            }
        }.disposed(by: self.disposeBag)
        
    }
    
    private func register(){
        self.btnRegister.rx.tap.bind{
            let vc = VCHelper.shared.getVC(sbName: Constants.storyboardGuest, id: "RegisterViewController")
            VCHelper.shared.presentVC(source: self, dest: vc)
        }.disposed(by: self.disposeBag)
    }

}

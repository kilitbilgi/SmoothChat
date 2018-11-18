//
//  RegisterViewController.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.login()
        self.register()
    }
    
    private func register(){
        
        self.btnRegister.rx.tap.bind{
            
            self.view.endEditing(true)
            
            if let email = self.tfEmail.text, let password = self.tfPassword.text {
                
                FirebaseHelper.shared.register(data: ["email":email,"password":password]) { (success) in
                    if success {
                        AlertHelper.shared.showSuccess(vc: self, title: NSLocalizedString("Success", comment: ""), description: "Register Success", completion: {
                            let vc = VCHelper.shared.getVC(sbName: Constants.storyboardGuest, id: "LoginViewController")
                            VCHelper.shared.presentVC(source: self, dest: vc)
                        })
                    }else{
                        //Show error dialog
                        AlertHelper.shared.showError(vc: self, title: NSLocalizedString("Error", comment: ""), description: "Register Failed")
                    }
                }
                
            }
            }.disposed(by: self.disposeBag)
        
    }
    
    private func login(){
        self.btnLogin.rx.tap.bind{
            let vc = VCHelper.shared.getVC(sbName: Constants.storyboardGuest, id: "LoginViewController")
            VCHelper.shared.presentVC(source: self, dest: vc)
        }.disposed(by: self.disposeBag)
    }

}

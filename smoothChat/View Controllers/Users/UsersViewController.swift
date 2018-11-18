//
//  TalkListViewController.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewController: UIViewController {

    @IBOutlet weak var tblViewTalkList: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblViewTalkList.tableFooterView = UIView()
        self.tblViewTalkList.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        self.tblViewTalkList.separatorInset = .zero
        
        self.loadUsers()
        self.userSelected()
        self.logoutBarButtonItem()
    }
    
    private func loadUsers(){
        
        self.tblViewTalkList.delegate = nil
        self.tblViewTalkList.dataSource = nil
        
        FirebaseHelper.shared.getUsers { (result) in
            result.bind(to: self.tblViewTalkList.rx.items(cellIdentifier: "UserCell", cellType: UserCell.self)) { (index, user, cell) in
                
                let title = user["email"] as! String
            
                cell.lblUser.text = title
                cell.user = user
            }.disposed(by: self.disposeBag)
        }
        
    }
    
    private func userSelected(){
        self.tblViewTalkList.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.didSelectTalk(indexPath: indexPath)
        }).disposed(by: self.disposeBag)
    }
    
    private func didSelectTalk(indexPath:IndexPath){
        let cell = self.tblViewTalkList.cellForRow(at: indexPath) as! UserCell
        
        let vc = VCHelper.shared.getVC(sbName: "User", id: "TalkViewController") as! TalkViewController
        vc.user = cell.user
        vc.title = cell.user["email"] as? String
        
        VCHelper.shared.pushVC(source: self, dest: vc)
    }
    
    private func logoutBarButtonItem(){
        let logoutItem = UIBarButtonItem(title: NSLocalizedString("Logout", comment: ""), style: .plain, target: self, action: nil)
        
        self.navigationItem.rightBarButtonItem = logoutItem
        
        logoutItem.rx.tap.bind {
            AlertHelper.shared.areYouSure(vc: self)
            }.disposed(by: self.disposeBag)
    }

}

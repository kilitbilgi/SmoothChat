//
//  FirebaseHelper.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import UIKit
import Firebase
import RxSwift

class FirebaseHelper: NSObject {

    static let shared = FirebaseHelper()
    
    private override init() {}
    
    func login(data:NSDictionary,completion:@escaping (Bool) -> ()){
        guard let email = data.object(forKey: "email") as? String else { return }
        guard let password = data.object(forKey: "password") as? String else { return }

        Auth.auth().signIn(withEmail: email, password: password) { (result:AuthDataResult?, error:Error?) in
            completion(error == nil)
        }
    }
    
    func register(data:NSDictionary,completion:@escaping (Bool) -> ()){
        guard let email = data.object(forKey: "email") as? String else { return }
        guard let password = data.object(forKey: "password") as? String else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result:AuthDataResult?, error:Error?) in
            
            if error == nil {
                Firestore.firestore().collection(Constants.tableUsers).addDocument(data: ["email":result!.user.email!,"authID":result!.user.uid])
            }
            
            completion(error == nil)
        }
    }
    
    func getUsers(completion:@escaping (Observable<[[String : Any]]>) -> ()){
        Firestore.firestore().collection(Constants.tableUsers).getDocuments { (snapshot:QuerySnapshot?, error :Error?) in
            if error == nil {
                
                let docFiltered = snapshot!.documents.filter({ (doc) -> Bool in
                    return doc.data()["email"] as? String != FirebaseHelper.shared.getCurrentUser().email
                })
                
                let items = Observable.just((docFiltered).map { $0.data() })
                completion(items)
            }
        }
    }
    
    func getTalks(talkID:String,completion:@escaping FIRQuerySnapshotBlock){
        Firestore.firestore().collection(Constants.tableTalks).document(talkID).collection("inner").order(by: "timeStamp").getDocuments(completion: completion)
    }
    
    func onTalkAdded(talkID:String,completion:@escaping FIRQuerySnapshotBlock){
        Firestore.firestore().collection(Constants.tableTalks).document(talkID).collection("inner").order(by: "timeStamp").addSnapshotListener(completion)
    }
    
    func createNewTalk(talkID:String,data:[String:Any]){
        var timeStampAddedData = data
        timeStampAddedData["timeStamp"] = Date().timeIntervalSince1970
        
        Firestore.firestore().collection(Constants.tableTalks).document(talkID).collection("inner").addDocument(data: timeStampAddedData)
    }
    
    func getCurrentUser() -> User{
        return Auth.auth().currentUser!
    }
    
    func getCurrentUserID() -> String{
        return Auth.auth().currentUser!.uid
    }
    
    func isLoggedIn() -> Bool{
        if let _ = Auth.auth().currentUser {
            return true
        }else{
            return false
        }
    }
    
    func getTalkID(user:[String:Any]) -> String{
        let userIDOne = user["authID"] as! String
        let userIDTwo = FirebaseHelper.shared.getCurrentUserID()
        
        var usersIDs = [userIDOne,userIDTwo]
        
        usersIDs.sort { (one, two) -> Bool in
            return one < two
        }
        
        return usersIDs.joined(separator: "-")
    }
    
    func logout(source:UIViewController){
        try! Auth.auth().signOut()
        
        let dest = VCHelper.shared.getVC(sbName: Constants.storyboardGuest, id: "LoginViewController")
        
        VCHelper.shared.presentVC(source: source, dest: dest)
    }
}

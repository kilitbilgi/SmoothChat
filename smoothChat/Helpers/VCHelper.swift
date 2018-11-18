//
//  VCHelper.swift
//  smoothChat
//
//  Created by Burak Colak on 18.11.2018.
//  Copyright © 2018 Burak Colak. All rights reserved.
//

import UIKit

class VCHelper: NSObject {
    
    static let shared = VCHelper()
    
    private override init() {}
    
    func getVC(sbName:String,id:String)->UIViewController{
        return UIStoryboard.init(name: sbName, bundle: nil).instantiateViewController(withIdentifier: id)
    }
    
    func presentVC(source:UIViewController,dest:UIViewController){
        source.present(dest, animated: true, completion: nil)
    }
    
    func presentVCWithNav(source:UIViewController,dest:UIViewController){
        let nav = UINavigationController(rootViewController: dest)
        
        let gradient = CAGradientLayer()
        
        var frame = nav.navigationBar.bounds
        frame.size.height += UIApplication.shared.statusBarFrame.height
        gradient.frame = frame
        
        source.present(nav, animated: true, completion: nil)
    }
    
    func pushVC(source:UIViewController,dest:UIViewController){
        source.navigationController?.pushViewController(dest, animated: true)
    }

}

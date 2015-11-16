//
//  Account.swift
//  TransAcc
//
//  Created by Lubos Sytensky on 14/11/15.
//  Copyright © 2015 Lubos Sytensky. All rights reserved.
//

import UIKit


/// Data object for one item displeyed in detail account view
class Account: NSObject {

   
    var name:String?
    var currency:String?
    var banknum:String?
    var balance:Double?
    var transparencyFrom:String?
    var transparencyTo:String?
    var publicationTo:String?
    var actualizationDate:String?
    
    func setNames(name: String){
        self.name = name
    }
    
    
}

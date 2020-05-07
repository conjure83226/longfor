//
//  JCRequestData.swift
//  longfor
//
//  Created by jack on 2020/5/7.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class JCRequestData: NSObject {
    var params:NSMutableDictionary = NSMutableDictionary()
    var result:NSMutableDictionary = NSMutableDictionary()
    var adress:String! = app.adress()
    var isErrorUseSave:Bool = false
    var timeout:TimeInterval = 30
    var exKeySave:String! = ""
    var tips:String! = ""
    var path:String! = ""
    
    func encryptInfo() -> NSDictionary! {
        return params
    }
    
}

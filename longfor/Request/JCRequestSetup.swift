//
//  JCRequestSetup.swift
//  longfor
//
//  Created by jack on 2020/5/7.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class JCRequestSetup: NSObject {
    var isSave:Bool = false
    var isHideWait:Bool = false
    var isNetErrorUseLastSucessSave:Bool = true
    var requestDatas:Array<JCRequestData> = Array<JCRequestData>()
}

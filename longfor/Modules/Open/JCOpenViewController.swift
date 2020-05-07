//
//  JCOpenViewController.swift
//  longfor
//
//  Created by jack on 2020/5/2.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class JCOpenViewController: UIViewController {
    
    @IBOutlet weak var uiTips: UILabel!
    
    public class func show(nc: UINavigationController?) {
        if let nc = nc {
            let sb = UIStoryboard.init(name: "JCOpen", bundle: Bundle.main)
            let vc = sb.instantiateViewController(withIdentifier: "JCOpenViewController")
            nc.pushViewController(vc, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiTips.text = NSLocalizedString("OpenTitle", comment: "启动文本")
        uiTips.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            self.uiTips.alpha = 1
        }) { (Bool) in
            self.navigationController?.popViewController(animated: JCAnimatorAlphaAndScale.animator(target: self.navigationController, animated: true))
        }
        let data = JCRequestData()
        data.path = app.datastore_search()
        data.params["resource_id"] = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f";
        data.params["q"] = "jones";
        let setup = JCRequestSetup()
        setup.isSave = true
        setup.requestDatas.append(data)
        let _ = JCRequest.post(setup: setup, success: { (datas:Array<JCRequestData>) in
        }, failed: { (data:JCRequestData) in
        }, end: {
        })
    }
    
}

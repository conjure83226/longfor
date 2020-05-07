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
    }
    
}

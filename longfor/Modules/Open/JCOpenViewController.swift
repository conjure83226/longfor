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
            let vc = UIStoryboard.init(name: "JCOpen", bundle: Bundle.main).instantiateViewController(withIdentifier: "JCOpenViewController")
            nc.pushViewController(vc, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiTips.text = NSLocalizedString("OpenTips", comment: "启动文本")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

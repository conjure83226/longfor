//
//  JCHomeViewController.swift
//  longfor
//
//  Created by jack on 2020/5/3.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class JCHomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JCOpenViewController.show(nc: self.navigationController)
        self.navigationItem.title = NSLocalizedString("HomeTitle", comment: "主页标题")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

//
//  JCHomeViewController.swift
//  longfor
//
//  Created by jack on 2020/5/3.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class JCHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var uiList: UITableView!
    let dataList:NSMutableArray = NSMutableArray()
    
    func uploadData() {
        let setup = JCRequestSetup()
        for i in 2008...2018 {
            let data = JCRequestData()
            data.path = app.datastore_search()
            data.params["resource_id"] = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f";
            data.params["q"] = "\(i)";
            setup.requestDatas.append(data)
        }
        let loading = UIAlertController(title: "loading", message: "please wait", preferredStyle: UIAlertController.Style.alert)
        self.present(loading, animated: true)
        let _ = JCRequest.post(setup: setup, success: { (datas:Array<JCRequestData>) in
            loading.dismiss(animated: false)
            let list = NSMutableDictionary()
            for data in datas {
                if let result = data.result["result"] as? NSDictionary
                {
                    if let records = result["records"] as? NSArray
                    {
                        var isDown = false
                        var last:Double = 0
                        var total:Double = 0
                        for item in records {
                            if let dic = item as? NSDictionary {
                                if let num = dic["volume_of_mobile_data"] as? NSString
                                {
                                    let now = num.doubleValue
                                    if now > last {
                                        last = now
                                    }
                                    else
                                    {
                                        isDown = true
                                    }
                                    total += now
                                }
                            }
                        }
                        let newItem = NSMutableDictionary()
                        newItem["total"] = NSString(format: "%0.6f", total)
                        newItem["year"] = data.params["q"]
                        newItem["isDown"] = isDown
                        list[data.params["q"] as! String] = newItem
                    }
                }
            }
            self.dataList.removeAllObjects()
            for i in 2008...2018 {
                self.dataList.add(list["\(i)"] as Any)
            }
            self.uiList.reloadData()
        }, failed: { (data:JCRequestData) in
            loading.dismiss(animated: false) {
                let alert = UIAlertController(title: "failed", message: "upload data error", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel))
                self.present(alert, animated: true)
            }
        }, end: {
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JCOpenViewController.show(nc: self.navigationController)
        self.navigationItem.title = NSLocalizedString("HomeTitle", comment: "主页标题")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.uploadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = dataList[indexPath.row] as! NSDictionary
        if let year = cell.contentView.viewWithTag(100) as? UILabel {
            year.text = item["year"] as? String
        }
        if let num = cell.contentView.viewWithTag(101) as? UILabel {
            num.text = item["total"] as? String
        }
        if let btn = cell.contentView.viewWithTag(102) as? UIButton {
            let hide = item["isDown"] as? Bool ?? false
            btn.isHidden = !hide
        }
        return cell
    }
    
}

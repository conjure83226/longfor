//
//  JCRequest.swift
//  longfor
//
//  Created by jack on 2020/5/7.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import AFNetworking

class JCRequest: NSObject {
    
    static var countTag:NSInteger = 0
    static let cache:NSMutableDictionary = NSMutableDictionary()
    static var manager:AFHTTPSessionManager! {
        get {
            let value = AFHTTPSessionManager()
            let newSet = NSMutableSet()
            if let types = value.responseSerializer.acceptableContentTypes {
                newSet.setSet(types)
                newSet.add("text/html")
                value.responseSerializer.acceptableContentTypes = newSet as? Set<String>
            }
            if let ser = value.responseSerializer as? AFJSONResponseSerializer {
                ser.removesKeysWithNullValues = true
            }
            return value
        }
    }
    
    var requestDatas:Array<JCRequestData> = Array<JCRequestData>()
    var tasks:Array<URLSessionTask> = Array<URLSessionTask>()
    var success:((_ datas:Array<JCRequestData>) -> Void)? = nil
    var failed:((_ data:JCRequestData) -> Void)? = nil
    var end:(() -> Void)? = nil
    var setup:JCRequestSetup!
    var tag:NSInteger = 0
    
    static func post(setup:JCRequestSetup!, success:((_ datas:Array<JCRequestData>) -> Void)? = nil, failed:((_ data:JCRequestData) -> Void)? = nil, end:(() -> Void)? = nil) -> JCRequest? {
        if setup.requestDatas.count > 0
        {
            countTag += 1
            let req:JCRequest = JCRequest()
            JCRequest.cache[NSNumber(integerLiteral: countTag)] = req
            req.success = success
            req.failed = failed
            req.tag = countTag
            req.setup = setup
            req.end = end
            req.sendData()
            return req
        }
        return nil
    }
    
    static func cancelAll() {
        if JCRequest.cache.count > 0 {
            for value in JCRequest.cache.allValues {
                if let req = value as? JCRequest {
                    req.cancel()
                }
            }
        }
    }
    
    func checkResult(data:JCRequestData!, url:String!, responseObject:NSDictionary!) {
        data.result = NSMutableDictionary(dictionary: responseObject)
        data.tips = data.result["msg"] as? String
        if let state = data.result["success"] as? Bool
        {
            if state
            {
                self.didSuccess(data: data, url: url)
                return
            }
        }
        self.didFailure(data: data, url: url, tips: data.tips, confirm: nil)
    }
    
    func didSuccess(data:JCRequestData!, url:String!) {
        requestDatas.append(data)
        if requestDatas.count == setup.requestDatas.count {
            if setup.isSave || setup.isNetErrorUseLastSucessSave {
                for item:JCRequestData in requestDatas
                {
                    UserDefaults.standard.set(self.toJsonString(dic: item.result), forKey: NSString(format: "%@%@", item.path, item.exKeySave) as String)
                }
                UserDefaults.standard.synchronize()
            }
            self.success?(self.requestDatas)
            self.cancel(isEnd: true)
        }
    }
    
    func didFailure(data:JCRequestData!, url:String!, tips:String? = nil, confirm:(() -> Void)? = nil) {
        if tasks.count > 0
        {
            self.failed?(data)
            self.cancel(isEnd: true)
        }
    }
    
    func toJsonDictionary(string:String!) -> NSDictionary! {
        if let data = string.data(using: String.Encoding.utf8)
        {
            do {
                let value = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let dic = value as? NSDictionary
                {
                    return dic
                }
            } catch { }
        }
        return NSDictionary()
    }
    
    func toJsonString(dic:NSDictionary) -> String! {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonStr = String(data: jsonData, encoding: String.Encoding.utf8)
            return jsonStr
        } catch { }
        return ""
    }
    
    func sendData() {
        for data:JCRequestData in setup.requestDatas {
            let url = NSString(format: "%@%@", data.adress, data.path) as String
            JCRequest.manager.requestSerializer.willChangeValue(forKey: "timeoutInterval")
            JCRequest.manager.requestSerializer.timeoutInterval = data.timeout
            JCRequest.manager.requestSerializer.didChangeValue(forKey: "timeoutInterval")
            let params = data.encryptInfo()
            let task = JCRequest.manager.get(url, parameters: params, progress: nil, success: { (task:URLSessionDataTask, responseObject:Any?) in
                if let value = responseObject as? NSDictionary {
                    self.checkResult(data: data, url: url, responseObject: value)
                } else {
                    self.didFailure(data: data, url: url, tips: "dic get error")
                }
            }) { (task:URLSessionDataTask?, error:Error) in
                if self.setup.isNetErrorUseLastSucessSave {
                    let saveResult = UserDefaults.standard.object(forKey: NSString(format:"%@%@", data.path, data.exKeySave) as String) as? String
                    if saveResult != nil {
                        data.isErrorUseSave = true
                        self.checkResult(data: data, url: url, responseObject: self.toJsonDictionary(string: saveResult))
                        return
                    }
                }
                self.didFailure(data: data, url: url, tips: error.localizedDescription)
            }
            if let value = task
            {
                tasks.append(value)
            }
        }
    }
    
    func cancel(isEnd:Bool = false) {
        failed = nil
        success = nil
        for task:URLSessionTask in tasks
        {
            if (task.state == URLSessionTask.State.running)
            {
                task.cancel()
            }
        }
        tasks.removeAll()
        JCRequest.cache.removeObject(forKey: NSNumber(integerLiteral: tag))
        if isEnd
        {
            end?()
            end = nil
        }
    }
    
    deinit {
        print("Request deinit")
    }
    
}

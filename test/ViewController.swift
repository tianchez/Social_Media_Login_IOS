//
//  ViewController.swift
//  test
//
//  Created by 张天琛 on 5/25/16.
//  Copyright © 2016 张天琛test. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, WXApiDelegate {

    @IBOutlet weak var weiboButton: UIButton!
    @IBOutlet weak var wechatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        Alamofire.request(.POST, "http://52.192.231.140/api/login", parameters: ["login_type": "weibo", "login_token":"2.00aslLKB7X28DE773aa1556c0m7RuH",
            "device_id":"<<some device id>>",
            "device_type": "1"], encoding: ParameterEncoding.JSON).responseJSON { response in
                print(response)
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func weiboButtonclicked(sender: AnyObject) {
        let request = WBAuthorizeRequest()
        request.redirectURI = "http://www.weibo.com"
        request.scope = "all"
        request.userInfo = [
            "SSO_From": "ViewController"
        ]
        
        WeiboSDK.sendRequest(request)
    }
    
    @IBAction func wechatButtonClicked(sender: AnyObject) {
        let req : SendAuthReq = SendAuthReq()
        req.scope = "snsapi_userinfo,snsapi_base"
        req.state = "3564"
        WXApi.sendAuthReq(req, viewController: self, delegate: self)

        
        
    }
    
  

}


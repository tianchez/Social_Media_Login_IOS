//
//  AppDelegate.swift
//  test
//
//  Created by 张天琛 on 5/25/16.
//  Copyright © 2016 张天琛test. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WeiboSDKDelegate,WXApiDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp("3715377988")
        WXApi.registerApp("wx7237720d90a14b05", withDescription: "Lulu")
       
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //微信的跳转回调
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool    {
        return  WXApi.handleOpenURL(url, delegate: self) || WeiboSDK.handleOpenURL(url, delegate: self)

    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool
  {
    return  WXApi.handleOpenURL(url, delegate: self) || WeiboSDK.handleOpenURL(url, delegate: self)
    }
    
       
    // for Weibo
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
    }
    
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        if let authorizeResponse = response as? WBAuthorizeResponse {
            print(authorizeResponse.statusCode.rawValue)
            if authorizeResponse.statusCode == .Success {
                print(authorizeResponse.userInfo)
            }
        }
    }
    
    //WECHAT
    func onResp(resp: BaseResp!) {
        
        /*
         
         ErrCode	ERR_OK = 0(用户同意)
         ERR_AUTH_DENIED = -4（用户拒绝授权）
         ERR_USER_CANCEL = -2（用户取消）
         code	用户换取access_token的code，仅在ErrCode为0时有效
         state	第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
         lang	微信客户端当前语言
         country	微信用户当前国家信息
         */

        let aresp = resp as! SendAuthResp
        
        if (aresp.errCode == 0)
        {
            print(aresp.code)
            //031076fd11ebfa5d32adf46b37c75aax
            
            var dic:Dictionary<String,String>=["code":aresp.code];
            if let value = dic["code"]{
            print("code:\(value)")
            
            Alamofire.request(.GET,"https://api.weixin.qq.com/sns/oauth2/access_token",
                parameters: ["appid": "wx7237720d90a14b05",
                    "secret":"325fd3ded865f18a015df84bf96eeda6",
                    "code":value,
                    "grant_type":"authorization_code"
                ],encoding: .URL).validate().responseJSON
                { (response) -> Void in
                    guard response.result.isSuccess else
                    {
                        print("Error while fetching remote rooms: \(response.result.error)")
                        
                        return
                    }
                    print(response)
                    print(response.result.value?.objectForKey("access_token"))
                    
                }
                    
                
            
        
            }
        }
    }
    
    
    //func

}





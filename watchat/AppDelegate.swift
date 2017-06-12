//
//  AppDelegate.swift
//  watchat
//
//  Created by Omar Dlhz on 5/6/17.
//  Copyright © 2017 Omar De La Hoz. All rights reserved.
//

import UIKit
import WebKit
import WatchConnectivity

var wView: WKWebView!
var waSession : WCSession!


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WKNavigationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        if (WCSession.isSupported()) {
            waSession = WCSession.default()
        }
                
        wView = WKWebView(frame: .zero, configuration: webConfig())
        
        wView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"
        
        DispatchQueue.global(qos: .background).async {
            
            
            let myURL = URL(string: "https://web.whatsapp.com")
            let myRequest = URLRequest(url: myURL!)
            wView.load(myRequest)
        }
        
        return true
    }
    
    
    /// Configuration for a WebKit webView.
    /// Injects jQuery and Javascript necessary to
    /// authenticate the user with WhatsappWeb.
    //
    /// - Returns: Configuration for WebKit webView.
    func webConfig() ->WKWebViewConfiguration{
        
        let webConfig = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        let injectURL:URL! = Bundle.main.url(forResource: "inject", withExtension: "js")
        var injectJS:String = String()
        
        let jqueryURL:URL! = Bundle.main.url(forResource: "jquery", withExtension: "js")
        var jqueryJS:String = String()
        
        do{
            injectJS = try String(contentsOf: injectURL, encoding: .utf8)
            jqueryJS = try String(contentsOf: jqueryURL, encoding: .utf8)
        }
        catch _{
            
        }
        
        
        let injectScript:WKUserScript = WKUserScript(source: injectJS, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
        
        let jqueryScript:WKUserScript = WKUserScript(source: jqueryJS, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)
        
        
        contentController.addUserScript(jqueryScript)
        contentController.addUserScript(injectScript)
                
        webConfig.userContentController = contentController;
        
        return webConfig;
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


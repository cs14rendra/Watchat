//
//  SettingsViewController.swift
//  watchat
//
//  Created by Omar Dlhz on 6/7/17.
//  Copyright © 2017 Omar De La Hoz. All rights reserved.
//

import UIKit
import WebKit
import WatchConnectivity


class SettingsViewController: UIViewController, WCSessionDelegate, WKNavigationDelegate{
  
    
    override func viewDidAppear(_ animated: Bool) {
        
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        waSession.delegate = self;
        waSession.activate();
        wView.navigationDelegate = self
        self.view = wView;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        wView.evaluateJavaScript("checkAuth();", completionHandler: { (result, error) in
            
            let connectionStatus = result as! Bool;
            
            if (!connectionStatus){
                
                self.performSegue(withIdentifier: "noAuth", sender: nil)
            }
            
            let connectionData = ["connection": connectionStatus]
            waSession.sendMessage(connectionData, replyHandler: nil, errorHandler: nil)
        })
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

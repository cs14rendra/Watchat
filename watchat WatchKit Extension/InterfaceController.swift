//
//  InterfaceController.swift
//  watchat WatchKit Extension
//
//  Created by Omar Dlhz on 5/6/17.
//  Copyright © 2017 Omar De La Hoz. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity



class InterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var barcodeImg: WKInterfaceImage!
    
    var session : WCSession!
    var status = false;
    
    var count = 0;

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        barcodeImg.setImageNamed("loader")
        barcodeImg.startAnimatingWithImages(
            in: NSRange(location: 0, length: 11),
            duration: 1,
            repeatCount: 0)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        
        if let barcode = message["barcode"] as? Data {
            
            let image = UIImage(data: barcode)
            barcodeImg.setImage(image)
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

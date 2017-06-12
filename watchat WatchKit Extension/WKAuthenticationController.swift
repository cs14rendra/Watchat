//
//  WKAuthenticationController.swift
//  watchat WatchKit Extension
//
//  Created by Omar Dlhz on 5/6/17.
//  Copyright © 2017 Omar De La Hoz. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class WKAuthenticationController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var barcodeImg: WKInterfaceImage!
    
    @IBOutlet var lbl: WKInterfaceLabel!
    var session : WCSession!
    var status = false;
    
    var count = 0;
    var repeatTimer:Timer!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        barcodeImg.setImageNamed("loader")
        barcodeImg.startAnimatingWithImages(
            in: NSRange(location: 0, length: 15),
            duration: 0.7,
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
    
    /**
     Once the WKAuthenticationController appears, request QRCodes
     to the iOS app and repeat every 20 seconds (interval in which
     WhatsApp web generates new QRCodes).
    **/
    override func didAppear() {
        
        // Gets the first QRCode.
        getQRCode()
        
        // Repeats the QRCode request every 20 seconds.
        repeatTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(getQRCode), userInfo: nil, repeats: true)
    }
    
    /**
     Sends message requesting QRCode from iOS app in AuthenticationController.
    **/
    func getQRCode(){
        
        session.sendMessage(["message":"Text" as Any], replyHandler: nil, errorHandler: nil)
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        
        if let barcode = message["barcode"] as? Data {
            
            let image = UIImage(data: barcode)
            barcodeImg.setImage(image)
        }
        
        
        if let connection = message["connection"] as? Bool{
            
            repeatTimer.invalidate();
            presentController(withName: "chatLobby", context: nil)
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

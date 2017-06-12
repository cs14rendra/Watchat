//
//  filename: AuthenticationController.swift
//
//  description: Controller to manage user authentication to
//  WhatsappWeb client.
//
//  author: Omar De La Hoz (omar.dlhz@hotmail.com)
//  date: 05/22/17
//
//  Copyright © 2017 Omar De La Hoz. All rights reserved.
//

import UIKit
import WebKit
import WatchConnectivity


class AuthenticationController: UIViewController, WCSessionDelegate {
    
    
    var count = 0;
    
    override func viewDidAppear(_ animated: Bool) {
        
        waSession.delegate = self;
    }
    
    /// Runs once the AuthenticationController is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
   
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    /**
     Receive barcode request from AppleWatch.
     Checks if user is not authenticated and if barcode exists.
     
     If user isn't authenticated and barcode exists, it sends a
     Message dictionary of Type "barcode" to the Watch.
     If user is authenticated and barcode doesn't exist, a Message
     dictionary of Type "connection" is sent to the Watch.
    **/
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        print("received " + String(count))
        count += 1;
    
        wView.evaluateJavaScript("getBarcodeX()") { (result, error) in
            
            let messageBody = result as AnyObject
            
            let connection = messageBody["connection"] as! Bool
            let msgType =  messageBody["msgType"] as! String
            let msgData = messageBody["msgData"] as! String
            
            if(!connection && msgType == "barcode"){
                
                let base64URL = URL(string: msgData)
                let blackData = try? Data(contentsOf: base64URL!)
                
                // Convert black QRCode to white so it can be readable
                // on a black background.
                let whiteImg = UIImage(data: blackData!)?.invertedImage()
                let whiteData:Data = UIImagePNGRepresentation(whiteImg!)!
                
                // Send white QRCode to AppleWatch.
                let barcodeData = ["barcode":whiteData]
                
                print("code sent")
                session.sendMessage(barcodeData, replyHandler: nil, errorHandler: nil)
            }
            else{
                
                self.dismiss(animated: true, completion: nil)
                let connectionData = ["connection": connection]
                session.sendMessage(connectionData, replyHandler: nil, errorHandler: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


/**
 Inverts the colors of a UIImage.
 Used specifically to invert the colors of the
 QRCode to make it scannable on a black background.
 **/
extension UIImage {
    func invertedImage() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let ciImage = CoreImage.CIImage(cgImage: cgImage)
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        let context = CIContext(options: nil)
        guard let outputImage = filter.outputImage else { return nil }
        guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: outputImageCopy)
    }
}


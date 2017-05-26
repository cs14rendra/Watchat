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


class ViewController: UIViewController, WCSessionDelegate, WKScriptMessageHandler {
    
    var session : WCSession!
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    /// Runs once the AuthenticationController is loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (WCSession.isSupported()) {
            session = WCSession.default()
            session.delegate = self;
            session.activate()
        }
        
        
        webView = WKWebView(frame: .zero, configuration: webConfig())
        
        
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"
        
        
        let myURL = URL(string: "https://web.whatsapp.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        view = webView;
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
        
        contentController.add(self, name: "notification")
        
        webConfig.userContentController = contentController;
        
        return webConfig;
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // Get QRCode from messageHandler
        let messageBody = message.body as! String
        let base64URL = URL(string: messageBody)
        let blackData = try? Data(contentsOf: base64URL!)
        
        // Convert black QRCode to white so it can be readable
        // on a black background.
        let whiteImg = UIImage(data: blackData!)?.invertedImage()
        let whiteData:Data = UIImagePNGRepresentation(whiteImg!)!
        
        // Send white QRCode to AppleWatch.
        let barcodeData = ["barcode":whiteData]
        session = WCSession.default()
        session.sendMessage(barcodeData, replyHandler: nil, errorHandler: nil)
    }
    
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

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


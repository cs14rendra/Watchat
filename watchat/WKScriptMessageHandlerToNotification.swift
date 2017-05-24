//
// Created by Tom Schmidt on 10.03.16.
// Copyright (c) 2016 Tom Schmidt. All rights reserved.
//

import Foundation
import WebKit

class WKScriptMessageHandlerToNotification: NSObject, WKScriptMessageHandler {
    
    var counter = 0
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("here")
        
        let messageBody = message.body as! String
        
        let base64URL = URL(string: messageBody)
        let imageData = try? Data(contentsOf: base64URL!)

        let decodedimage:UIImage = UIImage(data: imageData!)!
        print(decodedimage)
        
        
        
    }
}

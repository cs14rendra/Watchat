/*******
filename: inject.js
description: injects Javascript into webView
author: Omar De La Hoz (omar.dlhz@hotmail.com)
date: 05/06/17
********/

var TIME_WAIT = 20000;

/**
 Waits 20 seconds to get the first barcode
 from the web client.
**/
var load = setTimeout(function() {
    getBarcode();
}, TIME_WAIT);


/**
 Gets the url of the bardcode being
 displayed at it sends it to the messageHandler
 inside the AuthenticationController.
**/
function getBarcode(){
    
    var url = "";
    
    $('img').on('load', function () {

        reloadCode()
        url = $('img').attr('src');
        webkit.messageHandlers.notification.postMessage(url);
    });
    
    url = $('img').attr('src');
    webkit.messageHandlers.notification.postMessage(url);
}


var reload = false;

/**
 Clicks on the "Click to Retry" button
 that appears over the QRCode after 5
 codes have been displayed.
**/
function reloadCode(){
    
    if(!reload){
        
        setTimeout(function(){
                   
                   // Waits until the qrcode reload button
                   // exists.
                   while($('.qr-button')[0] === undefined){
                   }
                   
                   $('.qr-button')[0].click();
                   reload = false;
                   reloadCode();
                   
        }, TIME_WAIT * 5);
        
        reload = true;
    }
}

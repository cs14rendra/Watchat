/*******
filename: inject.js
description: injects Javascript into webView
author: Omar De La Hoz (omar.dlhz@hotmail.com)
date: 05/06/17
********/


/**
 Looks for a QRCode and sends a message to the
 Swift app of Type "barcode".
 
 Might send a different image (in case that user
 is authenticated), but this is controlled by the
 messageType on the Swift side.
 **/
function getBarcodeX(){
    
    var url = "";
    url = $('img').attr('src');
    return createMsg("barcode", url);
}


/**
 Checks if a user is authenticated by checking
 the Whatsapp SecretBundle in the Webkit's
 localStorage.
 
 @return: True if user is authenticated.
 **/
function checkAuth(){
    
    var auth = localStorage.WASecretBundle;
    return auth !== undefined;
}


/**
 Creates a message to send from WebKit browser to Swift app.
 **/
function createMsg(msgType, msgData){
    
    var connection = checkAuth();
    return {connection: connection, msgType: msgType, msgData: msgData};
}




//
//  InterfaceController.swift
//  SushiWatch Extension
//
//  Created by AJAY BAJWA on 2019-11-01.
//  Copyright © 2019 Parrot. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    var timeRemaining = 25
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if WCSession.isSupported() {
            print("Watch supports WCSession")
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("Session Activated")
        }
        else {
            print("Watch does not support WCSession")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

            let messageBody = message["timeRemaining"] as! Int
            //messageLabel.setText(messageBody)
            self.timeRemaining = messageBody
            print("WATCH: Got message from Phone = \(messageBody)")
        }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func btnLeftClick() {
        if (WCSession.default.isReachable) {
            print("phone reachable")
            let message = ["moveDirection": "left"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            // output a debug message to the console
            print("sent move left to phone")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
    }
    
    @IBAction func btnRightClick() {
        if (WCSession.default.isReachable) {
            print("phone reachable")
            let message = ["moveDirection": "right"]
            WCSession.default.sendMessage(message, replyHandler: nil)
            // output a debug message to the console
            print("sent move right to phone")
        }
        else {
            print("WATCH: Cannot reach phone")
        }
    }
}

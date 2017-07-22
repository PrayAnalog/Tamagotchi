//
//  MCManager.swift
//  Tamagotchi
//
//  Created by USER on 2017. 7. 22..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MCManager: NSObject, MCSessionDelegate {
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant!
    var serviceType = "tamagotchi"
    
    var foundPeers = [MCPeerID]()
    var invitationHandler: ((Bool, MCSession?) -> Void)!
    
    override init() {
        super.init()
    
        peerID = nil
        session = nil
        browser = nil
        advertiser = nil
    }
    
    func setupPeerAndSessionWithDisplayName(name: String) {
        self.peerID = MCPeerID(displayName: name)
        self.session = MCSession(peer: self.peerID)
        self.session.delegate = self
    }
    
    func setupMCBrowser() {
        self.browser = MCBrowserViewController(serviceType: serviceType, session: self.session)
    }
    
    func advertiseMyself(shouldAdvertise: Bool) {
        if shouldAdvertise {
            self.advertiser = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: self.session)
            self.advertiser.start()
        }
        else {
            self.advertiser.stop()
            self.advertiser = nil
        }
    }
    
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(_ session: MCSession, didReceive data: Data,
    fromPeer peerID: MCPeerID)  {
        DispatchQueue.main.async() {
            let data = NSData(data: data)
            var num : NSInteger = 0
            data.getBytes(&num, length: data.length)
        }
    }
    
    func session(_ session: MCSession,
    didStartReceivingResourceWithName resourceName: String,
    fromPeer peerID: MCPeerID, with progress: Progress)  {
    
    // Called when a peer starts sending a file to us
    }
    
    func session(_ session: MCSession,
    didFinishReceivingResourceWithName resourceName: String,
    fromPeer peerID: MCPeerID,
    at localURL: URL, withError error: Error?)  {
    // Called when a file has finished transferring from another peer
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream,
    withName streamName: String, fromPeer peerID: MCPeerID)  {
    // Called when a peer establishes a stream with us
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
    didChange state: MCSessionState)  {
    // Called when a connected peer changes state (for example, goes offline)
    }
    
}

//
//  GameScene.swift
//  pong
//
//  Created by USER on 2017. 7. 20..
//  Copyright © 2017년 Yuna Seol. All rights reserved.
//

import SpriteKit
import GameplayKit
import MultipeerConnectivity

class GameScene: SKScene {
    
    var appDelegate : AppDelegate!

    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    var friendNameLabel = SKLabelNode()
    var score = 0
    var first = true
    
    override func didMove(to view: SKView) {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        friendNameLabel = self.childNode(withName: "friendName") as! SKLabelNode
        
        let notificationName = Notification.Name("MCDidReceiveDataNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePosition(notification:)), name: notificationName, object: nil)
//        friendNameLabel.text = appDelegate.mcManager.session.connectedPeers.description
        
        scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height / 2) - 50
        main = self.childNode(withName: "main") as! SKSpriteNode
        main.position.y = (-self.frame.height / 2) + 50
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
    }
    
    func startGame(isFirstPlayer: Bool) {
        if isFirstPlayer {
            ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
        } else {
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        }
        score = 0
        scoreLabel.text = "\(score)"
    }
    
    func addScore(playerWhoWon: SKSpriteNode) {
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        if playerWhoWon == main {
            score += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        }
        else if playerWhoWon == enemy {
            ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
        }
        
        scoreLabel.text = "\(score)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if first {
            first = false
            sendData(0.0)
            startGame(isFirstPlayer: true)
        }
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.1))
            sendData(location.x)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.1))
            sendData(location.x)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
//        enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1.0))
        if ball.position.y <= main.position.y || ball.position.y >= enemy.position.y {
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
            main.size.width -= 1
        }
        
        if ball.position.y <= main.position.y - 30 {
            addScore(playerWhoWon: enemy)
        }
            
        else if ball.position.y >= enemy.position.y + 30 {
            addScore(playerWhoWon: main)
        }
    }
    
    // send position to other player
    func sendData(_ position: CGFloat) {
        let dict: NSDictionary = [
            "type": "pong",
            "position": position
        ]
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        print(data)
        do {
            try appDelegate.mcManager.session.send(data as Data, toPeers: appDelegate.mcManager.session.connectedPeers, with: MCSessionSendDataMode.unreliable)
        } catch {
            print(error)
        }
    }
    
    func didReceivePosition(notification: NSNotification) {
        if let userInfo = notification.userInfo as! [String: Any]?
        {
            if let peerID = userInfo["peerID"] as? MCPeerID, let data = userInfo["data"] as? Data {
                let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSDictionary
                if let type = dict["type"] as? String, let position = dict["position"] as? CGFloat {
                    if type == "pong" {
                        if position == 0.0 {
                            startGame(isFirstPlayer: false)
                        } else {
                            enemy.run(SKAction.moveTo(x: position, duration: 0))
                        }
                    }
                    friendNameLabel.text = peerID.displayName
                }
            }
            
        }
    }
    
}

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
    var firstPlayer = true
    
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
//            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
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
        if firstPlayer {
            firstPlayer = false
            sendData(type: "pong", position: 0)
            startGame(isFirstPlayer: true)
        }
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.1))
            sendData(type: "main", position: location.x)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.1))
            sendData(type: "main", position: location.x)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // my area
        if firstPlayer {
            print("sent")
            sendData(type: "ball", position: ball.position)
        }
//        if ball.position.y <= main.position.y || ball.position.y >= enemy.position.y {
//            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
//            main.size.width -= 1
//        }
        
        if ball.position.y <= main.position.y - 30 {
            addScore(playerWhoWon: enemy)
        }
            
        else if ball.position.y >= enemy.position.y + 30 {
            addScore(playerWhoWon: main)
        }
    }
    
    // send position to other player
    func sendData(type: String, position: Any) {
        let dict: NSDictionary = [
            "type": type,
            "position": position
        ]
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        do {
            try appDelegate.mcManager.session.send(data as Data, toPeers: appDelegate.mcManager.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch {
            print(error)
        }
    }
    
    func didReceivePosition(notification: NSNotification) {
        if let userInfo = notification.userInfo as! [String: Any]?
        {
            if let peerID = userInfo["peerID"] as? MCPeerID, let data = userInfo["data"] as? Data {
                let dict = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSDictionary
                if let type = dict["type"] as? String {
                    if type == "pong" {
                        firstPlayer = false
                        startGame(isFirstPlayer: false)
                    }
                    else if type == "ball" && !firstPlayer {
                        print("received")
                        if let position = dict["position"] as? CGPoint {
                            ball.run(SKAction.move(to: position, duration: 0))
                        }
                    } else if let position = dict["position"] as? CGFloat {
                        if type == "main" {
                            enemy.run(SKAction.moveTo(x: position, duration: 0))
                        } else if type == "enemy" {
                            main.run(SKAction.moveTo(x: position, duration: 0))
                        }
                    }
                    friendNameLabel.text = peerID.displayName
                }
            }
            
        }
    }
    
}

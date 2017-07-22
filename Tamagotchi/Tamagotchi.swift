//
//  Tamagotchi.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 21..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit

class Tamagotchi {
    private let MAXVALUE = 100
    private let MINVALUE = 0
    
    // 처음 정해지는 것
    private var name: String        // 이름 (1글자 이상)
    private var gender: String      // 성별 [♀ or ♂]
    private var button: UIButton
    
    // 보여지는 상태
    public var age: Int             // 나이 (0살 시작, 알에서 태어나면 1살로 설정하자)
    public var hunger: Int          // 배고픔 (0~100) 최대치에 가까울수록 배고픔
    public var cleanliness: Int     // 청결도 (0~100) 최대치에 가까울수록 청결함
    public var closeness: Int       // 친밀도 (0부터 시작) 무한정 높아짐
    
    // 보여지지 않는 상태
    public var health: Int          // 건강 (0~100) 최대치에 가까울수록 건강함
    public var sleepiness: Int      // 졸린 정도 (0~100) 최대치에 가까울수록 졸림!!
    public var isDoing: Bool       // 무언가 하고있는지 (true/flase) 하고 있을 경우 다른 작업 못함
    public var isSelected: Bool     // 현재 선택되었는지
    
    // 캐릭터 종류
    public var species: String      // 캐릭터 종류(사진 정보를 위해서) ["baby"]   계속 추가해야함
    
    // 움직임 상태 타이머
    public var moveTimer: Timer?
    public var isDoingTimer: Timer?
    
    init?(name: String, gender: String, button: UIButton, age: Int = 0, hunger: Int = 0, cleanliness: Int = 0, closeness: Int = 0, health: Int = 0, sleepiness: Int = 0, species: String = "baby", isDoing: Bool = false, isSelected: Bool = false) {
        if (name == "") { // 한 글자 이상
            return nil
        }
        self.name = name
        self.gender = gender
        self.button = button
        self.age = age
        self.hunger = hunger
        self.cleanliness = cleanliness
        self.closeness = closeness
        self.health = health
        self.sleepiness = sleepiness
        self.species = species
        self.button.setImage(UIImage(named: self.species + "default0"), for: UIControlState.normal)
        self.isDoing = isDoing
        self.isSelected = isSelected
    }
    
    public func getInfo() -> [String] {
        return [self.name + self.gender, String(self.age), String(self.hunger), String(self.cleanliness), String(self.closeness)]
    }
    
    public func setBackground() {
        if self.isSelected == true {
            self.button.setBackgroundImage(UIImage(named: "select"), for: UIControlState.normal)
        }else {
            self.button.setBackgroundImage(UIImage(), for: UIControlState.normal)
        }
    }

    public func getData() -> [String:Any] {
        return ["name": self.name, "gender": self.gender, "age": self.age, "hunger": self.hunger, "cleanliness": self.cleanliness, "closeness": self.closeness, "health": self.health, "sleepiness": self.sleepiness, "species": self.species]
    }
        
    public func animationStart(action: String, view1: UIView, view2: UIView) {
        self.isDoing = true
        view1.alpha = 0.6
        view2.alpha = 0.6
        
        var imageListArray: [UIImage] = []
        
        for i in 0..<2 {
            let image = UIImage(named: self.species + action + String(i))
            imageListArray.append(image!)
        }
        
        self.button.imageView?.animationImages = imageListArray
        self.button.imageView?.animationDuration = 1.0
        self.button.imageView?.animationRepeatCount = 3
        self.button.imageView?.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8, execute: {
            self.isDoing = false
            if (self.isSelected == true){
                view1.alpha = 1
                view2.alpha = 1
            }
        })
    }
    

    @objc func tamagotchiMoveRandomly() {
        // moving distance
        let movement:CGFloat = 10.0
        
        // set moving animation
        UIView.animate(withDuration: 0, animations: { () -> Void in
            self.button.frame.origin.x += movement
            self.button.frame.origin.y += movement
        })
    }
    
    @objc func makeItMove() {
        if (self.moveTimer == nil) && !(self.isDoing) {
            self.moveTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(tamagotchiMoveRandomly), userInfo: nil, repeats: true)
        }
    }
    
    func startMove() {
        self.moveTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(tamagotchiMoveRandomly), userInfo: nil, repeats: true)
        self.isDoingTimer = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(makeItMove), userInfo: nil, repeats: true)
    }
    
    func stopMove() {
        self.moveTimer?.invalidate()
        self.moveTimer = nil
        
    }


    public func updateAge(delta: Int) {
        self.age = self.age + delta
    }
    
    public func updateHunger(delta: Int) {
        self.hunger = self.hunger + delta
        if self.hunger > MAXVALUE {
            self.hunger = MAXVALUE
        } else if self.hunger < MINVALUE {
            self.hunger = MINVALUE
        }
    }
    
    public func updateCleanliness(delta: Int) {
        self.cleanliness = self.cleanliness + delta
        if self.cleanliness > MAXVALUE {
            self.cleanliness = MAXVALUE
        } else if self.cleanliness < MINVALUE {
            self.cleanliness = MINVALUE
        }
    }
    
    public func updateCloseness(delta: Int) {
        self.closeness = self.closeness + delta
        if self.closeness < MINVALUE {
            self.closeness = MINVALUE
        }
    }
    
    public func updateHealth(delta: Int) {
        self.health = self.health + delta
        if self.health > MAXVALUE {
            self.health = MAXVALUE
        } else if self.health < MINVALUE {
            self.health = MINVALUE
        }
    }
    
    public func updateSleepiness(delta: Int) {
        self.sleepiness = self.sleepiness + delta
        if self.sleepiness > MAXVALUE {
            self.sleepiness = MAXVALUE
        } else if self.sleepiness < MINVALUE {
            self.sleepiness = MINVALUE
        }
    }

}

//
//  HomeViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 20..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HomeViewController: UIViewController, MCBrowserViewControllerDelegate {
    var appDelegate : AppDelegate!

    var statusTimer: Timer!
    var dungTimer: Timer!
    var count = 0
    var dungImage = UIImage(named: "dung")
    var dungList: [UIImageView] = []
    let dungMakeTime: Float = 20

    @IBOutlet weak var connectedFriendLabel: UILabel!
    
    @IBAction func inviteFriend(_ sender: Any) {
        appDelegate.mcManager.setupMCBrowser()
        appDelegate.mcManager.browser.delegate = self
        self.present(appDelegate.mcManager.browser, animated: true, completion: nil)
    }
    
    //전체 펫 View
    @IBOutlet weak var petView: UIView!
    
    //button list view
    @IBOutlet weak var buttonListView1: UIView!
    @IBOutlet weak var buttonListView2: UIView!
    
    //tamacotchi buttons
    @IBOutlet weak var tamaButton1: UIButton!
    @IBOutlet weak var tamaButton2: UIButton!
    @IBOutlet weak var tamaButton3: UIButton!
    @IBOutlet weak var tamaButton4: UIButton!
    @IBOutlet weak var tamaButton5: UIButton!
    
    // touch interaction을 위해 몇 번 눌렸는지 check할 값. 5초에 0으로 초기화됨
    public let touchInteractionCount: Int = 4   // 5초 안에 몇 번 눌러야할지 설정한 값
    public var tamaButton1TouchCount: Int = 0
    public var tamaButton2TouchCount: Int = 0
    public var tamaButton3TouchCount: Int = 0
    public var tamaButton4TouchCount: Int = 0
    public var tamaButton5TouchCount: Int = 0
    
    //status Lables
    @IBOutlet weak var nameT: UILabel!
    @IBOutlet weak var ageT: UILabel!
    @IBOutlet weak var hungerT: UILabel!
    @IBOutlet weak var cleanlinessT: UILabel!
    @IBOutlet weak var closenessT: UILabel!
    var statusLabels: [UILabel]?
    
    //Progress bars
    @IBOutlet weak var ageP: UIProgressView!
    @IBOutlet weak var hungerP: UIProgressView!
    @IBOutlet weak var cleanlinessP: UIProgressView!
    var statusProgs: [UIProgressView]?

    //status view
    @IBOutlet weak var statusView: UIView!
    
    //index view
    @IBOutlet weak var indexView: UIView!
    @IBOutlet weak var indexCollectionView: UICollectionView!
    var indexImage: [String] = []
    var indexName: [String] = []
    let itemsPerRow: CGFloat = 3
    
    //Index of pet
    let tamaIndex = ["baby": false, "pet1": true, "pet2": false, "pet3": false, "pet4": true, "pet5": false, "pet6": true]
    
    // tamagotchi inforamtion
    var tamaInfo: [String] = ["", "0", "0", "0", "0"]
    
    
    // food and play ellement array (have to change)
    public let foodEllement = ["쌀밥":1, "잡곡밥":2, "건강식":10]
    public let playEllement = ["공놀이":1, "그네태우기":2, "부메랑물어오기":10]
    
    
    //Tamagotchi
    var tama1: Tamagotchi?
    var tama2: Tamagotchi?
    var tama3: Tamagotchi?
    var tama4: Tamagotchi?
    var tama5: Tamagotchi?
    var selectedTama: Tamagotchi?
    var tamas: [Tamagotchi?] = []
    
    //Max status
    let maxValue: Float = 100
    
    public let dataFileName: String = "Tamagotchi.json"

    
    /*** Do any additional setup after loading the view. ***/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.appDelegate.mcManager.setupPeerAndSessionWithDisplayName(name: UIDevice.current.name)
        self.appDelegate.mcManager.advertiseMyself(shouldAdvertise: true)

        loadSampleTamagotchiData()
        statusLabels = [nameT, ageT, hungerT, cleanlinessT, closenessT]
        statusProgs = [ageP, hungerP, cleanlinessP]
        //필요해서 만들었어요! 고쳐주세요
//        tamas = [tama1!, tama2!, tama3!]
        allTamagotchiMoveRandomly()

        for i in 0..<tamas.count {
            AutomaticStatusChange(tama: tamas[i]!)
        }
        AutomaticMakeDung()
//        loadTamagotchiData()
        
    }
    
//     load Sample Tamagotchi data
    func loadSampleTamagotchiData() {
        tama1 = Tamagotchi(name: "tama", gender: "♂", button: tamaButton1)
        tama2 = Tamagotchi(name: "tata", gender: "♀", button: tamaButton2)
        tama3 = Tamagotchi(name: "tata", gender: "♀", button: tamaButton3)

        //tama3, tama4, tama5
        
        appendNotNilTamagotchiIntoTamas()
    }
 
    
    func appendNotNilTamagotchiIntoTamas() {
        if (tama1 != nil) {
            tamas.append(tama1!)
        }
        if (tama2 != nil) {
            tamas.append(tama2!)
        }
        if (tama3 != nil) {
            tamas.append(tama3!)
        }
        if (tama4 != nil) {
            tamas.append(tama4!)
        }
        if (tama5 != nil) {
            tamas.append(tama5!)
        }
    }

    
    // save tamagotchi data into local json data file
    func saveTamagotchiData() {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentDirectoryUrl.appendingPathComponent(dataFileName)
        
        var tamagotchiArray: [Any] = []
        
        tamagotchiArray.append(["Dung":dungList.count])
        if (tama1 != nil) {
            tamagotchiArray.append(tama1!.getData())
        }
        if (tama2 != nil) {
            tamagotchiArray.append(tama2!.getData())
        }
        if (tama3 != nil) {
            tamagotchiArray.append(tama3!.getData())
        }
        if (tama4 != nil) {
            tamagotchiArray.append(tama4!.getData())
        }
        if (tama5 != nil) {
            tamagotchiArray.append(tama5!.getData())
        }
        
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: tamagotchiArray, options: [])
            try data.write(to: fileUrl, options: [])
            print("saveTamagotchiData finish")
        } catch {
            print(error)
        }
    }
    
    
    // load tamagotchi data into local json data file
    func loadTamagotchiData() {
        // Get the url of Persons.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent(dataFileName)
        
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let tamagotchiArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else { return }
            
            for item in tamagotchiArray {
                print(item)
                // check dung count and paint them all
                if let dungCount = item["Dung"] {
                    for _ in 0..<(dungCount as! Int) {
                        let randomSize = arc4random_uniform(15) + 30
                        let randomX = arc4random_uniform(300)
                        let randomY = arc4random_uniform(250)
                        
                        let dungImageView = UIImageView(frame: self.CGRectMake(CGFloat(randomX), CGFloat(randomY), CGFloat(randomSize), CGFloat(randomSize)))
                        dungImageView.image = self.dungImage!
                        dungImageView.backgroundColor = UIColor.clear
                        
                        self.dungList.append(dungImageView)
                        self.petView.addSubview(dungImageView)
                        self.petView.sendSubview(toBack: dungImageView)
                    }
                    continue
                }
                if (tama1 == nil) {
                    tama1 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton1, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
                else if (tama2 == nil) {
                    tama2 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton2, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
                else if (tama3 == nil) {
                    tama3 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton3, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
                else if (tama4 == nil) {
                    tama4 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton4, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
                else if (tama5 == nil) {
                    tama5 = Tamagotchi(name: item["name"] as! String, gender: item["gender"] as! String, button: tamaButton5, age: item["age"] as! Int, hunger: item["hunger"] as! Int, cleanliness: item["cleanliness"] as! Int, closeness: item["closeness"] as! Int, health: item["health"] as! Int, sleepiness: item["sleepiness"] as! Int, species: item["species"] as! String, isDoing: false)
                }
            }
            
        } catch {
            print(error)
            // if first app loading, there will be not dataFile
            // so have to make a baby tama random name and gender, and save the data
            
            // have to change here
            tama1 = Tamagotchi(name: "tama", gender: "♂", button: tamaButton1)
            saveTamagotchiData()
        }
        
        appendNotNilTamagotchiIntoTamas()
    }
    
    
    // make all tamagotchi movement randomly
    func allTamagotchiStopMove() {
        if (tama1 != nil) {
            tama1!.stopMove()
        }
        if (tama2 != nil) {
            tama2!.stopMove()
        }
        if (tama3 != nil) {
            tama3!.stopMove()
        }
        if (tama4 != nil) {
            tama4!.stopMove()
        }
        if (tama5 != nil) {
            tama5!.stopMove()
        }
        
    }
    // make all tamagotchi movement randomly
    func allTamagotchiMoveRandomly() {
        if (tama1 != nil) {
            tama1!.startMove()
        }
        if (tama2 != nil) {
            tama2!.startMove()
        }
        if (tama3 != nil) {
            tama3!.startMove()
        }
        if (tama4 != nil) {
            tama4!.startMove()
        }
        if (tama5 != nil) {
            tama5!.startMove()
        }

    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    /***  Change status as the time passed  ***/
    func AutomaticStatusChange (tama: Tamagotchi){
        statusTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {_ in
            tama.updateAge(delta: 1)
            tama.updateHunger(delta: 1)
            tama.updateCleanliness(delta: -1)
            tama.updateCloseness(delta: -1)
        })
    }
    
    func AutomaticMakeDung () {
        dungTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(dungMakeTime / Float(tamas.count)), repeats: true, block: {_ in
            let randomSize = arc4random_uniform(15) + 30
            let randomX = arc4random_uniform(300)
            let randomY = arc4random_uniform(250)
            
            let dungImageView = UIImageView(frame: self.CGRectMake(CGFloat(randomX), CGFloat(randomY), CGFloat(randomSize), CGFloat(randomSize)))
            dungImageView.image = self.dungImage!
            dungImageView.backgroundColor = UIColor.clear
            
            self.dungList.append(dungImageView)
            self.petView.addSubview(dungImageView)
            self.petView.sendSubview(toBack: dungImageView)
        })
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    /***  Functions for click tamagotchi  ***/
    @IBAction func clickTama1(_ sender: UIButton) {
        if let tama = tama1 {
            clickTamaButton(tama: tama)
        }
    }
    @IBAction func clickTama2(_ sender: UIButton) {
        if let tama = tama2 {
            clickTamaButton(tama: tama)
        }
    }
    @IBAction func clickTama3(_ sender: UIButton) {
        if let tama = tama3 {
            clickTamaButton(tama: tama)
        }
    }
    @IBAction func clickTama4(_ sender: UIButton) {
        if let tama = tama4 {
            clickTamaButton(tama: tama)
        }
    }
    @IBAction func clickTama5(_ sender: UIButton) {
        if let tama = tama5 {
            clickTamaButton(tama: tama)
        }
    }
    
    @IBAction func clickOffTama(_ sender: UIButton) {
        tamaButtonReset()
        if (selectedTama != nil) {
            selectedTama!.startMove()
        }
        
        selectedTama = nil
    }
    
    func clickTamaButton(tama: Tamagotchi) {
        selectedTama = tama
        tamaButtonReset()
        selectedTama!.isSelected = true
        selectedTama!.setBackground()
        if tama.isDoing == false {
            buttonListView1.alpha = 1
            buttonListView2.alpha = 1
        }else {
            buttonListView1.alpha = 0.6
            buttonListView2.alpha = 0.6
        }
        selectedTama!.pauseMove()
    }
    
    func tamaButtonReset() {
        for i in 0..<tamas.count {
            tamas[i]!.isSelected = false
            tamas[i]!.setBackground()
        }
    }
    
    
    /***  Functions for Action Buttons  ***/
    
    @IBAction func eatAction(_ sender: UIButton) {
        if let tama = selectedTama, !tama.isDoing {
            // popup view 선언
            let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListPopUpView") as! ListPopUpViewController
            
            // set PopUpView element
            popUpView.showEllement = self.foodEllement
            popUpView.tama = tama
            popUpView.buttonListView1 = buttonListView1
            popUpView.buttonListView2 = buttonListView2
            
            // eat action
            popUpView.action = "eat"
            
            // appear PopUp
            self.addChildViewController(popUpView)
            popUpView.view.frame = self.view.frame
            self.view.addSubview(popUpView.view)
        }
    }
    
    @IBAction func playAction(_ sender: UIButton) {
        if let tama = selectedTama, (!tama.isDoing) {
            // popup view 선언
            let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListPopUpView") as! ListPopUpViewController
            
            // set PopUpView element
            popUpView.showEllement = self.playEllement
            popUpView.tama = tama
            popUpView.buttonListView1 = buttonListView1
            popUpView.buttonListView2 = buttonListView2
            
            // play action
            popUpView.action = "play"
            
            // appear PopUp
            self.addChildViewController(popUpView)
            popUpView.view.frame = self.view.frame
            self.view.addSubview(popUpView.view)
        }
    }

    @IBAction func washAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            // have to insert status change function
            tama.updateCleanliness(delta: 10)
            
            // change image looks like animation
            tama.animationStart(action: "wash", view1: buttonListView1, view2: buttonListView2)
        }
    }
    
    @IBAction func cleanAction(_ sender: UIButton) {
        for i in 0..<dungList.count {
            dungList[i].removeFromSuperview()
        }
    }
    
    @IBAction func sleepAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            if (tama.sleepiness > 90) { // tama wants to sleep
                
                // change image looks like animation
                tama.animationStart(action: "sleep", view1: buttonListView1, view2: buttonListView2)
            } else {
                // 안졸리다는 action popup view 선언
                let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoticePopUpView") as! NoticePopUpViewController
                
                // clean animation
                popUpView.animation = "sayno"
                popUpView.species = tama.species
                
                // appear PopUp
                self.addChildViewController(popUpView)
                popUpView.view.frame = self.view.frame
                self.view.addSubview(popUpView.view)

            }
        }
    }
    
    @IBAction func cureAction(_ sender: UIButton) {
        if let tama = selectedTama, !(tama.isDoing) {
            if (tama.health < 20) {
                // have to insert status change function
                tama.updateHealth(delta: 50)
                
                // change image looks like animation
                tama.animationStart(action: "wash", view1: buttonListView1, view2: buttonListView2)
            } else {
                // 안아프다는 action popup view 선언
                let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NoticePopUpView") as! NoticePopUpViewController
                
                // clean animation
                popUpView.animation = "sayno"
                popUpView.species = tama.species
                
                // appear PopUp
                self.addChildViewController(popUpView)
                popUpView.view.frame = self.view.frame
                self.view.addSubview(popUpView.view)
            }
            
        }
    }
    
    
    
    
    /*** function for status view ***/
    @IBAction func statusView(_ sender: UIButton) {
        if let tama = selectedTama {
            //view status
            tamaInfo = tama.getInfo()
            for i in 0..<tamaInfo.count{
                statusLabels?[i].text = tamaInfo[i]
                if (i-1 >= 0 && i-1 < 3){
                    if let value: Int = Int(tamaInfo[i]) {
                        statusProgs?[i-1].transform = CGAffineTransform(scaleX: 1, y: 4);
                        statusProgs?[i-1].progress = Float(value) / maxValue
                    }
                }
            }
            statusView.isHidden = false
        }
    }
    
    
    /*** functions for status view ***/
    @IBAction func statusCloseButton(_ sender: UIButton) {
        statusView.isHidden = true
    }
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController)  {
        // Called when the browser view controller is dismissed (ie the Done button was tapped)
        appDelegate.mcManager.browser.dismiss(animated: true, completion: nil)
        connectedFriendLabel.text = appDelegate.mcManager.session.connectedPeers.description
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        appDelegate.mcManager.browser.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    

}

//
//  LoveViewController.swift
//  Tamagotchi
//
//  Created by user on 2017. 7. 23..
//  Copyright © 2017년 user. All rights reserved.
//

import UIKit
import CoreBluetooth

class LoveViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var tamas = [Tamagotchi?]()
    var tamaImages: [String] = []
    var tamaNames: [String] = []
    var selectedTama: Tamagotchi!
    
    var itemsPerRow = 3
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectCollectionView: UICollectionView!
    
    
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    @IBOutlet weak var heart6: UIImageView!
    var heartList: [UIImageView?] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for tama in tamas{
            //tamaImages.append(tama.species + "gray")
            //tamaNames.apped(tama.name)
            tamaImages.append("babygray")
            tamaNames.append(tama!.name)
        }
        selectCollectionView.delegate = self
        selectCollectionView.dataSource = self
        
        heartList = [heart1, heart2, heart3, heart4, heart5, heart6]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func selectTama(_ sender: Any) {
        tamaImages = []
        for tama in tamas{
            if tama!.age > 10 {
                tamaImages.append("babydefault0")
                //indexImage.append(species+"default0")
            }else {
                tamaImages.append("babygray")
                //indexImage.append(species+"gray")
            }
        }
        selectCollectionView.reloadData()
        selectView.isHidden = false
    }
    
    @IBAction func selectCloseButton(_ sender: Any) {
        selectView.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tamas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell2", for: indexPath) as! CustomCell2
        cell.backgroundColor = UIColor.white
        cell.name.text = tamaNames[indexPath.row]
        cell.image.image = UIImage(named: tamaImages[indexPath.row])
        cell.image.frame = CGRectMake(10, 8, cell.frame.width - 10, cell.frame.width - 10)
        cell.name.frame = CGRectMake(0, cell.frame.width, cell.frame.width, 15)
        cell.name.font = UIFont.systemFont(ofSize: 10.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = 5 * (itemsPerRow + 1)
        let availableWidth = Int(selectCollectionView.frame.width) - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 20)
    }

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
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

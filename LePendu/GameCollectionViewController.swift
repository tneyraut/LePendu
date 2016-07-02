//
//  GameCollectionViewController.swift
//  LePendu
//
//  Created by Thomas Mac on 29/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import AudioToolbox

private let reuseIdentifier = "Cell"

class GameCollectionViewController: UICollectionViewController {

    internal var vie = 0
    
    internal var reponse = ""
    
    internal var endlessMod = false
    
    private let itemsArray: Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Vie : " + String(self.vie)
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.collectionView?.scrollEnabled = false
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let buttonProposeWord = UIBarButtonItem(title:"Proposition", style:UIBarButtonItemStyle.Done, target:self, action:#selector(self.buttonProposeWordActionListener))
        buttonProposeWord.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem = buttonProposeWord
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(CollectionViewCellWithLabel.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.registerClass(CollectionViewCellWithLabel.self, forCellWithReuseIdentifier:"alphabetCell")
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:"otherCell")

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated:true)
        
        super.viewDidAppear(animated)
    }
    
    internal func getRandomWord() -> String
    {
        return NSLocalizedString("WORD_" + String(arc4random_uniform(20)), comment:"")
    }
    
    @objc func buttonProposeWordActionListener()
    {
        let alertController = UIAlertController(title:"Proposition d'un mot", message:"Veuillez rentrer le mot que vous souhaitez", preferredStyle:.Alert)
        
        alertController.addTextFieldWithConfigurationHandler{ (textField) in
            textField.placeholder = "Rentrez votre proposition"
        }
        
        let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in
            let propositionTextField = alertController.textFields![0] as UITextField
            if (propositionTextField.text?.lowercaseString == self.reponse.lowercaseString)
            {
                self.victoire()
            }
            else
            {
                self.pertePointVie()
            }
        }
        
        let cancelAction = UIAlertAction(title:"Annuler", style:.Default) { (_) in }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated:true, completion:nil)
    }
    
    private func characterIsInWord(character: String)
    {
        if (self.discoverCellsWithTitle(character))
        {
            if (self.allCellsAreDiscovered())
            {
                self.victoire()
            }
        }
        else
        {
            self.pertePointVie()
        }
    }
    
    private func victoire()
    {
        let alertController = UIAlertController(title:"Victoire", message:"Félicitation, vous avez trouvé le mot : " + self.reponse, preferredStyle:.Alert)
        let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in
            if (self.endlessMod)
            {
                self.vie += 1
                self.title = "Vie : " + String(self.vie)
                self.reponse = self.getRandomWord()
                self.collectionView?.reloadData()
            }
            else
            {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated:true, completion:nil)
    }
    
    private func pertePointVie()
    {
        self.vie -= 1
        self.title = "Vie : " + String(self.vie)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        if (self.vie < 0)
        {
            let alertController = UIAlertController(title:"Défaite", message:"Vous avez fait trop de fautes, le mot était : " + self.reponse, preferredStyle:.Alert)
            let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in self.navigationController?.popViewControllerAnimated(true) }
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated:true, completion:nil)
        }
    }
    
    private func stringIsCharacter(string: String) -> Bool
    {
        
        let charactersArray = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var i = 0
        while (i < charactersArray.count)
        {
            if (string.lowercaseString == charactersArray[i] || self.getCharacterWithoutAccent(string).lowercaseString == charactersArray[i])
            {
                return true
            }
            i += 1
        }
        return false
    }
    
    private func getCharacterWithoutAccent(character: String) -> String
    {
        switch character {
        case "â":
            return "a"
        case "é":
            return "e"
        case "è":
            return "e"
        case "ê":
            return "e"
        case "î":
            return "i"
        case "ô":
            return "o"
        case "û":
            return "u"
        case "ù":
            return "u"
        case "à":
            return "a"
        case "ì":
            return "i"
        case "ò":
            return "o"
        default:
            return character
        }
    }
    
    private func discoverCellsWithTitle(title: String) -> Bool
    {
        var done = false
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel
            if (self.getCharacterWithoutAccent(cell.titleLabel.text!).lowercaseString == title.lowercaseString)
            {
                cell.titleLabel.hidden = false
                done = true
            }
            i += 1
        }
        return done
    }
    
    private func allCellsAreDiscovered() -> Bool
    {
        var i = 0
        while (i < self.collectionView?.numberOfItemsInSection(0))
        {
            if ((self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! CollectionViewCellWithLabel).titleLabel.hidden)
            {
                return false
            }
            i += 1
        }
        return true
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if (section == 0)
        {
            return self.reponse.characters.count
        }
        return self.itemsArray.count + 2
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        if (indexPath.section == 0)
        {
            return CGSizeMake(self.collectionView!.frame.size.width / CGFloat(self.reponse.characters.count), 75.0)
        }
        return CGSizeMake(self.collectionView!.frame.size.width / 5, (self.collectionView!.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - 100.0) / 6)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0)
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCellWithLabel
        
            var i = 0
            for character in self.reponse.characters
            {
                if (i == indexPath.row)
                {
                    cell.titleLabel.text = String(character)
                    break
                }
                i += 1
            }
            if (!self.stringIsCharacter(cell.titleLabel.text!))
            {
                cell.titleLabel.hidden = false
            }
            else
            {
                cell.titleLabel.hidden = true
            }
        
            var size = cell.frame.size.width
            if (size > cell.frame.size.height)
            {
                size = cell.frame.size.height
            }
            cell.titleLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:size)
            
            return cell
        }
        
        if (indexPath.row == 25 || indexPath.row == 26)
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("otherCell", forIndexPath: indexPath)
            
            cell.backgroundColor = UIColor.whiteColor()
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("alphabetCell", forIndexPath: indexPath) as! CollectionViewCellWithLabel
        
        var size = cell.frame.size.width
        if (size > cell.frame.size.height)
        {
            size = cell.frame.size.height
        }
        cell.titleLabel.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:size/4)
        
        cell.titleLabel.hidden = false
        
        if (indexPath.row == 27)
        {
            cell.titleLabel.text = String(self.itemsArray[self.itemsArray.count - 1])
        }
        else
        {
            cell.titleLabel.text = String(self.itemsArray[indexPath.row])
        }
        cell.backgroundColor = UIColor.blackColor()
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if (cell?.backgroundColor == UIColor.whiteColor() || indexPath.section == 0)
        {
            return
        }
        cell?.backgroundColor = UIColor.whiteColor()
        self.characterIsInWord((cell as! CollectionViewCellWithLabel).titleLabel.text!)
    }

}

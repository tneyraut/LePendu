//
//  AccueilTableViewController.swift
//  LePendu
//
//  Created by Thomas Mac on 27/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class AccueilTableViewController: UITableViewController {
    
    private var vie = 10
    
    private let itemsArray: NSArray = ["Nombre de vie : ", "Random word : ", "Endless mod : "]
    
    private let imagesArray: NSArray = [NSLocalizedString("ICON_VIE", comment:""), NSLocalizedString("ICON_RANDOM_WORD", comment:""), NSLocalizedString("ICON_ENDLESS", comment:"")]
    
    private var randomWord = true
    
    private var endlessMod = false
    
    private let sauvegarde = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerClass(TableViewCellWithStepper.classForCoder(), forCellReuseIdentifier:"cellStepper")
        self.tableView.registerClass(TableViewCellTextField.classForCoder(), forCellReuseIdentifier:"cellTextField")
        self.tableView.registerClass(TableViewCellWithSwitch.classForCoder(), forCellReuseIdentifier:"cellSwitch")
        
        self.title = "Le pendu : Menu Principal"
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let buttonPrevious = UIBarButtonItem(title:"Retour", style:UIBarButtonItemStyle.Done, target:nil, action:nil)
        buttonPrevious.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.backBarButtonItem = buttonPrevious
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated:true)
        
        self.navigationController?.toolbar.barTintColor = UIColor(red:0.439, green:0.776, blue:0.737, alpha:1)
        
        let shadow = NSShadow()
        
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let buttonPlay = UIBarButtonItem(title:"Play", style:.Plain, target:self, action:#selector(self.buttonPlayActionListener))
        
        buttonPlay.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:nil, action:nil)
        
        self.navigationController?.toolbar.setItems([flexibleSpace, buttonPlay, flexibleSpace], animated:true)
        
        if (self.endlessMod)
        {
            let scoreButton = UIBarButtonItem(title:"Score", style:.Plain, target:self, action:#selector(self.scoreButtonActionListener))
            scoreButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
            
            self.navigationController?.toolbar.setItems([flexibleSpace, scoreButton, flexibleSpace, buttonPlay, flexibleSpace], animated:true)
        }
        
        super.viewDidAppear(animated)
    }
    
    @objc private func buttonPlayActionListener()
    {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let gameCollectionViewController = GameCollectionViewController(collectionViewLayout:layout)
        
        gameCollectionViewController.vie = self.vie
        
        gameCollectionViewController.endlessMod = self.endlessMod
        
        if (self.randomWord)
        {
            gameCollectionViewController.reponse = gameCollectionViewController.getRandomWord()
        }
        else
        {
            gameCollectionViewController.reponse = self.getUserText()
        }
        self.navigationController?.pushViewController(gameCollectionViewController, animated:true)
    }
    
    @objc private func stepperVieActionListener(sender: UIStepper)
    {
        self.vie = Int(sender.value)
        self.tableView.reloadData()
    }
    
    @objc private func switchRandomWordActionListener(sender: UISwitch)
    {
        self.randomWord = sender.on
        if (!self.randomWord)
        {
            self.endlessMod = false
        }
        self.tableView.reloadData()
    }
    
    @objc private func switchEndlessModActionListener(sender: UISwitch)
    {
        self.endlessMod = sender.on
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let buttonPlay = UIBarButtonItem(title:"Play", style:.Plain, target:self, action:#selector(self.buttonPlayActionListener))
        buttonPlay.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:nil, action:nil)
        
        self.navigationController?.toolbar.setItems([flexibleSpace, buttonPlay, flexibleSpace], animated:true)
        
        if (self.endlessMod)
        {
            self.randomWord = true
            
            let scoreButton = UIBarButtonItem(title:"Score", style:.Plain, target:self, action:#selector(self.scoreButtonActionListener))
            scoreButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
            
            self.navigationController?.toolbar.setItems([flexibleSpace, scoreButton, flexibleSpace, buttonPlay, flexibleSpace], animated:true)
        }
        self.tableView.reloadData()
    }
    
    @objc private func scoreButtonActionListener()
    {
        let scoreTableViewController = ScoreTableViewController(style: .Plain)
        
        scoreTableViewController.sauvegarde = self.sauvegarde
        
        scoreTableViewController.nombreDeVie = self.vie
        
        self.navigationController?.pushViewController(scoreTableViewController, animated:true)
    }
    
    private func getUserText() -> String
    {
        let text = (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow:2, inSection:0)) as! TableViewCellTextField).textField.text!
        
        var resultat = ""
        var ok = false
        for character in text.characters
        {
            if (ok && character == " ")
            {
                break
            }
            else if (character != " ")
            {
                ok = true
                resultat = resultat + String(character)
            }
        }
        return resultat
    }
    
    internal func endlessGameIsFinished(nombreDeVieInitiale: Int, score: Int)
    {
        if (score < 1)
        {
            return
        }
        if (self.sauvegarde.integerForKey("numberOfScoresForN°" + String(nombreDeVieInitiale)) < 10)
        {
            self.sauvegarde.setInteger(self.sauvegarde.integerForKey("numberOfScoresForN°" + String(nombreDeVieInitiale)) + 1, forKey:"numberOfScoresForN°" + String(nombreDeVieInitiale))
        }
        if (self.sauvegarde.integerForKey("numberOfScoresForN°" + String(nombreDeVieInitiale)) == 1)
        {
            self.sauvegarde.setInteger(score, forKey:"scoreN°0ForN°" + String(nombreDeVieInitiale))
            self.sauvegarde.synchronize()
            return
        }
        
        var i = 0
        while (i < self.sauvegarde.integerForKey("numberOfScoresForN°" + String(nombreDeVieInitiale)))
        {
            if (self.sauvegarde.integerForKey("scoreN°" + String(i) + "ForN°" + String(nombreDeVieInitiale)) < score)
            {
                var j = self.sauvegarde.integerForKey("numberOfScoresForN°" + String(nombreDeVieInitiale)) - 1
                while (j > i)
                {
                    self.sauvegarde.setInteger(self.sauvegarde.integerForKey("scoreN°" + String(j - 1) + "ForN°" + String(nombreDeVieInitiale)), forKey:"scoreN°" + String(j) + "ForN°" + String(nombreDeVieInitiale))
                    j -= 1
                }
                self.sauvegarde.setInteger(score, forKey:"scoreN°" + String(i) + "ForN°" + String(nombreDeVieInitiale))
                self.sauvegarde.synchronize()
                break
            }
            i += 1
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (!self.randomWord)
        {
            return self.itemsArray.count + 1
        }
        return self.itemsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cellStepper", forIndexPath: indexPath) as! TableViewCellWithStepper
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.text = String(self.itemsArray[indexPath.row]) + String(self.vie)
            
            cell.textLabel?.numberOfLines = 0
            
            cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            cell.stepper.addTarget(self, action:#selector(self.stepperVieActionListener(_:)), forControlEvents:UIControlEvents.TouchUpInside)
            
            cell.stepper.value = Double(self.vie)
            
            cell.stepper.minimumValue = 0
            
            cell.stepper.maximumValue = 100
            
            cell.imageView?.image = UIImage(named:String(self.imagesArray[indexPath.row]))
            
            return cell
        }
        else if (indexPath.row == 1 || indexPath.row == 2)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cellSwitch", forIndexPath: indexPath) as! TableViewCellWithSwitch
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.numberOfLines = 0
            
            cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            if (indexPath.row == 1)
            {
                cell.switchObject.on = self.randomWord
                
                cell.textLabel?.text = String(self.itemsArray[indexPath.row]) + String(self.randomWord)
                
                cell.switchObject.addTarget(self, action:#selector(self.switchRandomWordActionListener(_:)), forControlEvents:.TouchUpInside)
            }
            else
            {
                cell.switchObject.on = self.endlessMod
                
                cell.textLabel?.text = String(self.itemsArray[indexPath.row]) + String(self.endlessMod)
                
                cell.switchObject.addTarget(self, action:#selector(self.switchEndlessModActionListener(_:)), forControlEvents:.TouchUpInside)
            }
            cell.imageView?.image = UIImage(named:String(self.imagesArray[indexPath.row]))
            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cellTextField", forIndexPath: indexPath) as! TableViewCellTextField

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.textField.placeholder = "votre mot à faire deviner..."
        
        cell.imageView?.image = UIImage(named:NSLocalizedString("ICON_TEXT", comment:""))
        
        return cell
    }
    
}

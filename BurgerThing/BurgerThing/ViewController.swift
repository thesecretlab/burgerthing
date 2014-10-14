//
//  ViewController.swift
//  BurgerThing
//
//  Created by Timothy Rodney Nugent on 14/10/2014.
//  Copyright (c) 2014 Timothy Rodney Nugent. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    // The currently selected ingredient
    @IBOutlet weak var burgerItemLabel: UILabel!
    
    // The table view that we're showing burger ingredients in
    @IBOutlet weak var tableview: UITableView!

    // The index of the currently selected burger ingredient
    var currentBurgerItem : Int = 0
    
    // The current burger: an array of ingredients. Starts as an empty array.
    var currentBurgerIngredients : [String] = []
    
    //MARK: - View setup
    
    // Called when the view loads for the first time.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure that the current ingredient label says something useful
        self.updateBurgerItemLabel()
    }
    
    //MARK: - Ingredient selection

    // Select the previous ingredient
    @IBAction func previousItem(sender: AnyObject) {
        // move onto the previous item in the list of burger items
        self.currentBurgerItem--
        
        if self.currentBurgerItem < 0 {
            self.currentBurgerItem += BurgerHandler.sharedHandler.ingredientsList.count
        }
        
        self.updateBurgerItemLabel()
    }
    
    // Select the next ingredient
    @IBAction func nextItem(sender: AnyObject) {
        // move onto the next item in the list of burger items
        self.currentBurgerItem++
        self.currentBurgerItem = self.currentBurgerItem % BurgerHandler.sharedHandler.ingredientsList.count
        self.updateBurgerItemLabel()
    }
    
    // Update the main label so that it shows the name of the selected ingredient
    func updateBurgerItemLabel()
    {
        let currentIngredient = BurgerHandler.sharedHandler.ingredientsList[self.currentBurgerItem]
        
        self.burgerItemLabel.text = currentIngredient
    }
    
    //MARK: - Burger ordering
    
    // Add the selected ingredient
    @IBAction func addBurgerItem(sender: AnyObject) {
        // add the current burger Item into the array of burger Items
        
        let theIngredient = BurgerHandler.sharedHandler.ingredientsList[self.currentBurgerItem]
        
        self.currentBurgerIngredients.append(theIngredient)
        
        // update the tableview
        let indexPath = NSIndexPath(forRow: self.currentBurgerIngredients.endIndex - 1, inSection: 0)
        
        self.tableview.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    // Ask for a burger!
    @IBAction func orderBurger(sender: AnyObject) {
        
        BurgerHandler.sharedHandler.orderBurger(ingredients: self.currentBurgerIngredients) { (orderID, error) -> () in
            if let orderNumber = orderID
            {
                let alert = UIAlertController(title: "Burger Ordered", message: "You burger was successfully ordered! Your order number is \(orderNumber)", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else if error != nil
            {
                
                let failureReason = error!.localizedFailureReason!
                
                let alert = UIAlertController(title: "Order Failed", message: "Your order failed! \(failureReason)", preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "Bummer", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // User cancelled; do nothing
            }
        }
    
    }
    
    
    
    //MARK: - Table view data source methods
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.currentBurgerIngredients.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("burgerIngredientCell") as UITableViewCell
        
        cell.textLabel?.text = self.currentBurgerIngredients[indexPath.row]
        
        return cell
    }
    
    //MARK: - Table view delegate methods
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            // remove the item from the array
            self.currentBurgerIngredients.removeAtIndex(indexPath.row)
            
            // update the tableview
            self.tableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
        }
    }

}


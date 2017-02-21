//
//  MealController.swift
//  FoodTracker
//
//  Created by 李芮 on 17/2/20.
//  Copyright © 2017年 7feel. All rights reserved.
//

import UIKit

class MealListController: UITableViewController {

    //MARK:- Properties
    
    var meals = [Meal]()
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let saveMeals = loadMeals() {
            meals += saveMeals
        } else {
            loadSampleMeal()
        }
        
        
    }
    
    //MARK:- UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let reuserableIdentifier = "MealCell"
        guard let cell = tableView.dequeueReusableCellWithIdentifier(reuserableIdentifier, forIndexPath: indexPath) as? MealCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        
        return cell
    }
    
    //MARK:- UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            meals.removeAtIndex(indexPath.row)
            saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //MARK:- Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "AddItem":
                print("Adding a new meal.")
        case "ShowDetail":
            guard let mealDetailViewController = segue.destinationViewController as? MealEditViewController else {
                fatalError("Unexpected destination: \(segue.destinationViewController)")
            }
            
            guard let selectedMealCell = sender as? MealCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPathForCell(selectedMealCell) else {
                fatalError("The selected cell is  not being displayed by the table.")
            }
            
            let selectMeal = meals[indexPath.row]
            
            mealDetailViewController.meal = selectMeal
            
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
        
    }
    
    //MARK:- Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? MealEditViewController , meal = sourceViewController.meal{
            
            //indexPathForSelectedRow 判断是否选中tableView的某一行
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                let indexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            saveMeals()
        }
    }
    
    //MARK:- private Methods
    
    private func loadSampleMeal() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveUrl.path!)
        if isSuccessfulSave {
            print("Meals successfully saved.")
        } else {
            print("Failed to save meals...")
        }
        
    }
    
    private func loadMeals() -> [Meal]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveUrl.path!) as? [Meal]
    }
    
}


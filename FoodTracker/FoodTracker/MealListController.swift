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
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let saveMeals = loadMeals() {
            meals += saveMeals
        } else {
            loadSampleMeal()
        }
        
        
    }
    
    //MARK:- UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuserableIdentifier = "MealCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuserableIdentifier, for: indexPath) as? MealCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        
        return cell
    }
    
    //MARK:- UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "AddItem":
                print("Adding a new meal.")
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealEditViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is  not being displayed by the table.")
            }
            
            let selectMeal = meals[indexPath.row]
            
            mealDetailViewController.meal = selectMeal
            
        default:
            fatalError("Unexpected segue identifier: \(segue.identifier)")
        }
        
    }
    
    //MARK:- Actions
    
    @IBAction func unwindToMealList(_ sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MealEditViewController , let meal = sourceViewController.meal{
            
            //indexPathForSelectedRow 判断是否选中tableView的某一行
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let indexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            saveMeals()
        }
    }
    
    //MARK:- private Methods
    
    fileprivate func loadSampleMeal() {
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
    
    fileprivate func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveUrl.path)
        if isSuccessfulSave {
            print("Meals successfully saved.")
        } else {
            print("Failed to save meals...")
        }
        
    }
    
    fileprivate func loadMeals() -> [Meal]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveUrl.path) as? [Meal]
    }
    
}


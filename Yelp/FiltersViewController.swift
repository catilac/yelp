

//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Chirag Davé on 4/27/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol FiltersViewDelegate: class {
    func pressedCancel()
    func pressedSearch(filters: Dictionary<String, AnyObject>)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewDelegate?
    
    var menuOpen : Dictionary<String, Bool> = ["Category": false, "Radius": false, "Sort": false]
    var searchFilters : Dictionary<String, AnyObject> = [
        "Category": ["None", "scuba", "boxing", "yoga", "horseracing"],
        "Radius": ["Auto", "1.0", "1.5", "2.0", "2.5", "3.0", "3.5"],
        "Deals": false,
        "Sort": ["Best Match", "Distance", "Highest Rated"]
    ]
    var selectedFilters: Dictionary<String, AnyObject> = ["Category": "None", "Radius": "Auto", "Deals": false, "Sort": "Best Match"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedCancel(sender: AnyObject) {
        delegate?.pressedCancel()
    }
    
    @IBAction func pressedSearch(sender: AnyObject) {
        delegate?.pressedSearch(selectedFilters)
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(searchFilters.keys)
        let key = keys[section]
        
        if key == "Deals" {
            return 1
        }
        
        if menuOpen[key] == true {
            return searchFilters[key]!.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let keys = Array(selectedFilters.keys)
        let key = keys[indexPath.section]
        if keys[indexPath.section] == "Deals" {
            let cell = tableView.dequeueReusableCellWithIdentifier("BoolFilterCell") as! BoolFilterCell
            cell.boolSwitch.on = selectedFilters[key] as! Bool
            cell.textLabel?.text = "Deals"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell") as! UITableViewCell
            
            if menuOpen[key] == true {
                cell.textLabel?.text = searchFilters[key]![indexPath.row] as? String
            } else {
                cell.textLabel?.text = selectedFilters[key] as? String
            }
            
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searchFilters.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = Array(searchFilters.keys)
        return keys[section]
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let keys = Array(selectedFilters.keys)
        let key = keys[indexPath.section]
        
        if key == "Deals" {
            if selectedFilters[key] as! Bool {
                selectedFilters[key] = false
            } else {
                selectedFilters[key] = true
            }
        } else {
            if menuOpen[key] == true {
                // set value, and close menu
                selectedFilters[key] = searchFilters[key]![indexPath.row]
                menuOpen[key] = false
            } else {
                // Open the menu
                menuOpen[key] = true
            }
        }
        
        tableView.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

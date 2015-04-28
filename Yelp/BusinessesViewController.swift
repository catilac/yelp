//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    var businesses: [Business]! = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        
        search("Restaurants", options: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(searchTerm: String, options: Dictionary<String, AnyObject>?) {
        var categories = [String]()
        var sortOrder = YelpSortMode.Distance
        var deals = false
        var radius : Float? = nil
        
        if let options = options {
            let category = options["Category"] as! String
            if category != "None" {
                categories.append(category)
            }
            let deals = options["Deals"] as! Bool
            var sortOrder : YelpSortMode
            switch options["Sort"] as! String {
                case "Best Match":
                    sortOrder = YelpSortMode.BestMatched
                    break
                case "Distance":
                    sortOrder = YelpSortMode.Distance
                    break
                case "Highest Rated":
                    sortOrder = YelpSortMode.HighestRated
                    break
                default:
                    sortOrder = YelpSortMode.Distance
            }
            
        }
        
        Business.searchWithTerm(searchTerm, sort: sortOrder, categories: categories, deals: deals, radius: radius) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
        searchBar.endEditing(true)
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell") as! BusinessCell
        let business = businesses[indexPath.row]
        cell.setFields(business)
        return cell
    }
    
    // MARK: - UISearchBarDelegate methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        search(searchBar.text, options:nil)
    }
    
    // MARK: - FiltersViewDelegate
    func pressedCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pressedSearch(searchFilters: Dictionary<String, AnyObject>) {
        search("", options:searchFilters)
        self.dismissViewControllerAnimated(true, completion: nil)

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        let viewController = segue.destinationViewController as! FiltersViewController
        // Pass the selected object to the new view controller.
        viewController.delegate = self
    }

}

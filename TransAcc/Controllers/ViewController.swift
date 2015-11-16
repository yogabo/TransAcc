//
//  ViewController.swift
//  TransAcc
//
//  Created by Lubos Sytensky on 12/11/15.
//  Copyright © 2015 Lubos Sytensky. All rights reserved.
//

import UIKit

/// View controller showing list of available transparent account downloaded from CSAS
class ViewController: UITableViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var items = NSMutableArray()
    var ids = NSMutableArray()
    var accNumber :String?
    var accBalance :String?
    var accItem :Account?

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        tableView.backgroundView = UIImageView(image: UIImage(named: "blue"))
        activityIndicator.startAnimating()
        self.loadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.reloadData()
        navigationController?.navigationBar.alpha = 0.5
//        self.activityIndicator.stopAnimating()
    }
    
    //MARK: - Actions
    //MARK: - Private stuff
    
    /// Data source for collection and table view
    func loadData() {
        RestApiManager.sharedInstance.listOfAllAcc { (json: JSON) in
            for (key, subJson) in json {
                if let name: NSString = subJson["name"].string {
                    self.items.addObject(name)
                    self.ids.addObject(subJson["accNumber"].string!)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    /// Data controller view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell") as? CustomCell

        if(indexPath.item % 2 == 0){
            cell!.backgroundColor = UIColor.clearColor()
        }
        else {
            cell!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell!.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        
        cell!.textLabel?.textColor = UIColor.whiteColor()
        
        let results = self.items
        if results.count != 0 {
        
            let name = self.items[indexPath.row]
            cell!.textLabel?.text = (name as! NSString) as String
            cell!.accNum = (self.ids[indexPath.row] as! NSString) as String
            cell!.accName = (name as! NSString) as String
        }
        return cell!
    }

    ///Handle acount detail view data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailview"){
            let cell = sender as! CustomCell
            let detailview = segue.destinationViewController as! DetailViewController
            detailview.accNum = cell.accNum!
            self.accNumber = cell.accNum
        }
    }
    
    
      
    
    
    
    
}


//
//  TransViewController.swift
//  TransAcc
//
//  Created by Lubos Sytensky on 14/11/15.
//  Copyright © 2015 Lubos Sytensky. All rights reserved.
//

import UIKit

/// View controller showing transactions for selected transparent account downloaded from CSAS
class TransViewController: UITableViewController {

    var accNum:String?
    var items = NSMutableArray()
    var amount = NSMutableArray()

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
        tableView.backgroundView = UIImageView(image: UIImage(named: "deep"))

        loadTransData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.title = accNum
        super.viewDidAppear(animated)
        navigationController?.navigationBar.alpha = 0.5

    }
    
    /// Data source for collection and form table view
    func loadTransData(){      
        RestApiManager.sharedInstance.listOfTransaction(accNum!, onCompletion: { (json: JSON) in
            for (key, subJson) in json {
                
                if (key == "transactions"){
                    for (_, transJson) in subJson {
                      let transItem: TransItem = TransItem()
                        
                       if let transactionType = transJson["transactionType"].string {
                            transItem.transactionType = transactionType
                        }
                        if let amount = transJson["amount"]["value"].number {
                            self.amount.addObject(amount)
                            transItem.amount = amount.doubleValue
                        }
                        if let currency = transJson["amount"]["currency"].string {
                            transItem.currency = currency
                        }
                        self.items.addObject(transItem)
                    }}
                
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
     /// Data controller view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("transcell") as? CustomCell
        
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

            let transItem: TransItem = self.items[indexPath.row] as! TransItem
            let typeTrans = transItem.transactionType
            let amount = String.localizedStringWithFormat("%. 2f %@", (transItem.amount)!, "")

            let currency = transItem.currency
            
            cell!.textLabel?.text = amount + currency! + " - " + typeTrans!
        }
        return cell!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

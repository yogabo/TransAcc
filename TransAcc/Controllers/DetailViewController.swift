//
//  DetailViewController.swift
//  TransAcc
//
//  Created by Lubos Sytensky on 13/11/15.
//  Copyright © 2015 Lubos Sytensky. All rights reserved.
//

import UIKit

/// View controller showing account datail for selected transparent account downloaded from CSAS
class DetailViewController: UIViewController {

    @IBOutlet var accNumber: UILabel!
    @IBOutlet var accName: UILabel!
    @IBOutlet var accBalance: UILabel!
    @IBOutlet var accTransparencyFrom: UILabel!
    @IBOutlet var accTransparencyTo: UILabel!
    @IBOutlet var accBankNum: UILabel!
    @IBOutlet var accCurrency: UILabel!
    @IBOutlet var accActualizationDate: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var accNum:String?
    var accItem: Account?
    
     //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        self.loadDetailData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.alpha = 0.5
        self.title = accNum
        self.accNumber.text = accNum
        self.accName.text = self.accItem?.name
        //        self.accBalance.text = String(format:"%f", (self.accItem?.balance)!)
        self.accBalance.text = String.localizedStringWithFormat("%. 2f %@", (self.accItem?.balance)!, "")
        self.accTransparencyFrom.text = convertDateFormater((self.accItem?.transparencyFrom!)!, formatFrom:"yyyy-MM-dd", formatTo: "dd.MM. yyyy")
        self.accTransparencyTo.text = convertDateFormater((self.accItem?.transparencyTo!)!, formatFrom:"yyyy-MM-dd", formatTo: "dd.MM. yyyy")
        self.accCurrency.text = self.accItem?.currency
        self.accBankNum.text = self.accItem?.banknum
        self.accActualizationDate.text = convertDateFormater((self.accItem?.actualizationDate!)!, formatFrom:"yyyy-MM-dd'T'HH:mm:ss.SSSZ", formatTo: "dd.MM. yyyy HH:mm")
        self.activityIndicator.stopAnimating()
    }

    
    /// Data source for collection and form table view
    func loadDetailData(){
        
        let accItem: Account = Account()
        RestApiManager.sharedInstance.accDetail(accNum!, onCompletion: { (json: JSON) in
            if let name = json["name"].string {
                accItem.name = name
            }
            if let balance = json["balance"].number {
                let x:NSNumber = balance
//                let s:String = String(format:"%f", x.doubleValue)
                accItem.balance = x.doubleValue
            }
            if let currency = json["currency"].string {
                accItem.currency = currency
            }
            if let accBankCode = json["accBankCode"].string {
                accItem.banknum = accBankCode
            }
            if let transparencyFrom = json["transparencyFrom"].string {
                accItem.transparencyFrom = transparencyFrom
            }
            if let transparencyTo = json["transparencyTo"].string {
                accItem.transparencyTo = transparencyTo
            }
            if let actualizationDate = json["actualizationDate"].string {
                accItem.actualizationDate = actualizationDate
            }

            self.accItem = accItem
//            self.view.setNeedsDisplay()

        })
    }

    /// Data controller service method view
    func convertDateFormater(date: String, formatFrom: String, formatTo: String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatFrom //this my string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(date)
        dateFormatter.dateFormat = formatTo///this is my want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        return timeStamp
    }

    /// Prepare action for other releases
    @IBAction func transHist_click(sender: AnyObject) {
        print("_____transHist_click_________")
    }

    ///Handle transactions detail view data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "transview"){
//            let cell = sender as! CustomCell
            let transView = segue.destinationViewController as! TransViewController
            transView.accNum = self.accNum

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

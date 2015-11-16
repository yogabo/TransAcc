//
//  RestApiManager.swift
//  TransAcc
//
//  Created by Lubos Sytensky on 12/11/15.
//  Copyright © 2015 Lubos Sytensky. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

/// Service network communication class for download data operations
class RestApiManager: NSObject {
    
    static let sharedInstance = RestApiManager()
    ///test base Sandbox CSAS url
    // let baseURL = "https://api.csas.cz/sandbox/webapi/api/v1/transparentAccounts/"
    ///baseURL production CSAS url
    let baseURL = "https://www.csas.cz/webapi/api/v1/transparentAccounts/"
    let header:String  = "WEB-API-key"
    ///test apiKey Sandbox CSAS
    // let apiKey:String  = "38dfa1bb-6ec1-4453-bd7f-a8e31bf2596f"
    ///test production CSAS
    let apiKey:String  = "9fe868a3-8116-4ca5-befa-572d302a38e2"

    /// Service network
    func makeHTTPGetRequest(request: NSMutableURLRequest, onCompletion: ServiceResponse) {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        task.resume()
    }

    /// Service method for handle network - download transparent account list data
    func listOfAllAcc(onCompletion: (JSON) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL + "accounts/")!)
        request.addValue(apiKey, forHTTPHeaderField: header)
        makeHTTPGetRequest(request, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    /// Service method for handle network - download detail account  data
    func accDetail(accnum: String, onCompletion: (JSON) -> Void) {
            print("RestApiManager.accDetail \(accnum)")
            let request = NSMutableURLRequest(URL: NSURL(string: baseURL + "accounts/" + accnum)!)
            request.addValue(apiKey, forHTTPHeaderField: header)
            makeHTTPGetRequest(request, onCompletion: { json, err in
                onCompletion(json as JSON)
            })
        }
    
    /// Service method for handle network - download transactions via selected account
    func listOfTransaction(accnum: String, onCompletion: (JSON) -> Void) {
        print("RestApiManager.listOfTransaction \(accnum)")
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL + "transactions/" + accnum + "?page=0&size=25")!)
        request.addValue(apiKey, forHTTPHeaderField: header)
        makeHTTPGetRequest(request, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    
}
//
//  Database.swift
//  BeanCount
//
//  Created by Voltmeter Amperage on 8/21/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit

class Database: NSObject {
    
    let webURL = URL(string: "https://box448.bluehost.com/~revoltap/php")!
    
    func createAccount(username: String, email: String, password: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let postData = ["email" : email,
                        "username" : username,
                        "password" : password,
                        "UID" : UUID().uuidString]
        
        makePHPRequest(post: postData, onPage: "CreateUser.php") { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    func makePHPRequest(post: [String: String], onPage page: String, whenFinished: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        print("Function \(#function) and line number \(#line) in file \(#file)")
        
        let session = URLSession.shared
        var request = URLRequest(url: webURL.appendingPathComponent(page))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var d = ""
        var sent = ""
        
        for key in post.keys {
            d = "\(d)\(sent)\(key)=\(post[key]!)"
            sent = "&"
        }
        
        request.httpBody = d.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request, completionHandler: whenFinished)
        
        task.resume()
    }
    
}

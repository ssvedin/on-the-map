//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sabrina on 3/26/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import Foundation

class UdacityClient {
    
    static var sessionId: String? = nil
    
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void ) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
       
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode == 400 || statusCode == 403 {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
            let decoder = JSONDecoder()
            do {
                //let responseObject = try JSONDecoder().decode(LoginResponse.self, from: data)
                let range = 5..<data.count
                let newData = data.subdata(in: range) /* subset response data! */
                print(String(data: newData, encoding: .utf8)!)
                let responseObject = try decoder.decode(LoginResponse.self, from: newData)
                self.sessionId = responseObject.session?.id
                completion(true, nil)
            } catch {
                do {
                    let errorResponse = try decoder.decode(LoginErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
       task.resume()
    }
}

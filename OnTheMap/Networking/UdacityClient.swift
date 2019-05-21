//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sabrina on 3/26/19.
//  Copyright © 2019 Sabrina Svedin. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case udacitySignUp
        case udacityLogin
        case studentLocations
        case updateLocation
        case getLoggedInUser
        case getLoggedInUserProfile
        
        var stringValue: String {
            switch self {
            case .udacitySignUp:
                return "https://auth.udacity.com/sign-up"
            case .udacityLogin:
                return Endpoints.base + "/session"
            case .studentLocations:
                return Endpoints.base + "/StudentLocation"
            case .updateLocation:
                return Endpoints.base + "/StudentLocation/" + Auth.objectId
            case .getLoggedInUser:
                return Endpoints.base + "/StudentLocation" + "?uniqueKey=\(Auth.key)"
            case .getLoggedInUserProfile:
                return Endpoints.base + "/users/" + Auth.key
                
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    override init() {
        super.init()
    }
 
    class func shared() -> UdacityClient {
        struct Singleton {
            static var shared = UdacityClient()
        }
        return Singleton.shared
    }
    
    // MARK: Log In
    
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.udacityLogin.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
            
            do {
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                print(String(data: newData, encoding: .utf8)!)
                let responseObject = try JSONDecoder().decode(LoginResponse.self, from: newData)
                Auth.sessionId = responseObject.session.id
                Auth.key = (responseObject.account.key)
                
                getLoggedInUserInfo(completion: { (success, error) in
                    if success {
                        print("Logged in user's objectId: \(Auth.objectId)")
                    }
                })
                
                var profileURLString = URLRequest(url: Endpoints.getLoggedInUserProfile.url)
                profileURLString.httpMethod = "GET"
                profileURLString.addValue("application/json", forHTTPHeaderField: "Accept") // delete
                profileURLString.addValue("application/json", forHTTPHeaderField: "Content-Type")  // delete
                let task = URLSession.shared.dataTask(with: profileURLString) { data, response, error in
                    if error != nil {
                        return
                    }
                    let range = 5..<data!.count
                    let newData = data?.subdata(in: range)
                    print("printing profile")
                    print(String(data: newData!, encoding: .utf8)!)
                    
                    guard let profileResponseData = newData else { exit(1) }
                    print("Decoding Profile JSON")
                    
                    guard let profileObject = try? JSONDecoder().decode(UserProfile.self, from: profileResponseData) else {
                        print("Failed to decode profile JSON")
                        return
                    }
                    print("First Name : \(profileObject.firstName) && Last Name : \(profileObject.lastName) && Full Name: \(profileObject.nickname)")
                    Auth.firstName = profileObject.firstName
                    Auth.lastName = profileObject.lastName
                    
                }
                task.resume()
                completion(true, nil)
                
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(LoginErrorResponse.self, from: data) as Error
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
    
    /*
     class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
         let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
         RequestHelpers.taskForPOSTRequest(url: Endpoints.udacityLogin.url, apiType: "Udacity", responseType: LoginResponse.self, body: body, httpMethod: "POST") { (response, error) in
     
             let statusCode = (response as? HTTPURLResponse)?.statusCode
             if statusCode == 400 || statusCode == 403 {
                 DispatchQueue.main.async {
                     completion(false, error)
                 }
             }
     
             if let response = response {
                 Auth.sessionId = response.session.id
                 Auth.key = (response.account.key)
     
                 getLoggedInUserInfo(completion: { (success, error) in
                     if success {
                         print("Logged in user's objectId: \(Auth.objectId)")
                     }
                })
     
                getLoggedInUserProfile(completion: { (success, error) in
                    if success {
                        print("Logged in user's profile fetched.")
                    }
                })
     
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
     */
    
    // MARK: Get Logged In User's objectId in order to add or update location
    
    class func getLoggedInUserInfo(completion: @escaping (Bool, Error?) -> Void) {
        RequestHelpers.taskForGETRequest(url: Endpoints.getLoggedInUser.url, apiType: "Parse", responseType: StudentInformation.self) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId ?? ""
                print("getLoggedInUserInfo response: \(response)")
                completion(true, nil)
            } else {
                print("Decoding Student Info for objectId failed.")
                completion(false, error)
            }
        }
    }
    
    // MARK: Get Logged In User's Name
    
    /*
    class func getLoggedInUserProfile(completion: @escaping (Bool, Error?) -> Void) {
        RequestHelpers.taskForGETRequest(url: Endpoints.getLoggedInUserProfile.url, apiType: "Udacity", responseType: UserProfile.self) { (response, error) in
            if let response = response {
                print("printing profile")
                print("First Name : \(response.firstName) && Last Name : \(response.lastName) && Full Name: \(response.nickname)")
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                print("Failed to get user's profile.")
                completion(false, error)
            }
        }
    }
    */
    
    // MARK: Log Out
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.udacityLogin.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("Error logging out.")
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    // MARK: Get All Students
    
    class func getStudentLocations(completion: @escaping ([StudentInformation]?, Error?) -> Void) {
        RequestHelpers.taskForGETRequest(url: Endpoints.studentLocations.url, apiType: "Parse", responseType: StudentsLocation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // MARK: Add a Location
    
    class func addStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.studentLocations.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}".data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            var response: PostLocationResponse!
            let decoder = JSONDecoder()
            do {
                print(String(data: data, encoding: .utf8)!)
                response = try decoder.decode(PostLocationResponse.self, from: data)
                if let response = response, response.createdAt != nil {
                    completion(true, nil)
                }
            } catch {
                 completion(false, error)
            }
        }
        task.resume()
    }
    
    /*
    class func addStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}".data(using: .utf8)
     RequestHelpers.taskForPOSTRequest(url: Endpoints.studentLocations.url, apiType: "Parse", responseType: PostLocationResponse.self, body: body, httpMethod: "POST") { (response, error) in
            if let response = response, response.createdAt != nil {
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    */
    
    // MARK: Update Location
    
    class func updateStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void ) {
        
        var request = URLRequest(url: Endpoints.updateLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}".data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            var response: UpdateLocationResponse!
            let decoder = JSONDecoder()
            do {
                print(String(data: data, encoding: .utf8)!)
                response = try decoder.decode(UpdateLocationResponse.self, from: data)
                if let response = response, response.updatedAt != nil {
                    completion(true, nil)
                }
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }

    /*
    class func updateStudentLocation(information: StudentInformation, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}".data(using: .utf8)
        RequestHelpers.taskForPOSTRequest(url: Endpoints.updateLocation.url, apiType: "Parse", responseType: UpdateLocationResponse.self, body: body, httpMethod: "PUT") { (response, error) in
            if let response = response, response.updatedAt != nil {
                completion(true, nil)
            }
            completion(false, error)
        }
    }
    */
    
}

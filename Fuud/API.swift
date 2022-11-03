//
//  API.swift
//  Fuud
//
//  Created by Larry Urrego on 10/27/22.
//

import Foundation


struct API {
    
    static func getRestaurants(completion: @escaping ([Restaurant]?) -> Void) {
        
        // ––––– TODO: Add your own API key!
        let apikey = "0bKwWtXk4jzc0So7TJR5fMygAjCuxacxcL0jzCbtHcIcGseDmXFu7tIPlDiixlDHmZdHAR2_XYxmSqIWboCMH6CT42baMlR5-U7ftNw_suxaEi_4lqRb31TgRvolY3Yx"
        
//         Coordinates for San Francisco
//        let lat = 37.773972
//        let long = -122.431297
//
        
//        let url = URL(string: "https://api.yelp.com/v3/transactions/delivery/search?latitude=\(lat)&longitude=\(long)")!
        
        // get location typed in by user in location view controller
        var location = "SanFrancisco"
        if let userdefaultLocation = UserDefaults.standard.value(forKey: "userLocation") as? String {
            location = userdefaultLocation
        }

        let url = URL(string: "https://api.yelp.com/v3/businesses/search?location=\(location)&categories=restaurants")!

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        // Insert API Key to request
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
        

                // ––––– TODO: Get data from API and return it using completion
                
                // 1. Convert json response to a dictionary
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // 2. Grab the businesses data and convert it to an array of dictionaries
                //    for each restaurant
                //let restaurants = dataDictionary["businesses"] as! [[String: Any]]
                // 3. completion is an escaping method  which allows the data to be used
                //    outside of the closure
                //return completion(restaurants)
                
                // Get array of restaurant dictionaries
                let restDictionaries = dataDictionary["businesses"] as! [[String: Any]]

                //print(restDictionaries)
                // Variable to store array of Restaurants
                var restaurants: [Restaurant] = []

                // Use each restaurant dictionary to initialize Restaurant object
                for dictionary in restDictionaries {
                    let restaurant = Restaurant.init(dict: dictionary)
                    restaurants.append(restaurant) // add to restaurants array
                }

                return completion(restaurants)
                
                }
            }
        
            task.resume()
        
        }
    }

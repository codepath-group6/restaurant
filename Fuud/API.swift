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
        
        
        // get location typed in by user in location view controller
        var location = ""
        if let userdefaultLocation = UserDefaults.standard.value(forKey: "userLocation") as? String {
            location = userdefaultLocation
        }
        
        // set card limit to 50 (max)... default is 20
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?location=\(location)&categories=restaurants&limit=10")!
        
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
    
    // completion handler function to wait for session to complete before returning
    static func getNearbyCities(completion: @escaping ([String]?) -> Void) {
        
        // Figure how to get wikiDataId or cityId from User Input to replace City ID under request URL
        // *********************************************************************************************
        
        
        
        
        
        
        
        
        
        // *************** Networking credentials / Methods: START *********************************
        let headers = [
            "X-RapidAPI-Key": "8370ebca44mshcad83bf122f441cp115a31jsn3c9da19ef45d",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities/Q852581/nearbyCities?radius=5&minPopulation=20000")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        // *************** Networking credentials / Methods: END *********************************
        
        // ************ Start Session *********************
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            // if error is not nil (aka error exists)
            if let error = error {
                print(error.localizedDescription)
                
            // if data is not nil (aka data exists) --> transform response into array
            } else if let data = data {
                
                let response_json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // dictionary of nearby cities
                let nearby_cities_json = response_json["data"] as! [NSDictionary]
                print(nearby_cities_json)
                
//                print(nearby_cities_json[0]["city"] as! String) --> reads city name
//                print(nearby_cities_json[0]["id"] as! Int) --> reads city id
                
                var closest_city_names: [String] = []
                
                // append each id from sorted distance dictionary into a city array
                for current_city in nearby_cities_json {
                    
                    // create a Struct City to hold each city details
                    let city = City(dict: current_city as! [String : Any])
                    
                    // append each City id (distance already in ascending order b/c of how json format returns)
                    closest_city_names.append(city.name)
                }
                print("From API.swift: The closest city names array in order is \(closest_city_names)")
                
                // pass array of nearby city ids using completion
                return completion(closest_city_names)
            }
            
        })
        
        dataTask.resume()
    }
    
    
}

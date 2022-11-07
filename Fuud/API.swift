//
//  API.swift
//  Fuud
//
//  Created by Larry Urrego on 10/27/22.
//

import Foundation


struct API {
    
    // global lat/long variables
    static var latitude: Double = 0.0
    static var longitude: Double = 0.0
    
    static var user_input_id: String = ""
    
    static func getRestaurants(completion: @escaping ([Restaurant]?) -> Void) {
        
        // ––––– TODO: Add your own API key!
        let apikey = "0bKwWtXk4jzc0So7TJR5fMygAjCuxacxcL0jzCbtHcIcGseDmXFu7tIPlDiixlDHmZdHAR2_XYxmSqIWboCMH6CT42baMlR5-U7ftNw_suxaEi_4lqRb31TgRvolY3Yx"
        
        
        // get location typed in by user in location view controller
        var location = ""
        if let userdefaultLocation = UserDefaults.standard.value(forKey: "userLocation") as? String {
            location = userdefaultLocation
        }
        
        // set card limit by changing value of limit=            default: 20 | max is 50
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?location=\(location)&categories=restaurants&limit=25")!
        
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
                
                //prints array dictionary of all restaurants
//                print(restDictionaries)
                
                // set the longitude / latitude of User's City to get the City's wikiDataID --> use wikiDataID to get nearby Cities in API call below
                let temp_rest = Restaurant.init(dict: restDictionaries[0])
                latitude = temp_rest.latitude
                longitude = temp_rest.longitude
                
//                print(latitude)
//                print(longitude)
                
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
    
//    static func getCityId(completion: @escaping (String) -> Void) {
    static func getCityId() -> Void{

        let headers = [
            
//            8370ebca44mshcad83bf122f441cp115a31jsn3c9da19ef45d
            "X-RapidAPI-Key": "ffa07b3752msh9572ebe8754f7a7p109fa1jsndbd5dd6593cd",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]
        
        // use latitude + longitude to make request to fetch User City wikiDataID
        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?location=\(latitude)\(longitude)&limit=1&countryIds=US&minPopulation=30000&languageCode=EN")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            // if error is not nil (aka error exists)
            if let error = error {
                print(error.localizedDescription)
                
            // if data is not nil (aka data exists) --> transform response into array
            } else if let data = data {
                
                let response_json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print("the response json is \(response_json)")
                
                // Fetch wikiDataID to use in getNearbyCities() request
                let response_dict = response_json["data"] as? [NSDictionary]
                let optional_id = response_dict?[0]["wikiDataId"]

                // safe unwrapping of an optional... cannot force-unwrap b/c it can contain a nil 
                if let optional_id = optional_id {
                    let string_id = optional_id
                    print(string_id)
                    user_input_id = (string_id as? String)!
                }
            }
        })
        dataTask.resume()
    }
    
    
    // completion handler function to wait for session to complete before returning
    static func getNearbyCities(completion: @escaping ([String]?) -> Void) {
        
        // At this stage, need to fetch wikiDataId from User Input to replace City ID under request URL
        // Resolved? Yes, by getting User City Latitude/Longitude via Yelp's API
        // *********************************************************************************************
        
//        let user_city_input = UserDefaults.standard.string(forKey: "userLocation")
//        print("Current user city is \(String(describing: user_city_input))")
        
        
        // *************** Networking credentials / Methods: START *********************************
        let headers = [
            "X-RapidAPI-Key": "8370ebca44mshcad83bf122f441cp115a31jsn3c9da19ef45d",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]

        // use wikiDataID of User City Input into GeoDB Cities to fetch nearby cities
        // change limit= value to desired number of nearest cities
        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities/\(user_input_id)/nearbyCities?radius=10&minPopulation=20000&limit=10")! as URL,
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
//                print(nearby_cities_json)
                
//                print(nearby_cities_json[0]["city"] as! String) --> reads city name
//                print(nearby_cities_json[0]["id"] as! Int) --> reads city id
                
                var closest_city_names: [String] = []
                
                // append each id from sorted distance dictionary into a city array
                for current_city in nearby_cities_json {
                    
                    // create a Struct City to hold each city details
                    let city = City(dict: current_city as! [String : Any])
                    
                    // append each City id (distance already in ascending order b/c of how json format returns)
                    let city_name_nospace = city.name.replacingOccurrences(of: " ", with: "")
                    closest_city_names.append(city_name_nospace)
                }
                print("From API.swift: The closest city names array in order is \(closest_city_names)")
                
                // pass array of nearby city ids using completion
                return completion(closest_city_names)
            }
            
        })
        
        dataTask.resume()
    }
    
    
}

//
//  Restaurant.swift
//  Fuud
//
//  Created by Larry Urrego on 10/30/22.
//

import Foundation

class Restaurant {
    // Establish Properties
    var imageURL: URL?
    var url: URL?
    var name: String
    var mainCategory: String
    var phone: String
    var rating: Double
    var reviews: Int
    var id: String
    var street: NSArray
    //var cityState: String
    var latitude: Double
    var longitude: Double
    
    //Initializer
    init(dict: [String:Any]) {
        imageURL = URL(string: dict["image_url"] as! String)
        name = dict["name"] as! String
        rating = dict["rating"] as! Double
        reviews = dict["review_count"] as! Int
        phone = dict["display_phone"] as! String
        url = URL(string: dict["url"] as! String)
        mainCategory = Restaurant.getMainCategory(dict: dict)
        id = dict["id"] as! String
        street = Restaurant.getLocation(dict: dict)
        latitude = Restaurant.getLatitude(dict: dict)
        longitude = Restaurant.getLongitude(dict: dict)
    
    }
    
    //Helper function to get first category from restaurant
    static func getLatitude(dict: [String:Any]) -> Double {
        let latitude = dict["coordinates"] as! [String: Any]
        return latitude["latitude"] as! Double
    }
    
    //Helper function to get first category from restaurant
    static func getLongitude(dict: [String:Any]) -> Double {
        let longitude = dict["coordinates"] as! [String: Any]
        return longitude["longitude"] as! Double
    }
    
    //Helper function to get first category from restaurant
    static func getMainCategory(dict: [String:Any]) -> String {
        let categories = dict["categories"] as! [[String: Any]]
        return categories[0]["title"] as! String
    }
    
    //Helper function to get the display_address array (to avoid doing multiple calls to each individual
    //address section
    static func getLocation(dict: [String:Any]) -> NSArray {
        let location = dict["location"] as! NSDictionary
        return location["display_address"] as! NSArray
    }
}

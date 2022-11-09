//
//  FavoritesViewController.swift
//  Fuud
//
//  Created by Eugene Song on 10/30/22.
//

import UIKit
import Parse
import AlamofireImage

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // declare an array to hold Restaurants
    var restaurants = [PFObject]()
    // declare a set to hold restaurant IDs
    var restaurantIDs = Set<String>()
    // declare an array to hold unique Restaurants to the user
    var uniqueRestaurants = [PFObject]()
    
    var currentUser_id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // **** current session User's id ***
//        print("this is \(PFUser.current()!.objectId!) in the FavoritesViewController")
        currentUser_id = PFUser.current()!.objectId!
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.estimatedRowHeight = 200
        
        
        // get all "Favorite_Restaurants" objects from Parse
        let query = PFQuery(className: "Favorite_Restaurants")
        
        // set query results limit to maximum - 1000
        query.limit = 1000
        
        query.findObjectsInBackground { (objects, error) in
            // no error in fetch
            if error == nil {
                
                // object array isn't nil
                if let returnedObjects = objects {
                    // loop through array to get each object
                    for object in returnedObjects {
                        
                        // initialize the current Restaurant object
                        let currentObject_User = object["User"] as! PFUser
                        // print("this is \(object)'s current User's : \(object["User"])")
                        
                        // check if current session user ID is equal to curr Restaurant object's UserID pointer in Parse (one who favorited the restaurant)
                        if (self.currentUser_id == currentObject_User.objectId!) {
                            print(object["Restaurant_name"] as! String)
                            self.restaurants.append(object)
                        }
                    }
                    // print(self.restaurants)
                }
                
                // add unique restaurant objects to uniqueRestaurants
                for restObject in self.restaurants {
                    // initialize restaurant id as String
                    let restaurant_id = restObject["Restaurant_id"] as! String
                    
                    // add restaurant object to arr if the restaurant id is unique
                    if (!self.restaurantIDs.contains(restaurant_id)) {
                        self.uniqueRestaurants.append(restObject)
                    }
                    
                    // save restaurant id to restaurantIDs set
                    self.restaurantIDs.insert(restaurant_id)
                }
                
                // reload data after restaurants array is filled
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    // attempt at remove function, delete shows up by swiping but row doesn't delete
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return restaurants.count
        return uniqueRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(restaurants.count)
        print("dequeueReusable cell has been reached")
        // recycle cells and cast FavoritesTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell") as! FavoritesTableViewCell
        
//        let restaurant = restaurants[indexPath.row]
        let restaurant = uniqueRestaurants[indexPath.row]
        
        print("cellForRowAt has been reached")
        print(restaurant)
        
        // get restaurant name from restaurant object
        let name = restaurant["Restaurant_name"] as! String
        let cuisine = restaurant["Restaurant_cuisine"] as! String
        let rest_stars = restaurant["Restaurant_stars"] as! Double
        let reviews = restaurant["Restaurant_review_num"] as! Int
                
        cell.restaurantName.text = name
        cell.cuisineLabel.text = cuisine
        cell.reviewLabel.text = String(reviews)
        cell.restaurantStars.image = Stars.dict[rest_stars]!
        
        // set image of restaurant
        if let imageURLString = restaurant["Restaurant_image_url"] as? String {
            let imageURL = URL(string: imageURLString)
            cell.restaurantImage.af.setImage(withURL: imageURL!)
        }
        
        return cell
        
    }
    
    // attempt at delete row functions
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.uniqueRestaurants.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}



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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        
        // get all "Favorite_Restaurants" objects from Parse
        let query = PFQuery(className: "Favorite_Restaurants")
        
        query.findObjectsInBackground { (objects, error) in
            // no error in fetch
            if error == nil {
                
                // object array isn't nil
                if let returnedObjects = objects {
                    // loop through array to get each object
                    for object in returnedObjects {
                        print(object["Restaurant_name"] as! String)
                        self.restaurants.append(object)
                    }
//                    print(self.restaurants)
                }
                
                // reload data after restaurants array is filled
                self.tableView.reloadData()

            }
        }
        // need to reload data to tell tableview to update once restaurants array is filled
//        self.tableView.reloadData()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        // create query using Parse database retrieval under "Basic Queries" in their docs
//
//        let query = PFQuery(className: "Favorite_Restaurants")
//
//        query.findObjectsInBackground { (objects, error) in
//            // no error in fetch
//            if error == nil {
//                if let returnedObjects = objects {
//                    // object array isn't nil
//                    // loop through array to get each object
//
//                    for object in returnedObjects {
//                        print(object["Restaurant_name"] as! String)
//                        self.restaurants.append(object)
//                    }
//                    print(self.restaurants)
//                }
//            }
//        }
//        self.tableView.reloadData()
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(restaurants.count)
        print("dequeueReusable cell has been reached")
        // recycle cells and cast FavoritesTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell") as! FavoritesTableViewCell
        
        let restaurant = restaurants[indexPath.row]
        
        print("cellForRowAt has been reached")
        print(restaurant)
        
//        let name = restaurant["name"] as! String
        
        
        // get restaurant name from restaurant object
        let name = restaurant["Restaurant_name"] as! String
        
        cell.restaurantName.text = name
        
        // set image of restaurant
        if let imageURLString = restaurant["Restaurant_image_url"] as? String {
            let imageURL = URL(string: imageURLString)
            cell.restaurantImage.af.setImage(withURL: imageURL!)
        }

        return cell

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



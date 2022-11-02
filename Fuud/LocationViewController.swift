//
//  LocationViewController.swift
//  Fuud
//
//  Created by Sandra Yee on 11/2/22.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var addressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        let address = addressField.text
        
        // segue from location screen to restaurant card screen when address entered
        // eventually change this to check for valid address
        if address != "" {
            // set text entered into textfielf to UserDefault
            // persist data across files and app launches
            UserDefaults.standard.set(address, forKey: "userLocation")
            self.performSegue(withIdentifier: "locationSegue", sender: nil)
        } else {
            print("invalid address")
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

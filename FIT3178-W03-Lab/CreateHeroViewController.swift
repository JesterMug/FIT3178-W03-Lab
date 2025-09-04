//
//  CreateHeroViewController.swift
//  FIT3178-W03-Lab
//
//  Created by Jagannath on 22/8/2025.
//

import UIKit

class CreateHeroViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var abilitiesTextField: UITextField!
    @IBOutlet weak var universeSegmentedControl: UISegmentedControl!
    weak var databaseController: DatabaseProtocol?
    
    @IBAction func createHero(_ sender: Any) {
        guard let name = nameTextField.text, let abilities = abilitiesTextField.text, let universe = Universe(rawValue: Int32(universeSegmentedControl.selectedSegmentIndex)) else {
            return
        }
        
        if name.isEmpty || abilities.isEmpty {
            var errorMsg = "Please ensure all fields are filled:\n"
            if name.isEmpty {
                errorMsg += "- Must provide a name\n"
            }
            if abilities.isEmpty {
                errorMsg += "- Must provide abilities\n"
            }
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        
        let _ = databaseController?.addSuperhero(name: name, abilities: abilities, universe: universe)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
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

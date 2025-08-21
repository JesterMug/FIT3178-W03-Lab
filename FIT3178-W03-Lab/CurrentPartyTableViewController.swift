//
//  CurrentPartyTableViewController.swift
//  FIT3178-W03-Lab
//
//  Created by Jagannath on 15/8/2025.
//

import UIKit

/// <#Description#>
class CurrentPartyTableViewController: UITableViewController {
    
    let SECTION_HERO = 0
    let SECTION_INFO = 1
    
    let CELL_HERO = "heroCell"
    let CELL_INFO = "partySizeCell"
    
    var currentParty: [Superhero] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        testHeroes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case SECTION_INFO:
                return 1
            case SECTION_HERO:
                return currentParty.count
            default:
                return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_HERO {
            let heroCell = tableView.dequeueReusableCell(withIdentifier: CELL_HERO, for: indexPath)
            
            var content = heroCell.defaultContentConfiguration()
            let hero = currentParty[indexPath.row]
            content.text = hero.name
            content.secondaryText = hero.abilities
            heroCell.contentConfiguration = content
            
            return heroCell
        }
        else {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
            
            var content = infoCell.defaultContentConfiguration()
            if currentParty.isEmpty {
                content.text = "No Heroes in Party. Tap + to add some."
            } else {
                content.text = "\(currentParty.count)/6 Heroes in Party"
            }
            infoCell.contentConfiguration = content
            
            return infoCell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == SECTION_HERO
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_HERO {
            tableView.performBatchUpdates({
                self.currentParty.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_INFO], with: .automatic)
            }, completion: nil)
        }
    }
    
    func testHeroes() {
        currentParty.append(Superhero(name: "Superman", abilities: "Super Powered Alien", universe: .dc))
        currentParty.append(Superhero(name: "Wonder Woman", abilities: "Goddess", universe: .dc))
        currentParty.append(Superhero(name: "The Flash", abilities: "Speed", universe: .dc))
        currentParty.append(Superhero(name: "Green Lantern", abilities: "Power Ring", universe:
        .dc))
        currentParty.append(Superhero(name: "Cyborg", abilities: "Robot Beep Beep", universe: .dc))
        currentParty.append(Superhero(name: "Aquaman", abilities: "Atlantian", universe: .dc))
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

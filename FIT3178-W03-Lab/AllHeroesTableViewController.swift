//
//  AllHeroesTableViewController.swift
//  FIT3178-W03-Lab
//
//  Created by Jagannath on 22/8/2025.
//

import UIKit

extension UIViewController {
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

/// <#Description#>
class AllHeroesTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    
    
    var listenerType = ListenerType.heroes
    weak var databaseController: DatabaseProtocol?
    
    func onTeamChange(change: DatabaseChange, teamHeroes: [Superhero]) {
        // Do nothing.
    }
    
    func onAllHeroesChange(change: DatabaseChange, heroes: [Superhero]) {
        allHeroes = heroes
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    
    func addSuperhero(_ newHero: Superhero) -> Bool {
        tableView.performBatchUpdates({
            allHeroes.append(newHero)
            filteredHeroes.append(newHero)
            
            tableView.insertRows(at: [IndexPath(row: filteredHeroes.count - 1, section: SECTION_HERO)], with: .automatic)
            tableView.reloadSections([SECTION_INFO], with: .automatic)
        }, completion: nil)
        return true
    }
    
    
    let SECTION_HERO = 0
    let SECTION_INFO = 1

    let CELL_HERO = "heroCell"
    let CELL_INFO = "totalCell"

    var allHeroes: [Superhero] = []
    var filteredHeroes: [Superhero] = []

    weak var superheroDelegate: AddSuperheroDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        filteredHeroes = allHeroes
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search All Heroes"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        databaseController?.addListener(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        databaseController?.removeListener(self)
    }
    
    // MARK: - Table view data source
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        if searchText.count > 0 {
            filteredHeroes = allHeroes.filter({(hero: Superhero) -> Bool in return (hero.name?.lowercased().contains(searchText) ?? false)})
        } else {
            filteredHeroes = allHeroes
        }
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_HERO {
            return filteredHeroes.count
        } else if section == SECTION_INFO {
            return 1
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_HERO {
            let heroCell = tableView.dequeueReusableCell(withIdentifier: CELL_HERO, for: indexPath)
            var content = heroCell.defaultContentConfiguration()
            let hero = filteredHeroes[indexPath.row]
            content.text = hero.name
            content.secondaryText = hero.abilities
            heroCell.contentConfiguration = content
            return heroCell
        }
        else {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for:
                                                            indexPath) as! HeroCountTableViewCell
            infoCell.totalLabel?.text = "\(filteredHeroes.count) heroes in the database"
            return infoCell
        }
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == SECTION_HERO
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_HERO {
            let hero = filteredHeroes[indexPath.row]
            databaseController?.deleteSuperhero(hero: hero)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let superHeroDelegate = superheroDelegate {
            if superHeroDelegate.addSuperhero(filteredHeroes[indexPath.row]) {
                navigationController?.popViewController(animated: false)
                return
            }
            else {
                displayMessage(title: "Party Full", message: "Unable to add more members to party")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }
}

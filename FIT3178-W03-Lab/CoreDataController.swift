//
//  CoreDataController.swift
//  FIT3178-W03-Lab
//
//  Created by Jagannath on 5/9/2025.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    let DEFAULT_TEAM_NAME = "Default Team"
    var teamHeroesFetchedResultsController: NSFetchedResultsController<Superhero>?
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    var allHeroesFetchedResultsController: NSFetchedResultsController<Superhero>?
    
    lazy var defaultTeam: Team = {
        var teams = [Team]()
        
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        let predicate = NSPredicate(format: "name == %@", DEFAULT_TEAM_NAME)
        request.predicate = predicate
        
        do {
            teams = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        
        if let firstTeam = teams.first {
            return firstTeam
        }
        return addTeam(teamName: DEFAULT_TEAM_NAME)
    }()
    
    func addTeam(teamName: String) -> Team {
        let team = Team(context: persistentContainer.viewContext)
        team.name = teamName
        
        return team
    }
    
    func deleteTeam(team: Team) {
        persistentContainer.viewContext.delete(team)
    }
    
    func addHeroToTeam(hero: Superhero, team: Team) -> Bool {
        guard let heroes = team.heroes, heroes.contains(hero) == false, heroes.count < 6 else {
            return false
        }
        
        team.addToHeroes(hero)
        return true
    }
    
    func removeHeroFromTeam(hero: Superhero, team: Team) {
        team.removeFromHeroes(hero)
    }
    
    func fetchTeamHeroes() -> [Superhero] {
        if teamHeroesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Superhero> = Superhero.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let predicate = NSPredicate(format: "Any teams.name == %@", DEFAULT_TEAM_NAME)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            fetchRequest.predicate = predicate
            
            teamHeroesFetchedResultsController = NSFetchedResultsController<Superhero>(
                fetchRequest: fetchRequest,
                managedObjectContext: persistentContainer.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            teamHeroesFetchedResultsController?.delegate = self
            
            do {
                try teamHeroesFetchedResultsController?.performFetch()
            } catch {
                print("Failed to perform fetch for team heroes: \(error)")
            }
        }
        var heroes = [Superhero]()
        if teamHeroesFetchedResultsController?.fetchedObjects != nil {
            heroes = (teamHeroesFetchedResultsController?.fetchedObjects)!
        }
        
        return heroes
    }
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Week04-DataModel")
        persistentContainer.loadPersistentStores() { description, error in
            if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
        if fetchAllHeroes().count == 0 {
            createDefaultHeroes()
        }
    }
    
    func cleanUp() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError( "Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    func addListener(_ listener: any DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .heroes || listener.listenerType == .all {
            listener.onAllHeroesChange(change: .update, heroes: fetchAllHeroes())
        }
        
        if listener.listenerType == .team || listener.listenerType == .all {
            listener.onTeamChange(change: .update, teamHeroes: fetchTeamHeroes())
        }
    }
    
    func removeListener(_ listener: any DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addSuperhero(name: String, abilities: String, universe: Universe) -> Superhero {
        let hero = Superhero(context: persistentContainer.viewContext)
        hero.name = name
        hero.abilities = abilities
        hero.herouniverse = universe
        
        return hero
    }
    
    func deleteSuperhero(hero: Superhero) {
        persistentContainer.viewContext.delete(hero)
    }
    func fetchAllHeroes() -> [Superhero] {
        if allHeroesFetchedResultsController == nil {
            let request: NSFetchRequest<Superhero> = Superhero.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key:"name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            allHeroesFetchedResultsController = NSFetchedResultsController<Superhero>(
                fetchRequest: request,
                managedObjectContext: persistentContainer.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            allHeroesFetchedResultsController?.delegate = self
            
            do {
                try allHeroesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch request failed: \(error)")
            }
        }
        
        if let heroes = allHeroesFetchedResultsController?.fetchedObjects {
            return heroes
        }
        return [Superhero]()
    }
    
    func createDefaultHeroes() {
        let _ = addSuperhero(name: "Bruce Wayne", abilities: "Money", universe: .dc)
        let _ = addSuperhero(name: "Superman", abilities: "Super Powered Alien", universe: .marvel)
        let _ = addSuperhero(name: "Wonder Woman", abilities: "Goddess", universe: .dc)
        let _ = addSuperhero(name: "The Flash", abilities: "Speed", universe: .dc)
        let _ = addSuperhero(name: "Green Lantern", abilities: "Power Ring", universe: .dc)
        let _ = addSuperhero(name: "Cyborg", abilities: "Robot Beep Beep", universe: .dc)
        let _ = addSuperhero(name: "Aquaman", abilities: "Atlantian", universe: .dc)
        let _ = addSuperhero(name: "Captain Marvel", abilities: "Superhuman Strength", universe: .marvel)
        let _ = addSuperhero(name: "Spider-Man", abilities: "Spider Sense", universe: .marvel)
        cleanUp()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if controller == allHeroesFetchedResultsController {
            listeners.invoke() {
                listener in if listener.listenerType == .heroes || listener.listenerType == .all {
                    listener.onAllHeroesChange(change: .update, heroes: fetchAllHeroes())
                }
            }
        } else if controller == teamHeroesFetchedResultsController {
            listeners.invoke {
                (listener) in if listener.listenerType == .team || listener.listenerType == .all {
                    listener.onTeamChange(change: .update, teamHeroes: fetchTeamHeroes())
                }
            }
        }
    }

}

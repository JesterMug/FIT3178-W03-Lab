//
//  CoreDataController.swift
//  FIT3178-W03-Lab
//
//  Created by Jagannath on 5/9/2025.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    var allHeroesFetchedResultsController: NSFetchedResultsController<Superhero>?
    
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
        }
    }

}

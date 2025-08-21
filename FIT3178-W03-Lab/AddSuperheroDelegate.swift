//
//  AddSuperheroDelegate.swift
//  FIT3178-W03-Lab
//
//  Created by Jagannath on 22/8/2025.
//

import Foundation

protocol AddSuperheroDelegate: AnyObject {
    func addSuperhero(_ newHero: Superhero) -> Bool
}

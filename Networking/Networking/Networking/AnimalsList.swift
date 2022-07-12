//
//  CatsList.swift
//  Networking
//
//  Created by Dmytro Hetman on 17.06.2022.
//

import Foundation

public final class AnimalsList {
    
    public static let shared = AnimalsList()
    
    public var animalsList: [Animal] = [] {
        didSet {
            catsLoadedHandler?()
        }
    }
    
    public var catsLoadedHandler: (() -> Void)?
    
    private init() { }
    
}
    
    
    
    

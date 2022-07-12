//
//  CatsFetcher.swift
//  Networking
//
//  Created by Dmytro Hetman on 17.06.2022.
//

import Foundation

public final class AnimalFetcher {
    
    public static let shared = AnimalFetcher()
    
    private init() { }
    
    public func fetchAnimals(limit: Int, fetch: @escaping ([Animal]) -> Void) {
        
        guard let typeOfVersion: String = Bundle.main.object(forInfoDictionaryKey: "AnimalsType") as? String else { return }
        print(typeOfVersion)
        let animal = typeOfVersion == "CATS" ? "cat" : "dog"
        print(animal)
        let urlSession = URLSession(configuration: .default)
        
        guard let urlString = URL(string: "https://api.the\(animal)api.com/v1/images/search?limit=\(limit)")
        else { return }
        
        urlSession.dataTask(with: urlString) { data, response, error in
            guard let data = data,
                  let catsData = try? JSONDecoder().decode([AnimalModel].self, from: data)
            else { return }
            
            let animal = catsData.compactMap {
                animal -> Animal? in

                let animal = Animal(
                    url: animal.url,
                    width: animal.width,
                    height: animal.height
                )
                return animal
            }
            fetch(animal)
        }.resume()
    }
}

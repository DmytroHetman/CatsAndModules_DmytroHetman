//
//  CatTableViewCell.swift
//  CatsAndModules_DmytroHetman
//
//  Created by Dmytro Hetman on 20.06.2022.
//

import UIKit
import Networking
import SDWebImage
import FirebasePerformance

class AnimalTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet private weak var catView: AnimalView!
    
    //MARK: - Config
    
    func config(from animalData: Animal) {
        let traceForCatImage = Performance.startTrace(name: "CAT_IMAGE")
        self.catView.imageView.sd_setImage(with: URL(string: animalData.url), placeholderImage: UIImage(named: "catPlaceholder")) { [weak self] image, error, cache, urls in
            
            self?.catView.imageView.image = error == nil ? image : UIImage(named: "catPlaceholder")
            
            traceForCatImage?.stop()
        }
        
    }
    
}

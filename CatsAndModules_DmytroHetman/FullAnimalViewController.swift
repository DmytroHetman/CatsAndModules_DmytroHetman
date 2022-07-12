//
//  FullCatViewController.swift
//  CatsAndModules_DmytroHetman
//
//  Created by Dmytro Hetman on 22.06.2022.
//

import UIKit

class FullAnimalViewController: UIViewController {

    @IBOutlet weak var fullAnimalImageView: UIImageView!
    
    var urlOfFullAnimal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("fullcat: \(urlOfFullAnimal)")
        
        self.fullAnimalImageView.sd_setImage(with: URL(string: urlOfFullAnimal))
        self.fullAnimalImageView.enableZoom()
    }

}

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
      sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
      sender.scale = 1
  }
}

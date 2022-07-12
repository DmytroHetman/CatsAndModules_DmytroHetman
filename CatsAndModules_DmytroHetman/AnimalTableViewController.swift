//
//  ViewController.swift
//  CatsAndModules_DmytroHetman
//
//  Created by Dmytro Hetman on 17.06.2022.
//

import UIKit
import Networking
import FirebasePerformance
import FirebaseCrashlytics

class AnimalTableViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    @IBOutlet private weak var crashBtn: UIButton!
    
    //MARK: - @objc Actions
    
    @objc
    private func barButtonAction(_ sender: UIBarButtonItem!) {
        crashlytics.setCustomValue("testBtn", forKey: "testBtn1")
        crashlytics.log("crashButton is pressed!")
        fatalError("crashButton is pressed!(intentionally)")
    }
    
    //MARK: - Properties
    
    let crashlytics = Crashlytics.crashlytics()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadPosts()
        AnimalsList.shared.catsLoadedHandler = {
            self.reloadDataAsync()
        }
        
        self.crashBtn.addTarget(self, action: #selector(barButtonAction(_:)), for: .touchUpInside)
        self.askForCollectingData()
        
    }
    
}

extension AnimalTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnimalsList.shared.animalsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellReuseId, for: indexPath) as! AnimalTableViewCell
        cell.config(from: AnimalsList.shared.animalsList[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            self.loadPosts()
            AnimalsList.shared.catsLoadedHandler = {
                self.reloadDataAsync()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Crashlytics.crashlytics().setCustomValue("test", forKey: "test1")
        Crashlytics.crashlytics().log("Row \(indexPath.row) is selected")
        
        
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Const.fullCatSegueId,
           let destination = segue.destination as? FullAnimalViewController,
           let catIndex = tableView.indexPathForSelectedRow?.row {
            destination.urlOfFullAnimal = AnimalsList.shared.animalsList[catIndex].url
        }
    }
    
    //MARK: - Often reused functions
    
    private func reloadDataAsync() {
        DispatchQueue.main.async { [weak self] in
          self?.tableView.reloadData()
        }
    }
    
    private func loadPosts() {
        let traceForFetcher = Performance.startTrace(name: "FETCH_CATS")
        AnimalFetcher.shared.fetchAnimals(limit: Const.limit) {  cats in
            AnimalsList.shared.animalsList.append(contentsOf: cats)
        }
        traceForFetcher?.stop()
    }
    
    private func askForCollectingData() {
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "firstRunAlert") {
            
            let alertController = UIAlertController(
                title: "Request",
                message: "Provide user consent to collect data on crashes",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Provide", style: .default) {_ in
                userDefaults.set(true, forKey: "firstRunAlert")
                userDefaults.synchronize()
                self.crashlytics.setCrashlyticsCollectionEnabled(true)
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) {_ in
                self.crashlytics.setCrashlyticsCollectionEnabled(false)
            })
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
}

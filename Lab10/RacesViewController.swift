//
//  RacesViewController.swift
//  Lab10
//
//  Created by Anton Sipaylo on 6/7/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import UIKit
import CoreData

class RacesViewController: UIViewController {
    @IBOutlet weak var raceTableView: UITableView!
    
    let cellIdentifier = "RaceTableViewCell"
    let entityName = "Race"
    let keyPaths = ["name", "company", "cost"]
    let rowHeight = CGFloat(200)
    let alertMainTitle = "The hotel was booked!"
    
    private var racesInfo = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRaceTableView()
        deleteRacesInfo()
        addRace(name: "RaceNumber1", company: "CompanyNumber1", cost: 100.0)
        addRace(name: "RaceNumber2", company: "CompanyNumber2", cost: 99.5)
        addRace(name: "RaceNumber3", company: "CompanyNumber3", cost: 89.98)
        loadRacesInfo()
        print(racesInfo.count)
    }
    
    func setGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(processTapOnRaceTableView(_:)))
        raceTableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func processTapOnRaceTableView(_ gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.location(in: raceTableView)
        if let indexPath = raceTableView.indexPathForRow(at: point),
            let cell = raceTableView.cellForRow(at: indexPath) as? RaceTableViewCell,
            let raceName = cell.raceNameLabel.text,
            let companyName = cell.companyNameLabel.text,
            let costValue = cell.costLabel.text {
            let alertMessage = "\(raceName), \(companyName), \(costValue)"
            let alert = UIAlertController(title: alertMainTitle,
                                          message: alertMessage,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
    }
    
    func setUpRaceTableView() {
        raceTableView.tableFooterView = UIView()
        raceTableView.rowHeight = rowHeight
        setGestureRecognizer()
    }
    
    func addRace(name: String, company: String, cost: Double) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName,
                                                      in: managedContext) else {
                                                        return
        }
        
        let race = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        race.setValue(name, forKeyPath: keyPaths[0])
        race.setValue(company, forKey: keyPaths[1])
        race.setValue(cost, forKey: keyPaths[2])
        do {
            try managedContext.save()
        } catch {
            print("Could not save. Error: \(error.localizedDescription)")
        }
    }
    
    func loadRacesInfo() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            racesInfo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteRacesInfo() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        do {
            if let races = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                for race in races {
                    managedContext.delete(race)
                }
                try managedContext.save()
            }
        } catch {
            
        }
    }
    
    func setRacesInfo(_ racesInfo: [NSManagedObject]) {
        self.racesInfo = racesInfo
    }

}

extension RacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return racesInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? RaceTableViewCell else {
                                                        return UITableViewCell()
        }
        setUpCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setUpCell(_ cell: RaceTableViewCell, indexPath: IndexPath) {
        cell.raceNameLabel.text = racesInfo[indexPath.row].value(forKey: keyPaths[0]) as? String
        cell.companyNameLabel.text = racesInfo[indexPath.row].value(forKey: keyPaths[1]) as? String
        if let cost = racesInfo[indexPath.row].value(forKey: keyPaths[2]) as? Double {
            cell.costLabel.text = String(cost)
        }
    }
    
    
}

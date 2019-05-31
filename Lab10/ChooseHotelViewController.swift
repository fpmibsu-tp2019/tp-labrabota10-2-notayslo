//
//  ChooseHotelViewController.swift
//  Lab10
//
//  Created by Anton Sipaylo on 6/1/19.
//  Copyright © 2019 Anton Sipaylo. All rights reserved.
//

import UIKit
import CoreData

class ChooseHotelViewController: UIViewController {
    @IBOutlet weak var chooseHotelTableView: UITableView!
    
    let rowHeight = CGFloat(230)
    let cellIdentifier = "HotelTableViewCell"
    let entityName = "HotelInfo"
    let keyPaths = ["name", "specification", "city", "longitude", "latitude"]
    let transportInfoSegueName = "TransportInfoSegue"
    
    var hotelsInfo = [NSManagedObject]()
    var lastTappedCell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        deleteHotels()
//        addHotel(name: "AntonsHotel",
//                 specification: "AntonsHotel was found in 2000. The owner: Anton Sipaylo",
//                 city: "Minsk",
//                 longitude: 27.419461920551154,
//                 latitude: 54.003273887376295)
//
//        addHotel(name: "HelensHotel",
//                 specification: "HelensHotel was found in 1995. The owner: Helen",
//                 city: "Moscow",
//                 longitude: 27.68805666838192,
//                 latitude: 54.01246493100787)
//
//        addHotel(name: "ArthursHotel",
//                 specification: "ArthursHotel was found in 1998. The owner: Arthur",
//                 city: "Lida",
//                 longitude: 27.42898173439831,
//                 latitude: 53.87839475194561)
        loadHotelsInfo()
        setUpChooseHotelTableView()
        loadHotelsInfo()
        setUpGestureRecognizerForCells()
    }
    
    @objc private func processTapOnCell(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let point = tapGestureRecognizer.location(in: chooseHotelTableView)
        if let indexPath = chooseHotelTableView.indexPathForRow(at: point) {
            lastTappedCell = chooseHotelTableView.cellForRow(at: indexPath)
            performSegue(withIdentifier: transportInfoSegueName, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChooseTransportViewController,
            let cell = lastTappedCell as? HotelTableViewCell,
            let indexPath = chooseHotelTableView.indexPath(for: cell),
            let longitude = hotelsInfo[indexPath.row].value(forKey: keyPaths[3]) as? Double,
            let latitude = hotelsInfo[indexPath.row].value(forKey: keyPaths[4]) as? Double {
            destination.setHotelLocation(longitude: longitude, latitude: latitude)
        }
    }
    
    func setUpChooseHotelTableView() {
        chooseHotelTableView.rowHeight = rowHeight
        chooseHotelTableView.tableFooterView = UIView()
        chooseHotelTableView.allowsSelection = false
    }
    
    func setUpGestureRecognizerForCells() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(processTapOnCell(_ :)))
        chooseHotelTableView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Additional method for adding data to CoreData
    func addHotel(name: String, specification: String, city: String, longitude: Double, latitude: Double) {
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
    
        let hotel = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        hotel.setValue(name, forKeyPath: keyPaths[0])
        hotel.setValue(specification, forKey: keyPaths[1])
        hotel.setValue(city, forKey: keyPaths[2])
        hotel.setValue(longitude, forKey: keyPaths[3])
        hotel.setValue(latitude, forKey: keyPaths[4])
        do {
            try managedContext.save()
        } catch {
            print("Could not save. Error: \(error.localizedDescription)")
        }
    }
    
    func loadHotelsInfo() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            hotelsInfo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteHotels() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for item in items {
                managedContext.delete(item)
            }
            try managedContext.save()
        } catch {
            
        }
    }
}

extension ChooseHotelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HotelTableViewCell else {
            return UITableViewCell()
        }
        cell.hotelNameLabel.text = hotelsInfo[indexPath.row].value(forKey: keyPaths[0]) as? String
        cell.hotelDescriptionLabel.text = hotelsInfo[indexPath.row].value(forKey: keyPaths[1]) as? String
        cell.hotelCityNameLabel.text = hotelsInfo[indexPath.row].value(forKey: keyPaths[2]) as? String
        return cell
    }
    
    
}

//addHotel(name: "AntonsHotel",
//         specification: "AntonsHotel was found in 2000. The owner: Anton Sipaylo",
//         city: "Minsk",
//         longitude: 27.419461920551154,
//         latitude: 54.003273887376295)
//
//addHotel(name: "HelensHotel",
//         specification: "HelensHotel was found in 1995. The owner: Helen",
//         city: "Moscow",
//         longitude: 27.68805666838192,
//         latitude: 54.01246493100787)
//
//addHotel(name: "ArthursHotel",
//         specification: "ArthursHotel was found in 1998. The owner: Arthur",
//         city: "Lida",
//         longitude: 27.42898173439831,
//         latitude: 53.87839475194561)

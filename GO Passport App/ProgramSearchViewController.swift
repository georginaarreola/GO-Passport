//
//  ProgramSearchViewController.swift
//  GO Passport App
//
//  Created by Eva Arreola on 4/25/18.
//  Copyright © 2018 Geo. All rights reserved.
//
import MapKit
import UIKit

class ProgramSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var programSearch: UISearchBar!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var programsTable: UITableView!
    @IBOutlet weak var termFilter: UISegmentedControl!
    
    var programs:NSArray = []

    var fallPrograms:[[String: Any?]] = []
    
    var springPrograms:[[String: Any?]] = []
    
    var summerPrograms:[[String: Any?]] = []
    
    var dataFilter = 0


    
    override func viewDidLoad() {
        super.viewDidLoad()

        termFilter.layer.borderWidth = 1.5
        let borderColor =  UIColor(red: 26/255, green: 37/255, blue: 114/255, alpha: 1)
        termFilter.layer.borderColor = borderColor.cgColor
        getData()

    
        
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        
        switch termFilter.selectedSegmentIndex {
            
        case 0:
            print("Fall")
            dataFilter = 0
        case 1:
            print("Spring")
            dataFilter = 1
        case 2:
            print("Summer")
            dataFilter = 2
        case 3:
            print("All")
            dataFilter = 3
        default:
            print("All")
            dataFilter = 3
        }
        self.programsTable.reloadData()
    }
    

    
    
    func segmentArray(){
        let i = programs.count
        print(i)
        var k = 0;
        fallPrograms = []
        springPrograms = []
        summerPrograms = []
       
        while k < i
        {
            let mainData = programs[k] as? [String:Any]

            let term = mainData?["term"] as? String
            
            if (term == "Fall") //&& k != 1)
            {
                fallPrograms.append(programs[k] as! [String : Any?])
                
            }
            else if (term == "Spring"){
                springPrograms.append(programs[k] as! [String : Any?])
            }
            
            else if (term == "Summer"){
                summerPrograms.append(programs[k] as! [String : Any?])
            }
            
            k += 1
        }

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return programs.count
        switch dataFilter {
        case 0: return fallPrograms.count
        case 1: return springPrograms.count
        case 2: return summerPrograms.count
        default: return programs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let mainData = programs[indexPath.row] as? [String:Any]
//        cell.textLabel?.text = mainData?["p_name"] as? String
//        return cell
        

        
        
        var title: String?
        switch dataFilter {
        case 0:
            let fallData = fallPrograms[indexPath.row]
            title = fallData["p_name"] as? String
        case 1:
            let springData = springPrograms[indexPath.row]
            title = springData["p_name"] as? String
        case 2:
            let summerData = summerPrograms[indexPath.row]
            title = summerData["p_name"] as? String
        case 3:
            title = mainData?["p_name"] as? String
        default:
            title = mainData?["p_name"] as? String
        }
        cell.textLabel?.text = title
        
        
        return  cell
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        switch dataFilter {
        case 0:
            let fallData = fallPrograms[indexPath.row]
            p_id = (fallData["p_id"] as? String)!
        case 1:
            let springData = springPrograms[indexPath.row]
            p_id = (springData["p_id"] as? String)!
        case 2:
            let summerData = summerPrograms[indexPath.row]
            p_id = (summerData["p_id"] as? String)!
        case 3:
            let mainData = programs[indexPath.row] as? [String:Any]
            p_id = (mainData?["p_id"] as? String)!
        default:
            let mainData = programs[indexPath.row] as? [String:Any]
            p_id = (mainData?["p_id"] as? String)!
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProgramVC") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getData(){
        let url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/getAllPrograms.php?email=\(s_email)")
        let data = NSData(contentsOf: url! as URL)
        programs = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        
        segmentArray()
        
        setMap()

        programsTable.reloadData()
        
        
    }
    var filteredPrograms: [String]?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    var locationManager = CLLocationManager()
    var locations : [MKPointAnnotation] = []

    func setHostLocation(longitude: Double, latitude: Double, location: String, university: String) -> Void{
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let host = MKPointAnnotation()
        host.coordinate = CLLocationCoordinate2DMake(longitude, latitude)
        host.title = university
        host.subtitle = location
        
        
        
        locations.append(host)
        
        // Do any additional setup after loading the view.
        
//        let myRegion = MKCoordinateRegionMakeWithDistance(host.coordinate, 1000, 1000)
//        map.setRegion(myRegion, animated: true)
        
    }
    
    func setMap(){
        var i = 0

        while i < programs.count {
            let programData = programs[i] as? [String:Any]

            let long = (programData?["host_longitude"] as! NSString).doubleValue
            let lat = (programData?["host_latitude"] as! NSString).doubleValue
            let hostU = programData?["host_name"] as? String
            let place = (programData?["host_city"] as? String)! + ", " + (programData?["host_country"] as? String)!
            setHostLocation(longitude: long, latitude: lat, location: place, university: hostU!)
            
            i = i + 1
        }
        print("LOCATIONS:")
        print(locations)
        map.addAnnotations(locations)

    }
    
        
    }


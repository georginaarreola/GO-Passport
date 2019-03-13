//
//  ProgramViewController.swift
//  GO Passport App
//
//  Created by Eva Arreola on 5/1/18.
//  Copyright © 2018 Geo. All rights reserved.
//
import MapKit
import UIKit
class ProgramViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var lblProgramName: UILabel!
    @IBOutlet weak var lblHostUniversity: UILabel!
    @IBOutlet weak var lblCityCountry: UILabel!
    @IBOutlet weak var lblTerm: UILabel!
    @IBOutlet weak var lblAdvisor: UILabel!
    @IBOutlet weak var txtOverview: UITextView!
    @IBOutlet weak var mapLocation: MKMapView!
    
    @IBOutlet weak var imgFirstStar: UIImageView!
    @IBOutlet weak var imgSecondStar: UIImageView!
    @IBOutlet weak var imgThirdStar: UIImageView!
    @IBOutlet weak var imgFourthStar: UIImageView!
    @IBOutlet weak var imgFifthStar: UIImageView!
    //icon_emptyStar & icon_filledStar
    
    
    var programValues:NSArray = []
    var locationManager = CLLocationManager()

    var applyURL = ""
    var apptURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }

    @IBAction func btnAddddProgram(_ sender: UIButton) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/saveStamp.php")! as URL)
        request.httpMethod = "POST"
        let postString = "s_id=\(s_id)&p_id=\(p_id)&rating=5"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print("error =\(error!)")
                return
            }
            print("response =\(response!)")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString!)")
            
            DispatchQueue.main.async() {
                let responseString = responseString!.trimmingCharacters(in: .whitespaces)
                if (responseString == "Success")
                {
                    
                    let alertController = UIAlertController(title: "Stamp Added", message: "Stamp Added", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }// end if for success
                else{
                    
                    
                    
                    let alertController = UIAlertController(title: "Wait!", message: "You already have this stamp.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion:nil)
                }// end else
                
            }// end dispatch queue sync
            
        }// end of task
        task.resume()
    }
    
    @IBAction func btnApply(_ sender: UIButton) {
        UIApplication.shared.open((NSURL(string: applyURL)! as URL), options: [:], completionHandler: nil)
    }
    
    @IBAction func btnMakeAppointment(_ sender: UIButton) {
        UIApplication.shared.open((NSURL(string: apptURL)! as URL), options: [:], completionHandler: nil)

    }
    
    func getData()
    {
        
        let url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/getProgramData.php?programID=\(p_id)")
        let data = NSData(contentsOf: url! as URL)
        self.programValues = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        print("PROGRAM VALUES:")
        print(self.programValues)
        setData()
        
    }
    
    func setData()
    {
        
        let studentData = programValues[0] as? [String:Any]
        let advisor = studentData?["advisor"] as? String
        let name = studentData?["p_name"] as? String
        let term = studentData?["term"] as? String
        let city = studentData?["host_city"] as? String
        let country = studentData?["host_country"] as? String
        let hostUniversity = studentData?["host_name"] as? String
        let hostLatitude = (studentData?["host_latitude"] as! NSString).doubleValue
        let hostLongitude = (studentData?["host_longitude"] as! NSString).doubleValue
        let overview = studentData?["overview"] as? String
        applyURL = (studentData?["apply_url"] as! NSString) as String
        apptURL = (studentData?["appointment_url"] as! NSString) as String
        let mapLocation = city! + " " + country!
        lblProgramName.text! = name!
        lblAdvisor.text! = advisor!
        lblTerm.text! = term!
        lblCityCountry.text! = (studentData?["cost"] as? String)!
        lblHostUniversity.text! = hostUniversity!
        txtOverview.text! = overview!
        
        setHostLocation(longitude: hostLatitude, latitude: hostLongitude, location: mapLocation, university: hostUniversity!)
        
    }
    
    func setHostLocation(longitude: Double, latitude: Double, location: String, university: String) -> Void{
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let host = MKPointAnnotation()
        host.coordinate = CLLocationCoordinate2DMake(longitude, latitude)
        host.title = university
        host.subtitle = location
        
    
        
        let locations = [host]
        
        mapLocation.addAnnotations(locations)
        // Do any additional setup after loading the view.
        
        let myRegion = MKCoordinateRegionMakeWithDistance(host.coordinate, 1000, 1000)
        mapLocation.setRegion(myRegion, animated: true)
    
    }


}

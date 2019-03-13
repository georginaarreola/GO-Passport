//
//  universityPickerViewController.swift
//  GO Passport App
//
//  Created by Eva Arreola on 4/24/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit

class UniversityPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pkrUniversities: UIPickerView!
    
    var universities:NSArray = []
    var universitiesDictArray: [[String:Any?]] = []

   // var mainData:NSDictionary = [String:Any?]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:26/255, green: 37/255, blue: 114/255, alpha: 1)
        getData()


        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return universities[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return universities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        print("ROWWWWW: ", row)
        
//        for dictionary in universitiesDictArray
//        {
//            print(dictionary)
//        }
        
     //   var rowDictionary = universitiesDictArray[row]
        
        //print("ROW DICTIONARYYYY", rowDictionary)
        
        let mainData = universities[row] as? [String:Any]

        u_id = Int((mainData?["u_id"] as! NSString).intValue)

        print("U_IDDDDDDD: ",u_id)
      //  print(rowDictionary)
        
     //   print(universitiesDictArray)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
       
        let mainData = universities[row] as? [String:Any]
        universitiesDictArray.append(mainData!)
        let attributedString = NSAttributedString(string: (mainData?["u_name"] as? String)!, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white
            ])
        return attributedString
        
    }
    
    func getData()
    {
        let url = NSURL(string:"https://www.earreola.create.stedwards.edu/finalProject/passportPHP/getUniversities.php")
        let data = NSData(contentsOf: url! as URL)
        universities = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        print("UNIVERSITIEEEEES")
        print(universities)
        pkrUniversities.reloadAllComponents()

    }

}

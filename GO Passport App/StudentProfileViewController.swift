//
//  StudentProfileViewController.swift
//  GO Passport App
//
//  Created by Eva Arreola on 4/24/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit


class StampTableViewCell: UITableViewCell{
    @IBOutlet weak var imgStamp: UIImageView!

    
    
}

class StampTableViewCellRight: UITableViewCell{
    @IBOutlet weak var imgStampRight: UIImageView!

    
}

var p_id = "1"

class StudentProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var searchIcon: UIBarButtonItem!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUniversity: UILabel!
    
    
    var studentValues:NSArray = []
    
    
    var savedPrograms:NSArray = []
    
    var leftPrograms:[[String: Any?]] = []
    
    var rightPrograms:[[String: Any?]] = []

   
    func splitArray() {
        let i = savedPrograms.count;
        print(i)
        var k = 0;
        leftPrograms = []
        rightPrograms = []
        while k < i
        {
            
            if (k == 0 || k % 2 == 0) //&& k != 1)
            {
                print(savedPrograms[k])
                leftPrograms.append(savedPrograms[k] as! [String : Any?])



            }
            else{
                rightPrograms.append(savedPrograms[k] as! [String : Any?])


            }
            
            k += 1
        }
        print("LEFFFT")
        print(leftPrograms)
        print("RIGHT")
        print(rightPrograms)
        
        
    }



    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  getData()
        imgProfilePicture.layer.cornerRadius = imgProfilePicture.frame.size.width / 2;
        imgProfilePicture.clipsToBounds = true
        
        getProfilePicture()
        
    }
    override func viewWillAppear(_ animated: Bool)
        {
            getData()
            
            getProfilePicture()
        }
    
    func getProfilePicture()
    {
        let url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/profilePictures/\(s_email)/user-profile.jpg")
        DispatchQueue.global(qos: .background).async {
            
            let imageData = NSData(contentsOf: url! as URL)
            if(imageData != nil)
            {
                DispatchQueue.main.async(execute: {
                    self.imgProfilePicture.image = UIImage(data: imageData! as Data)
                })
            }
            
        }
    }
    
    func getData()
    {

        var url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/getStudentProfileData.php?email=\(s_email)")
        var data = NSData(contentsOf: url! as URL)
        self.studentValues = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        print("STUDENT VALUES:")
        print(self.studentValues)
        
        setData()

        
        url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/getSavedData.php?s_id=\(s_id)")
        data = NSData(contentsOf: url! as URL)
        self.savedPrograms = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        print("SAVED PROGRAMS:")
        print(self.savedPrograms)
        splitArray()
        leftTableView.reloadData()
        rightTableView.reloadData()
        

    }
    
    func setData()
    {

        let studentData = studentValues[0] as? [String:Any]

        let firstName = studentData?["s_f_name"] as? String
        let lastName = studentData?["s_l_name"] as? String
        let university = studentData?["u_name"] as? String
        s_id = (studentData?["s_id"] as? String)!
        lblName.text! = firstName! + " " + lastName!
        lblUniversity.text! = university!
        
        
    }
    @IBAction func barBtnSearch(_ sender: UIBarButtonItem) {
      
    }
    
    
    @IBAction func btnCamera(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "QRVC") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
        

        
    }
    
    //STAMPS TABLES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tableView == self.rightTableView) ? rightPrograms.count : leftPrograms.count
        


    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

        if(tableView == self.rightTableView)
        {
            let cell : StampTableViewCellRight = tableView.dequeueReusableCell(withIdentifier: "rightCell") as! StampTableViewCellRight

            let data = rightPrograms[indexPath.row]
            
            p_id = (data["p_id"] as? String)!
            

            let url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/programStamps/\(p_id)/stamp.jpg")
            DispatchQueue.global(qos: .background).async
            {
                
                let imageData = NSData(contentsOf: url! as URL)
                if(imageData != nil)
                {
                    DispatchQueue.main.async(execute:
                        {
                        cell.imgStampRight?.image =  UIImage(data: imageData! as Data)
                            cell.imgStampRight?.contentMode = .scaleAspectFit

                        })
                }
                
            }
            return cell
            
        }
        else //if(tableView == self.leftTableView)
        {
            let cell: StampTableViewCell = tableView.dequeueReusableCell(withIdentifier: "leftCell") as! StampTableViewCell
            
            let data = leftPrograms[indexPath.row]
            
            p_id = (data["p_id"] as? String)!
            

            let url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/programStamps/\(p_id)/stamp.jpg")
            DispatchQueue.global(qos: .background).async
                {
                    
                    let imageData = NSData(contentsOf: url! as URL)
                    if(imageData != nil)
                    {
                        DispatchQueue.main.async(execute:
                            {
                            cell.imgStamp?.image =  UIImage(data: imageData! as Data)
                                cell.imgStamp?.contentMode = .scaleAspectFit
                                
                            })
                    }
                    
                }
            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if(tableView == self.rightTableView)
        {
            let data = rightPrograms[indexPath.row]
            
            p_id = (data["p_id"] as? String)!
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProgramVC") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
           // performSegue(withIdentifier: "programSegue", sender: indexPath)
            
        }
        else if(tableView == self.leftTableView)
        {
            let data = leftPrograms[indexPath.row]
            
            p_id = (data["p_id"] as? String)!
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProgramVC") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
    //        performSegue(withIdentifier: "programSegue", sender: indexPath)
//
        }
        
        
    }




}

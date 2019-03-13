//
//  ContactViewController.swift
//  GO Passport App
//
//  Created by Eva Arreola on 5/3/18.
//  Copyright © 2018 Geo. All rights reserved.
//
import Foundation
import MessageUI
import UIKit

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    var representativeValues:NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfilePicture.layer.cornerRadius = imgProfilePicture.frame.size.width / 2;
        imgProfilePicture.clipsToBounds = true
        getData()
        getProfilePicture()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnEmail(_ sender: UIButton)  {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([r_email])
        mailComposerVC.setSubject("Study Abroad Program")
        mailComposerVC.setMessageBody("   ", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnCall(_ sender: UIButton) {
        
        let cell = "9157312095"
        guard let number = URL(string: "tel://" + cell) else { return }
        UIApplication.shared.open(number)

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        
        getProfilePicture()
    }
    
    func getProfilePicture()
    {
        let url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/profilePictures/\(r_email)/user-profile.jpg")
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
        
        let url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/getRepresentativeProfileData.php?email=\(r_email)")
        let data = NSData(contentsOf: url! as URL)
        self.representativeValues = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        print("REPRESENTATIVE VALUES:")
        print(representativeValues)
        setData()
        
    }
    // var r_id = 1;
    var r_id_txt = ""
    func setData()
    {
        
        let representativeData = representativeValues[0] as? [String:Any]
        
        let firstName = representativeData?["r_f_name"] as? String
        let lastName = representativeData?["r_l_name"] as? String
        //    r_id = (representativeData?["r_id"] as? Int)!
        r_id_txt = (representativeData?["r_id"] as? String)!
        lblName.text = firstName! + " " + lastName!
        lblEmail.text = representativeData?["r_email"] as? String
        lblPhone.text = representativeData?["r_phone_number"] as? String
        
        
    }
    
    
}

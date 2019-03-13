//
//  ProviderProfileViewController.swift
//  GO Passport App
//
//  Created by Eva Arreola on 4/25/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit

class ProviderProfileViewController: UIViewController {

    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    
    var representativeValues:NSArray = []

    var qrcodeImage: CIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        self.navigationController?.navigationBar.barTintColor = UIColor(red: 220/255, green: 189/255, blue: 35/255, alpha: 1)
        imgProfilePicture.layer.cornerRadius = imgProfilePicture.frame.size.width / 2;
        imgProfilePicture.clipsToBounds = true
        
        getProfilePicture()
       getQRCode()
        // Do any additional setup after loading the view.
    }

    func getQRCode()
    {
        let data = r_id_txt.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)

        let filter = CIFilter(name: "CIQRCodeGenerator")

        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")

        qrcodeImage = filter?.outputImage

        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height

        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))


        imgQRCode.image = convert(cmage: transformedImage)//UIImage(CIImage: transformedImage)

    }

    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        getData()
        
        getProfilePicture()
       getQRCode()
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
        lblName.text! = firstName! + " " + lastName!
        
        
    }

}

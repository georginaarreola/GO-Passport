//
//  StudentAccountViewController.swift
//  GO Passport App
//
//  Created by COSC3326 on 4/23/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
var s_email = ""
var s_id = ""
var u_id = 1
class StudentAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   

    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
       imgProfilePicture.layer.cornerRadius = imgProfilePicture.frame.size.width / 2;
       imgProfilePicture.clipsToBounds = true
        print(u_id)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:26/255, green: 37/255, blue: 114/255, alpha: 1)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func btnCamera(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            if UIImagePickerController.isCameraDeviceAvailable(.front){
                imagePicker.cameraDevice = .front
            }
            else{
                imagePicker.cameraDevice = .rear
            }
        }
        else{
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func btnCameraRoll(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgProfilePicture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
//        saveProfilePicture()
        
    }
    
    func saveProfilePicture()
    {
        let myUrl = URL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/uploadProfileImage.php");
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST";
        
        
        let param = [
            "s_email" : s_email
        ]
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imgProfilePicture.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        


        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            
            DispatchQueue.main.async
                {
                  //  MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            }
            
            if error != nil {
                // Display an alert message
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                DispatchQueue.main.async
                    {
                        
                        if let parseJSON = json {
                            // let userId = parseJSON["userId"] as? String
                            
                            // Display an alert message
                            let userMessage = parseJSON["message"] as? String
                            self.displayAlertMessage(userMessage!)
                        } else {
                            // Display an alert message
                            let userMessage = "Could not upload image at this time"
                            self.displayAlertMessage(userMessage)
                        }
                }
            } catch
            {
                print(error)
            }
            
        }
        
        task.resume()
        
        
        
    }
    
    func generateBoundaryString() -> String {
        // Create and return a unique string.
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        var body = Data();
        
        
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                body.append(Data("\(value)\r\n".utf8))
                body.append(Data("--\(boundary)\r\n".utf8))

            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
        body.append(imageDataKey)
        body.append(Data("\r\n".utf8))
        
        
        
        body.append(Data("--\(boundary)\r\n".utf8))

        return body as Data
    }
    
    func displayAlertMessage(_ userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated: true, completion: nil)
        
    }

    
    @IBAction func btnCreateProfile(_ sender: UIButton) {
        if(txtFirstName.text! == "" || txtFirstName.text! == "" || txtEmail.text! == "" || txtPassword.text! == "")
        {
            let ac = UIAlertController(title: "Warning!", message: "You didn't fill out your entire passport form. Please complete all empty fields.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        else{
            let request = NSMutableURLRequest(url: NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/registerStudent.php")! as URL)
            request.httpMethod = "POST"
            let postString = "firstName=\(txtFirstName.text!)&lastName=\(txtLastName.text!)&email=\(txtEmail.text!)&password=\(txtPassword.text!)&universityID=\(u_id)"
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
                        s_email = self.txtEmail.text!
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "LogInVC") as UIViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                        //self.performSegue(withIdentifier: "createProfileSegue", sender: self)
                        s_email = self.txtEmail.text!

                        self.saveProfilePicture()

//                        let alertController = UIAlertController(title: "Access Granted", message: "Welcome to our super secure app", preferredStyle: UIAlertControllerStyle.alert)
//                        alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alertController, animated: true, completion: nil)
                    }// end if for success
                    else{
                        let alertController = UIAlertController(title: "Access Denied", message: "Incorrect username or password.", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertController, animated: true, completion:nil)
                    }// end else
                            self.txtFirstName.text = ""
                            self.txtLastName.text = ""
                            self.txtEmail.text = ""
                            self.txtPassword.text = ""
                            self.imgProfilePicture.image = UIImage(named: "noPicture")
                }// end dispatch queue sync
                
            }// end of task
            task.resume()
        }

    }
    
    

}

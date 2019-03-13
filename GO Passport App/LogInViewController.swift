//
//  LogInViewController.swift
//  GO Passport App
//
//  Created by Eva Arreola on 4/24/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
var r_email = ""
class LogInViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red:26/255, green: 37/255, blue: 114/255, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnLogIn(_ sender: UIButton) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/selectStudent.php")! as URL)
        request.httpMethod = "POST"
        let postString = "email=\(txtEmail.text!)&password=\(txtPassword.text!)"
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
                    let vc = storyboard.instantiateViewController(withIdentifier: "StudentProfileVC") as UIViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                   
                    self.txtEmail.text = ""
                    self.txtPassword.text = ""

                }// end if for success
                else{
                    self.checkIfPRovider()
                }// end else

            }// end dispatch queue sync
            
        }// end of task
        task.resume()

        
    }
    
    func checkIfPRovider() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/selectRepresentative.php")! as URL)
        request.httpMethod = "POST"
        let postString = "email=\(txtEmail.text!)&password=\(txtPassword.text!)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task2 = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
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
                    r_email = self.txtEmail.text!
                    print(r_email)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "RepProfileVC") as UIViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }// end if for success
                else{
                    let alertController = UIAlertController(title: "Access Denied", message: "Incorrect username or password.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion:nil)
                }// end else
                self.txtEmail.text = ""
                self.txtPassword.text = ""
            }// end dispatch queue sync
            
        }// end of task
        task2.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

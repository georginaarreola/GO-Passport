//
//  ContactsViewController.swift
//  GO Passport App
//
//  Created by COSC3326 on 4/24/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit
class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var contactsTable: UITableView!
    var contacts:NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
     }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        getData()
    }
    func getData()
    {
        let url = NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/getContacts.php?email=\(s_email)")
        let data = NSData(contentsOf: url! as URL)
        contacts = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
        print(contacts)
        
        contactsTable.reloadData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let mainData = contacts[indexPath.row] as? [String:Any]
        let firstName = mainData?["r_f_name"] as? String
        let lastName = mainData?["r_l_name"] as? String
   
        cell.textLabel?.text = firstName! + " " + lastName!
    
    
        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = contacts[indexPath.row] as? [String:Any?]
        r_email = (data?["r_email"] as? String)!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "contactVC") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
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

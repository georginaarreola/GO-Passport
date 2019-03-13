//
//  ViewController.swift
//  GO Passport App
//
//  Created by COSC3326 on 4/23/18.
//  Copyright © 2018 Geo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
  //       UINavigationBar.appearance().barTintColor = .clear
        self.navigationController?.view.backgroundColor = .clear
    }
    @IBAction func btnCreateProfile(_ sender: UIButton) {

        
    }
    
        override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
            //Use UIScrollView's contentInsetAdjustmentBehavior instead
      //      self.navigationController?.navigationBar.
    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = false
//   //     self.navigationController?.view.backgroundColor = .clear
//    }



}


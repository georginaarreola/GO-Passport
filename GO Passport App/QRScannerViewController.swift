//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
var stampAdded = false
class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView?
    @IBOutlet weak var btnStop: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Move the message label and top bar to the front
        self.view.bringSubview(toFront: btnStop)
        self.view.bringSubview(toFront: messageLabel)
        self.view.bringSubview(toFront: topbar)
        
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            qrCodeFrameView = UIView()
            

            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
            stampAdded = true

        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    @IBAction func btnStop(_ sender: UIButton) {
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.bringSubview(toFront: btnStop)
        self.view.bringSubview(toFront: messageLabel)
        self.view.bringSubview(toFront: topbar)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        // Initialize QR Code Frame to highlight the QR code
        
        //        let ac = UIAlertController(title: "Stamp added!", message: "You can now access the program from your passport.", preferredStyle: .alert)
        //        ac.addAction(UIAlertAction(title: "OK", style: .default))
        //        present(ac, animated: true)
        stampAdded = true
        
        var id = ""
        id = code
        print("Program ID: ", id)
        
        print(code)
        
        getStamp(programID: id)
        
    }
    
    func getStamp(programID: String) ->Void {
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.earreola.create.stedwards.edu/finalProject/passportPHP/saveStamp.php")! as URL)
        request.httpMethod = "POST"
        let postString = "s_id=\(s_id)&p_id=\(programID)&rating=5"
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
                    
                    let alertController = UIAlertController(title: "Stamp Added", message: "Stamp Added!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }// end if for success
                else{
                    
                    
                    
                    let alertController = UIAlertController(title: "Invalid QR code", message: "Your university does not offer this program or the QR code could not be read", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion:nil)
                }// end else

            }// end dispatch queue sync
            
        }// end of task
        task.resume()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
   
    
}

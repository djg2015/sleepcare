//
//  AddDeviceViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/26/16.
//
//
import AVFoundation
import UIKit

class AddDeviceViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scanLabel: UILabel!
    
    @IBOutlet weak var topgreyView: UIView!
    @IBOutlet weak var leftgreyView: UIView!
    @IBOutlet weak var bottongreyView: UIView!
    @IBOutlet weak var rightgreyView: UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var qrCode:String = ""
    var parentController:MyDeviceViewController!
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConfirmPatientInfo"{
            let destinationVC = segue.destinationViewController as! ConfirmPatientInfoController
           
            destinationVC.qrcode = self.qrCode
            destinationVC.parentController = self
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        currentController = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //---------- Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        //--------- Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        var captureMetadataOutput = AVCaptureMetadataOutput()
        //设置扫描区域（原点在右上角，宽高相反,（0，0，1，1））
        captureMetadataOutput.rectOfInterest = CGRectMake((SCREENHIGHT-160)/2/SCREENHIGHT,((SCREENWIDTH-160)/2)/SCREENWIDTH,160/SCREENHIGHT,160/SCREENWIDTH)
        
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        //---------- Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.frame = CGRectMake(0, 0,UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
        
        self.view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
        
       
        view.bringSubviewToFront(scanView)
        view.bringSubviewToFront(topView)
        view.bringSubviewToFront(topgreyView)
        view.bringSubviewToFront(leftgreyView)
        view.bringSubviewToFront(bottongreyView)
        view.bringSubviewToFront(rightgreyView)
        view.bringSubviewToFront(scanLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //解析二维码
    func captureOutput(captureOutput: AVCaptureOutput!,
        didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection
        connection: AVCaptureConnection!) {
            
            // Check if the metadataObjects array is not nil and it contains at least one object.
            if metadataObjects == nil || metadataObjects.count == 0 {
                //   qrCodeFrameView?.frame = CGRectZero
                //     messageLabel.text = "二维码识别中....."
                return
            }
            
            // Get the metadata object.如果是二维码，则获取边框并解析内容
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if metadataObj.type == AVMetadataObjectTypeQRCode {
                // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
                let barCodeObject =
                videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj
                    as AVMetadataMachineReadableCodeObject) as!
                AVMetadataMachineReadableCodeObject
                //     qrCodeFrameView?.frame = barCodeObject.bounds
                
                
                
                //获取解析的内容,获取到设备二维码
                if metadataObj.stringValue != nil {
                    
                    
                    self.qrCode = metadataObj.stringValue
                    captureSession?.stopRunning()
                    
                    
                    //获取到二维码，绑定老人和设备
                    try {
                        ({
                            let loginname = SessionForSingle.GetSession()?.User?.LoginName
                            
                            let result = SleepCareForSingle().BindEquipmentofUser(self.qrCode,loginName:loginname!)
                            //将qrcode送到“老人信息”页面
                            if result.Result{
                                self.performSegueWithIdentifier("ConfirmPatientInfo", sender: self)
                            }
                            else{
                               showDialogMsg(ShowMessage(MessageEnum.BindFail))
                            }
                            
                            },
                            catch: { ex in
                                //异常处理
                                handleException(ex,showDialog: true)
                            },
                            finally: {
                                
                            }
                        )}

                  
                }
            }
    }
    
    
  
  
   
}

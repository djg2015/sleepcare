//
//  ScanViewController.swift
//  
//
//  Created by Qinyuan Liu on 6/1/16.
//
//
import AVFoundation
import UIKit

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {
 //    @IBOutlet weak var messageLabel:UILabel!
     @IBOutlet weak var scanView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scanLabel: UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var qrCode:String = "1111111"
    var registController:RootRegistViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "scantoequipmentinfo" {
            let destinationVC = segue.destinationViewController as! EquipmentViewController
           destinationVC.qrcode = self.qrCode
            if self.registController != nil{
            destinationVC.registcontroller = self.registController
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
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
        let captureMetadataOutput = AVCaptureMetadataOutput()
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
    
        
        // Move the message label to the top view
     //   view.bringSubviewToFront(messageLabel)
        
        
        view.bringSubviewToFront(scanView)
        view.bringSubviewToFront(topView)
        view.bringSubviewToFront(scanLabel)
        
        //--------------- Initialize QR Code Frame to highlight the QR code
        //        qrCodeFrameView = UIView()
        //        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        //        //当检测到二维码时，我们再改变它的尺寸，那么它就会变成一个绿色的方框了
        //        qrCodeFrameView?.layer.borderWidth = 2
        //        self.view.addSubview(qrCodeFrameView!)
        //       self.view.bringSubviewToFront(qrCodeFrameView!)
        
         self.BackToRegistWithQR()
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
                    
                    
                    //获取到二维码，将qrcode送回注册页面进行验证，返回注册页面
                    self.BackToRegistWithQR()
                }
            }
    }
    
    
    func BackToRegistWithQR(){
        try{
            ({
                self.registController.qrcode = self.qrCode
                self.navigationController?.popViewControllerAnimated(false)
                
                },
                catch: {ex in
                    //异常处理
                    handleException(ex,showDialog: true)
               
              
                },
                finally: {
                }
            )}
        
    }
    
    
    
}

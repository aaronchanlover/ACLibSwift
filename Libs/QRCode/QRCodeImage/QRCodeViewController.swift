//
//  ScannerViewController.swift
//  QRCode
//
//  Created by aaron on 16/5/5.
//  Copyright © 201y年 aaron. All rights reserved.
//

/*
 初始化Controller时传入结果闭包，闭包中返回扫描的值
 QRCodeViewController(closure:{ [weak self] result in
    guard let strongSelf = self else { return }
        strongSelf.scanresultLabel.text=result
    }
 )
 */

import UIKit
import AVFoundation

public typealias ScanResultType = (String) -> Void

open class QRCodeViewController: UIViewController{
    
    public var returnScanResult:ScanResultType?
    
    public convenience init(closure : ScanResultType?){
        self.init()
        self.returnScanResult=closure
    }
    //相机显示视图
    let cameraView = QRCodeScanBackgroundView(frame: UIScreen.main.bounds)
    
    let captureSession = AVCaptureSession()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫一扫"
        self.view.backgroundColor = UIColor.black
        //设置导航栏
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(QRCodeViewController.selectPhotoFormPhotoLibrary(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        self.view.addSubview(cameraView)
        
        //初始化捕捉设备（AVCaptureDevice），类型AVMdeiaTypeVideo
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        let input :AVCaptureDeviceInput
        
        //创建媒体数据输出流
        let output = AVCaptureMetadataOutput()
        
        //捕捉异常
        do{
            //创建输入流
            input = try AVCaptureDeviceInput(device: captureDevice)
            
            //把输入流添加到会话
            captureSession.addInput(input)
            
            //把输出流添加到会话
            captureSession.addOutput(output)
        }catch {
            print("异常")
        }
        
        //创建串行队列
        let dispatchQueue = DispatchQueue(label: "queue", attributes: [])
        
        //设置输出流的代理
        output.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        
        //设置输出媒体的数据类型
        output.metadataObjectTypes = NSArray(array: [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]) as [AnyObject]
        
        //创建预览图层
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //设置预览图层的填充方式
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //设置预览图层的frame
        videoPreviewLayer?.frame = cameraView.bounds
        
        //将预览图层添加到预览视图上
        cameraView.layer.insertSublayer(videoPreviewLayer!, at: 0)
        
        // 1.获取屏幕的frame
        let viewRect = self.view.frame
        //获取扫描框的frame
        let containerRect = cameraView.barcodeView.frame
        //可扫描范围是比例（0~1）
        let x = containerRect.origin.y / viewRect.height;
        let y = containerRect.origin.x / viewRect.width;
        let width = containerRect.height / viewRect.height;
        let height = containerRect.width / viewRect.width;
        output.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)

        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.scannerStart()
    }
    
    func scannerStart(){
        captureSession.startRunning()
        cameraView.scanning = "start"
    }
    
    func scannerStop() {
        captureSession.stopRunning()
        cameraView.scanning = "stop"
    }
    
    
    
    //从相册中选择图片
    func selectPhotoFormPhotoLibrary(_ sender : AnyObject){
        let picture = UIImagePickerController()
        picture.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picture.delegate = self
        self.present(picture, animated: true, completion: nil)
        
    }
    
    
}

extension QRCodeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //选择相册中的图片完成，进行获取二维码信息
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage]
        
        let imageData = UIImagePNGRepresentation(image as! UIImage)
        
        let ciImage = CIImage(data: imageData!)
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        
        let array = detector?.features(in: ciImage!)
        
        let result : CIQRCodeFeature = array!.first as! CIQRCodeFeature
        
        
        if((self.returnScanResult != nil)){
            self.returnScanResult!(result.messageString ?? String())
            
        }
        if(self.navigationController != nil){
            self.navigationController!.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }

}


extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate{
    //扫描代理方法
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        print("_______")
        
        if metadataObjects != nil && metadataObjects.count > 0 {
            let metaData : AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            print(metaData.stringValue)
            
            DispatchQueue.main.async(execute: {
                
                if((self.returnScanResult != nil)){
                    self.returnScanResult!(metaData.stringValue)

                }
                if(self.navigationController != nil){
                    self.navigationController!.popViewController(animated: true)
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            })
            captureSession.stopRunning()
        }
        
    }

}

//
//  AppearanceCodeReader.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 7/29/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit
import AVFoundation

class AppearanceCodeReader: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
            print("Error: could not init AVCaptureDeviceInput")
            return
        }
        
        
//        for (AVCaptureDevice *device in devices) {
// 
//        NSLog(@"Device name: %@", [device localizedName]);
//     
//        if ([device hasMediaType:AVMediaTypeVideo]) {
//     
//            if ([device position] == AVCaptureDevicePositionBack) {
//                NSLog(@"Device position : back");
//            }
//            else {
//                NSLog(@"Device position : front");
//            }
//        }

//if ([currentDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
//    CGPoint autofocusPoint = CGPointMake(0.5f, 0.5f);
//    [currentDevice setFocusPointOfInterest:autofocusPoint];
//    [currentDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
//}

//AVCaptureStillImageOutput 

//AVCaptureSession *captureSession = <#Get a capture session#>;
//AVCaptureMovieFileOutput *movieOutput = <#Create and configure a movie output#>;
//if ([captureSession canAddOutput:movieOutput]) {
//    [captureSession addOutput:movieOutput];
//}
//else {
//    // Handle the failure.
//}


        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        session.startRunning()

    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
//    AVMetadataOutput.type
    
//        for metadata in metadataObjects {
//        if metadata.type == barcodeType {
//                            barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as AVMetadataMachineReadableCodeObject)
//                            highlightViewRect = barCodeObject.bounds
//                            detectionString = (metadata as AVMetadataMachineReadableCodeObject).stringValue
//        self.session.stopRunning()

//        for current in metadataObjects {
//            if let _readableCodeObject = current as? AVMetadataMachineReadableCodeObject {
//                if _readableCodeObject.type == AVMetadataObjectTypeQRCode {
//                    stopScanning()
//                    
//                    let scannedResult: String = _readableCodeObject.stringValue
//                    
//                    if let _completionBlock = completionBlock {
//                        _completionBlock(scannedResult)
//                    }
//                    
//                    delegate?.reader(self, didScanResult: scannedResult)
//                }
//            }
//        }
    }

//    private var cameraView: ReaderView = ReaderView()
//    private var cancelButton: UIButton = UIButton()
//    private var switchCameraButton: SwitchCameraButton?
//    
//    private var defaultDevice: AVCaptureDevice? = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//    private var frontDevice: AVCaptureDevice?   = {
//        for device in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) {
//            if let _device = device as? AVCaptureDevice {
//                if _device.position == AVCaptureDevicePosition.Front {
//                    return _device
//                }
//            }
//        }
//        
//        return nil
//        }()
//    private lazy var defaultDeviceInput: AVCaptureDeviceInput? = {
//        if let _defaultDevice = self.defaultDevice {
//            return AVCaptureDeviceInput(device: _defaultDevice, error: nil)
//        }
//        
//        return nil
//        }()
//    private lazy var frontDeviceInput: AVCaptureDeviceInput?  = {
//        if let _frontDevice = self.frontDevice {
//            return AVCaptureDeviceInput(device: _frontDevice, error: nil)
//        }
//        
//        return nil
//        }()
//    private var metadataOutput: AVCaptureMetadataOutput       = AVCaptureMetadataOutput()
//    private var session: AVCaptureSession                     = AVCaptureSession()
//    private lazy var previewLayer: AVCaptureVideoPreviewLayer = { return AVCaptureVideoPreviewLayer(session: self.session) }()
//    
//    weak var delegate: QRCodeReaderDelegate?
//    var completionBlock: ((String?) -> ())?
//    
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
//    
//    required init(cancelButtonTitle: String) {
//        super.init()
//        
//        configureDefaultComponents()
//        setupUIComponentsWithCancelButtonTitle(cancelButtonTitle)
//        setupAutoLayoutConstraints()
//        
//        view.backgroundColor = UIColor.blackColor()
//        
//        cameraView.layer.insertSublayer(previewLayer, atIndex: 0)
//    }
//    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        startScanning()
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        stopScanning()
//        
//        super.viewWillDisappear(animated)
//    }
//    
//    override func viewWillLayoutSubviews() {
//        previewLayer.frame = view.bounds
//    }
//    
//    // MARK: - Managing the Orientation
//    
//    func orientationDidChanged(notification: NSNotification) {
//        cameraView.setNeedsDisplay()
//        
//        if previewLayer.connection != nil {
//            var interfaceOrientation: UIInterfaceOrientation = .Portrait
//            
//            switch (UIDevice.currentDevice().orientation) {
//            case .LandscapeLeft:
//                interfaceOrientation = .LandscapeRight
//            case .LandscapeRight:
//                interfaceOrientation = .LandscapeLeft
//            case .PortraitUpsideDown:
//                interfaceOrientation = .PortraitUpsideDown
//            default:
//                interfaceOrientation = .Portrait
//            }
//            
//            previewLayer.connection.videoOrientation = QRCodeReader.videoOrientationFromInterfaceOrientation(interfaceOrientation)
//        }
//    }
//    
//    class func videoOrientationFromInterfaceOrientation(interfaceOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
//        switch (interfaceOrientation) {
//        case .LandscapeLeft:
//            return .LandscapeLeft
//        case .LandscapeRight:
//            return .LandscapeRight
//        case .Portrait:
//            return .Portrait
//        default:
//            return .PortraitUpsideDown
//        }
//    }
//    
//    // MARK: - Initializing the AV Components
//    
//    private func setupUIComponentsWithCancelButtonTitle(cancelButtonTitle: String) {
//        cameraView.clipsToBounds = true
//        cameraView.setTranslatesAutoresizingMaskIntoConstraints(false)
//        view.addSubview(cameraView)
//        
//        if let _frontDevice = frontDevice {
//            let newSwitchCameraButton = SwitchCameraButton()
//            newSwitchCameraButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//            newSwitchCameraButton.addTarget(self, action: "switchCameraAction:", forControlEvents: .TouchUpInside)
//            view.addSubview(newSwitchCameraButton)
//            
//            switchCameraButton = newSwitchCameraButton
//        }
//        
//        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//        cancelButton.setTitle(cancelButtonTitle, forState: .Normal)
//        cancelButton.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
//        cancelButton.addTarget(self, action: "cancelAction:", forControlEvents: .TouchUpInside)
//        view.addSubview(cancelButton)
//    }
//    
//    private func setupAutoLayoutConstraints() {
//        let views: [NSObject: AnyObject] = ["cameraView": cameraView, "cancelButton": cancelButton]
//        
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cameraView][cancelButton(40)]|", options: .allZeros, metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cameraView]|", options: .allZeros, metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[cancelButton]-|", options: .allZeros, metrics: nil, views: views))
//        
//        if let _switchCameraButton = switchCameraButton {
//            let switchViews: [NSObject: AnyObject] = ["switchCameraButton": _switchCameraButton]
//            
//            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[switchCameraButton(50)]", options: .allZeros, metrics: nil, views: switchViews))
//            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[switchCameraButton(70)]|", options: .allZeros, metrics: nil, views: switchViews))
//        }
//    }
//    
//    private func configureDefaultComponents() {
//        session.addOutput(metadataOutput)
//        
//        if let _defaultDeviceInput = defaultDeviceInput {
//            session.addInput(defaultDeviceInput)
//        }
//        
//        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
//        if let _availableMetadataObjectTypes = metadataOutput.availableMetadataObjectTypes as? [String] {
//            if _availableMetadataObjectTypes.filter({ $0 == AVMetadataObjectTypeQRCode }).count > 0 {
//                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
//            }
//        }
//        previewLayer.videoGravity          = AVLayerVideoGravityResizeAspectFill
//        
//        if previewLayer.connection != nil && previewLayer.connection.supportsVideoOrientation {
//            previewLayer.connection.videoOrientation = QRCodeReader.videoOrientationFromInterfaceOrientation(interfaceOrientation)
//        }
//    }
//    
//    private func switchDeviceInput() {
//        if let _frontDeviceInput = frontDeviceInput {
//            session.beginConfiguration()
//            
//            if let _currentInput = session.inputs.first as? AVCaptureDeviceInput {
//                session.removeInput(_currentInput)
//                
//                let newDeviceInput = (_currentInput.device.position == .Front) ? defaultDeviceInput : _frontDeviceInput
//                session.addInput(newDeviceInput)
//            }
//            
//            session.commitConfiguration()
//        }
//    }
//    
//    // MARK: - Controlling Reader
//    
//    private func startScanning() {
//        if !session.running {
//            session.startRunning()
//        }
//    }
//    
//    private func stopScanning() {
//        if session.running {
//            session.stopRunning()
//        }
//    }
//    
//    // MARK: - Catching Button Events
//    
//    func cancelAction(button: UIButton) {
//        stopScanning()
//        
//        if let _completionBlock = completionBlock {
//            _completionBlock(nil)
//        }
//        
//        delegate?.readerDidCancel(self)
//    }
//    
//    func switchCameraAction(button: SwitchCameraButton) {
//        switchDeviceInput()
//    }
//    
//    // MARK: - AVCaptureMetadataOutputObjects Delegate Methods
//    
//    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
//        for current in metadataObjects {
//            if let _readableCodeObject = current as? AVMetadataMachineReadableCodeObject {
//                if _readableCodeObject.type == AVMetadataObjectTypeQRCode {
//                    stopScanning()
//                    
//                    let scannedResult: String = _readableCodeObject.stringValue
//                    
//                    if let _completionBlock = completionBlock {
//                        _completionBlock(scannedResult)
//                    }
//                    
//                    delegate?.reader(self, didScanResult: scannedResult)
//                }
//            }
//        }
//    }
}

//protocol QRCodeReaderDelegate: class {
//    func reader(reader: QRCodeReader, didScanResult result: String)
//    func readerDidCancel(reader: QRCodeReader)
//}
//
//  CaptureViewController.swift
//  Armani
//
//  Created by Samahir Adi on 18/12/2019.
//  Copyright © 2019 Samahir Adi. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher

class CaptureViewController: UIViewController {
    
    // MARK: - Variables
    
    var captureSession = AVCaptureSession()
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var photoOutput: AVCapturePhotoOutput?
    
    let cellId = "CustomCollectionViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var captureView: UIView!
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Camera capture
        requestAutorization()
        setupCaptureSession()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        // CollectionView
        setupCollectionView()
        ProductViewModel.shared.getProducts {
            self.productsCollectionView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Methods
    
    func setupCollectionView() {
        self.productsCollectionView.delegate = self
        self.productsCollectionView.dataSource = self
        let nib = UINib(nibName: self.cellId, bundle: nil)
        self.productsCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.productsCollectionView.allowsSelection = true
        self.productsCollectionView.allowsMultipleSelection = false
    }
    
}

// Video Capture management
extension CaptureViewController {
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .front) {
            return device
        }else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front){
            return device
        } else {
            fatalError("Missing expected camera")
        }
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: setupDevice())
            captureSession.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        } catch {
            print (error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.captureView.frame
        if let cameraPreviewLayer = cameraPreviewLayer { self.captureView.layer.addSublayer(cameraPreviewLayer)
        }
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func requestAutorization() {
        AVCaptureDevice.requestAccess(for: .video) { (Bool) in
            switch AVCaptureDevice.authorizationStatus(for: .video){
            case .authorized:
                self.setupCaptureSession()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupCaptureSession()
                    }
                }
            case .denied:
                return
            case .restricted:
                return
            default:
                return
            }
        }
    }
    
}

// CollectionView
extension CaptureViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProductViewModel.shared.productArray?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let i = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCollectionViewCell
        cell.cellLabel.text = ProductViewModel.shared.productArray?[i].name?.enUS
        
        if let imageString =  ProductViewModel.shared.productArray?[i].variants?.first?.images?.packshot?.first?.original, let url = URL(string: imageString)   {   cell.cellImageView.kf.setImage(with: url)
            print("photo")
            print (url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heigt = CGFloat(300)
        let width = UIScreen.main.bounds.width / 4
        let size = CGSize(width: width, height: heigt)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = CGAffineTransform(scaleX: 1.30, y: 1.30)
        if let ean = ProductViewModel.shared.productArray?[indexPath.row].variants?.first?.eanupc {
            print("EANUPC: \(ean)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .clear
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = .identity
    }
    
}

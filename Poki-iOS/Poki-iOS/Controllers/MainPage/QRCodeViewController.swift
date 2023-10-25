//
//  QRCodeViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/25/23.
//

import UIKit
import AVFoundation
import Then

class QRCodeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var captureSession: AVCaptureSession!
    private var cameraDevice: AVCaptureDevice!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        initiateQRScanner()
    }

    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "QR코드 인식"
        
        let appearance = UINavigationBarAppearance().then {
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseButton))
        navigationItem.leftBarButtonItem = closeButton
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // 카메라 장치 설정 - 뒷면으로 설정
    private func initCameraDevice() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
                
        cameraDevice = captureDevice
    }
        
    // 카메라 Input 설정
    private func initCameraInputData() {
        if let cameraDevice = self.cameraDevice {
            do {
                let input = try AVCaptureDeviceInput(device: cameraDevice)
                if captureSession.canAddInput(input) { captureSession.addInput(input) }
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    private func initCameraOutputData() {
        let captureMetadataOutput = AVCaptureMetadataOutput()
            
        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)
                
            if captureMetadataOutput.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.qr) {
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            } else {
                print("QRCode not supported")
                return
            }
                
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        }
    }
        
    private func initiateQRScanner() {
        captureSession = AVCaptureSession()
        self.tabBarController?.tabBar.isHidden = true
        initCameraDevice()
        initCameraInputData()
        initCameraOutputData()
        displayPreview()
    }
        
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("Error downloading image: \(error?.localizedDescription ?? "No error")")
                completion(nil)
            }
        }.resume()
    }
        
    private func checkCameraAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if !granted {
                    self.showCameraPermissionAlert()
                }
            }
        case .denied, .restricted:
            showCameraPermissionAlert()
        default:
            break
        }
    }
        
    private func displayPreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        DispatchQueue.main.async {
            self.videoPreviewLayer?.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.videoPreviewLayer!)
        }
        // startRunning을 실행시켜야 화면이 보이게 됩니다.
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
        
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(title: "카메라 권한 필요", message: "QR 코드 스캔을 위해서는 카메라 권한이 필요합니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func handleCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue,
           let url = URL(string: stringValue)
        {
            downloadImage(from: url) { [weak self] image in
                guard let self = self else { return }

                if let validImage = image {
                    let addPhotoVC = AddPhotoViewController()
                    addPhotoVC.addPhotoView.photoImageView.image = validImage
                    self.navigationController?.pushViewController(addPhotoVC, animated: true)
                } else {
                    let alert = UIAlertController(title: "오류", message: "URL이 만료되었거나 이미지가 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
                
                // QR 코드 스캔이 완료되었으면 탭바 다시 표시
                self.tabBarController?.tabBar.isHidden = false
            }
        }
    }
}

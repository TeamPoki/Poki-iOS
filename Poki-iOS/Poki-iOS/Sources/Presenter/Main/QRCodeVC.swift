//
//  QRCodeViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/25/23.
//

import UIKit
import AVFoundation
import Then

final class QRCodeVC: UIViewController {
    
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
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseButton))
        navigationItem.leftBarButtonItem = closeButton
        navigationController?.configureBasicAppearance()
    }
    
    // 카메라 장치 설정 - 뒷면으로 설정
    private func initCameraDevice() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            try captureDevice.lockForConfiguration()
            
            // 카메라가 연속 자동 초점 모드를 지원하는지 확인
            if captureDevice.isFocusModeSupported(.continuousAutoFocus) {
                // 연속 자동 초점 모드를 설정
                captureDevice.focusMode = .continuousAutoFocus
            }
            
            // 추가로, 자동 노출 및 화이트 밸런스 설정을 원할 경우에는 요 라인에다가 설정하면 됨.
            
            captureDevice.unlockForConfiguration()
        } catch {
            print("Unable to lock camera for configuration: \(error)")
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
        // HTTP 헤더에 "Accept" 항목을 "image/*"로 설정
        var request = URLRequest(url: url)
        request.setValue("image/*", forHTTPHeaderField: "Accept")
        
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

extension QRCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            // stringValue 시작 부분이 "http"인 경우 "https"로 변환 -> 보안 때문에 변환 해줘야함.
            let secureStringValue = stringValue.hasPrefix("http://") ? "https" + stringValue.dropFirst(4) : stringValue
            
            if let url = URL(string: secureStringValue) {
                downloadImage(from: url) { [weak self] image in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        if let validImage = image {
                            let addPhotoVC = AddPhotoVC()
                            addPhotoVC.addPhotoView.photoImageView.image = validImage
                            self.navigationController?.pushViewController(addPhotoVC, animated: true)
                        } else {
                            // 이미지를 다운로드하지 못했을 때 사용자에게 알림 및 URL로 리디렉션 옵션 제공
                            let alert = UIAlertController(title: "오류", message: "이미지를 다운로드할 수 없습니다.\n웹사이트로 이동하시겠습니까?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "이동", style: .default, handler: { _ in
                                if let url = URL(string: secureStringValue), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }))
                            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                                self.captureSession.startRunning()
                            }))
                            self.present(alert, animated: true)
                        }
                        self.tabBarController?.tabBar.isHidden = false
                    }
                }
            } else {
                // 유요한 URL이 아닐경우, 사용자에게 알림 띄우기
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "오류", message: "유효한 URL이 아닙니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.captureSession.startRunning()
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

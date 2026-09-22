import AVFoundation
import Photos
import SwiftUI

final class CameraViewModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    @Published var permissionDenied = false
    @Published var isRunning = false
    @Published var isFrontCamera = false
    @Published var isFlashOn = false
    @Published var lastPhoto: UIImage?
    private let output = AVCapturePhotoOutput()
    private var currentInput: AVCaptureDeviceInput?

    func requestAccessAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: configure()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted { self?.configure() } else { self?.permissionDenied = true }
                }
            }
        default: permissionDenied = true
        }
    }

    private func configure() {
        guard !session.isRunning else { return }
        session.beginConfiguration()
        session.sessionPreset = .photo
        if let input = currentInput { session.removeInput(input) }
        let position: AVCaptureDevice.Position = isFrontCamera ? .front : .back
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: device), session.canAddInput(input) else {
            session.commitConfiguration(); return
        }
        session.addInput(input)
        currentInput = input
        if session.canAddOutput(output) && !session.outputs.contains(output) { session.addOutput(output) }
        session.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
            DispatchQueue.main.async { self?.isRunning = true }
        }
    }

    func flipCamera() {
        isFrontCamera.toggle()
        configure()
    }

    func capture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = isFlashOn && !isFrontCamera ? .on : .off
        output.capturePhoto(with: settings, delegate: self)
    }

    func focus(at point: CGPoint) {
        guard let device = currentInput?.device, device.isFocusPointOfInterestSupported else { return }
        do {
            try device.lockForConfiguration()
            device.focusPointOfInterest = point
            device.focusMode = .autoFocus
            device.exposurePointOfInterest = point
            device.exposureMode = .continuousAutoExposure
            device.unlockForConfiguration()
        } catch { }
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else { return }
        DispatchQueue.main.async {
            self.lastPhoto = image
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                guard status == .authorized || status == .limited else { return }
                PHPhotoLibrary.shared().performChanges { PHAssetChangeRequest.creationRequestForAsset(from: image) }
            }
        }
    }
}

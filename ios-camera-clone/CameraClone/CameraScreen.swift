import AVFoundation
import SwiftUI

struct CameraScreen: View {
    @StateObject private var camera = CameraViewModel()
    @State private var focusPoint: CGPoint?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CameraPreview(session: camera.session) { point in
                focusPoint = point
                camera.focus(at: point)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { focusPoint = nil }
            }
            .ignoresSafeArea()

            if let point = focusPoint {
                RoundedRectangle(cornerRadius: 3).stroke(Color.yellow, lineWidth: 1.5)
                    .frame(width: 72, height: 72).position(point)
            }

            VStack(spacing: 0) {
                HStack {
                    CircleButton(systemName: camera.isFlashOn ? "bolt.fill" : "bolt.slash.fill") { camera.isFlashOn.toggle() }
                    Spacer()
                    Text("PHOTO").font(.caption.weight(.semibold)).tracking(2).foregroundStyle(.white)
                    Spacer()
                    CircleButton(systemName: "ellipsis") { }
                }.padding(.horizontal, 22).padding(.top, 12)
                Spacer()
                HStack(alignment: .center) {
                    ZStack {
                        if let image = camera.lastPhoto { Image(uiImage: image).resizable().scaledToFill() }
                        else { Color.white.opacity(0.16) }
                    }.frame(width: 48, height: 48).clipShape(RoundedRectangle(cornerRadius: 8))
                    Spacer()
                    Button { camera.capture() } {
                        Circle().fill(.white).frame(width: 76, height: 76).overlay(Circle().stroke(.white.opacity(0.4), lineWidth: 4).padding(-7))
                    }
                    Spacer()
                    CircleButton(systemName: "camera.rotate") { camera.flipCamera() }
                }.padding(.horizontal, 28).padding(.bottom, 22)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { camera.requestAccessAndConfigure() }
        .alert("Acesso à câmera bloqueado", isPresented: $camera.permissionDenied) {
            Button("OK", role: .cancel) { }
        } message: { Text("Ative o acesso à câmera nos Ajustes para usar este aplicativo.") }
    }
}

private struct CircleButton: View {
    let systemName: String
    let action: () -> Void
    var body: some View {
        Button(action: action) { Image(systemName: systemName).font(.system(size: 18, weight: .medium)).frame(width: 40, height: 40).background(.black.opacity(0.32), in: Circle()).foregroundStyle(.white) }
    }
}

private struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    let onTap: (CGPoint) -> Void
    func makeUIView(context: Context) -> PreviewView { let view = PreviewView(); view.previewLayer.session = session; view.onTap = onTap; return view }
    func updateUIView(_ view: PreviewView, context: Context) { view.previewLayer.session = session }
}

private final class PreviewView: UIView {
    var onTap: ((CGPoint) -> Void)?
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    override init(frame: CGRect) { super.init(frame: frame); previewLayer.videoGravity = .resizeAspectFill; addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped))) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    @objc private func tapped(_ gesture: UITapGestureRecognizer) { onTap?(gesture.location(in: self)) }
}

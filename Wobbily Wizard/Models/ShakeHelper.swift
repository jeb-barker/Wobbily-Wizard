//
//  ShakeHelper.swift
//  Wobbily Wizard
//
//  Created by Ashley Kulcsar on 11/26/25.
//
import SwiftUI
extension UIDevice {
    static let deviceDidShake = Notification.Name(rawValue: "deviceDidShake")
}

class CustomWindow: UIWindow {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            guard motion == .motionShake else { return }
            NotificationCenter.default.post(name: UIDevice.deviceDidShake, object: nil)
    }
}

extension View {
    public func onShakeGesture(perform action: @escaping () -> Void) -> some View {
        self.modifier(ShakeGestureViewModifier(action: action))
    }
}

struct ShakeGestureViewModifier: ViewModifier {
    // 1
  let action: () -> Void
  
  func body(content: Content) -> some View {
    content
      // 2
      .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShake)) { _ in
        action()
      }
  }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {

    var window: CustomWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = CustomWindow(windowScene: windowScene)

        // Assign the existing SwiftUI root controller
        // so the app loads normally
        window.rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first?
            .rootViewController

        window.makeKeyAndVisible()

        self.window = window
    }
}

struct WindowInstaller: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()

        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = scene.windows.first {
                    let custom = CustomWindow(windowScene: scene)
                    custom.rootViewController = window.rootViewController
                    custom.makeKeyAndVisible()
                }
            }
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

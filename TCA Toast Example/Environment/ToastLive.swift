import Combine
import ComposableArchitecture
import Foundation
import Toast
import UIKit


private let ToastNotificationName = Notification.Name("showToast")

extension ToastClient {
    static let live: ToastClient = {
        return .init { model in
            .fireAndForget {
                NotificationCenter.default.post(.init(name: ToastNotificationName, object: model))
            }
        }
    }()
}

// MARK: - UIKit

extension UIView {
    func subscribeToast(with cancellables: inout Set<AnyCancellable>) {
        NotificationCenter.default.publisher(for: ToastNotificationName)
            .sink { [weak self] notif in
                guard let model = notif.object as? ToastModel else { return }
                self?.makeToast(model.message,
                               duration: model.duration,
                               position: model.position,
                               title: model.title)
            }
            .store(in: &cancellables)
    }
}

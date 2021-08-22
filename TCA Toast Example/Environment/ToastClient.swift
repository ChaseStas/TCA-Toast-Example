import ComposableArchitecture
import Foundation
import Toast

struct ToastModel {
    var duration: TimeInterval = ToastManager.shared.duration
    var message: String? = nil
    var title: String? = nil
    var position: ToastPosition = .top
}

struct ToastClient {
    var show: (ToastModel) -> Effect<Never, Never>
}

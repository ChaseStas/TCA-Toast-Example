//
//  Second.swift
//  TCA Toast Example
//
//  Created by Stanislau Parechyn on 22.08.2021.
//

import SwiftUI
import ComposableArchitecture

struct SecondState: Equatable {
}

enum SecondAction: Equatable {
    case didTapShowToast
}

struct SecondEnvironment {
    let toastClient: ToastClient
}

let Second = Reducer<SecondState, SecondAction, SecondEnvironment>.combine(
    .init{ state, action, env in

        switch action {

        case .didTapShowToast:
            return env.toastClient.show(.init(message: "Hello"))
                .fireAndForget()
            
        default: break
        }
        
        return .none
    }
)
struct SecondView: View {
    let store: Store<SecondState, SecondAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            Button(action: {
                viewStore.send(.didTapShowToast)
            }, label: {
                Text("Show Toast")
            })
        }
    }
}

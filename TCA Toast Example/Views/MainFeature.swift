//
//  Main.swift
//  TCA Toast Example
//
//  Created by Stanislau Parechyn on 22.08.2021.
//

import SwiftUI
import ComposableArchitecture

struct MainState: Equatable {
    var route: MainAction.Route?
    var secondState: SecondState? = nil
}

enum MainAction: Equatable {
    case didTapShowToast
    case didTapGoNext

    case route(Route?)
    case second(SecondAction)

    enum Route {
        case next
    }
}

struct MainEnvironment {
    let toastClient: ToastClient
}

let Main = Reducer<MainState, MainAction, MainEnvironment>.combine(
    .init{ state, action, env in

        switch action {

        case .didTapShowToast:
            return env.toastClient.show(.init(message: "Hello"))
                .fireAndForget()

        case .didTapGoNext:
            state.route = .next

        case let .route(value):
            state.route = value

            if value == .next {
                state.secondState = .init()
            }

        default: break
        }
        return .none
    },
    Second
        .optional()
        .pullback(
            state: \.secondState,
            action: /MainAction.second,
            environment: { SecondEnvironment(toastClient: $0.toastClient) })
)

struct MainView: View {
    let store: Store<MainState, MainAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                NavigationLink("",
                               destination: IfLetStore(store.scope(state: \.secondState,
                                                                   action: MainAction.second),
                                                       then: { SecondView(store: $0) }),
                               tag: MainAction.Route.next,
                               selection: viewStore.binding(get: \.route, send: MainAction.route))

                VStack {
                    Button(action: {
                        viewStore.send(.didTapShowToast)
                    }, label: {
                        Text("Show Toast")
                    })

                    Button(action: {
                        viewStore.send(.didTapGoNext)
                    }, label: {
                        Text("Next")
                    })
                }
            }
        }
    }
}

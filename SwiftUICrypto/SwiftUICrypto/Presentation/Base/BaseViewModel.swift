//
//  BaseViewModel.swift
//  SwiftUICrypto
//

import Combine

@MainActor
class BaseViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    var error: APIError? {
        didSet {
            isShowError = error != nil
        }
    }
    @Published var isShowError: Bool = false
    @Published var isLoading: Bool = false
}


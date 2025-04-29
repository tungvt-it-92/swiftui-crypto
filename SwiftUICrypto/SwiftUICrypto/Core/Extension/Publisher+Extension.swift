//
//  Publisher+Extension.swift
//  SwiftUICrypto
//

import Combine

extension Publisher where Output: Sendable {
    func asyncValue() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        break
                    }
                    cancellable?.cancel()
                },
                receiveValue: { value in
                    continuation.resume(returning: value)
                    cancellable?.cancel()
                }
            )
        }
    }
}

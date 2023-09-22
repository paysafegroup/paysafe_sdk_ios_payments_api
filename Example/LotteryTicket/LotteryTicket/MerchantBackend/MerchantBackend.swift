//
//  MerchantBackend.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import Foundation

/// Saved cards completion block.
typealias SavedCardsCompletionBlock = (Result<SavedCardsResponse, MerchantError>) -> Void

/// MerchantBackend
class MerchantBackend {
    /// API key
    let apiKey: String

    /// - Parameters:
    ///   - apiKey: API key
    init(apiKey: String) {
        self.apiKey = apiKey
    }

    /// Fetch saved cards based on profile id.
    ///
    /// - Parameters:
    ///   - profileId: Profile id
    ///   - completion: SavedCardsCompletionBlock
    func fetchSavedCards(
        for profileId: String,
        completion: @escaping SavedCardsCompletionBlock
    ) {
        let savedCardsURL = "https://api.test.paysafe.com/paymenthub/v1/customers/\(profileId)/singleusecustomertokens"
        guard let requestURL = URL(string: savedCardsURL) else { return completion(.failure(.dataError)) }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(apiKey)", forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try JSONEncoder().encode(SavedCardsRequest())
        } catch {
            return completion(.failure(.other(error)))
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else { return completion(.failure(.networkError(error!))) }
            guard let data else { return completion(.failure(.dataError)) }

            do {
                let customerResponse = try JSONDecoder().decode(SavedCardsResponse.self, from: data)
                completion(.success(customerResponse))
            } catch {
                completion(.failure(.other(error)))
            }
        }.resume()
    }
}

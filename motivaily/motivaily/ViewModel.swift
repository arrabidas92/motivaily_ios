//
//  ViewModel.swift
//  motivaily
//
//  Created by Alexandre DUARTE on 09/10/2021.
//

import Foundation
import Combine

protocol ViewModelProtocol {
    func fetchQuote()
    func shareQuote()
}

class ViewModel: ViewModelProtocol {
    @Published private(set) var quote = Quote()
    @Published private(set) var sharedQuote: Quote?
    @Published private(set) var error: FirestoreError?
    
    private let repository: NetworkRepository
    
    init(repository: NetworkRepository) {
        self.repository = repository
    }
    
    func fetchQuote() {
        repository.getListOfQuotes { [weak self] result in
            switch result {
            case .failure(let error):
                self?.error = error
            case .success(let documents):
                let data = documents.first?.data()
                guard let quote = Quote(data: data) else { return }
                self?.quote = quote
            }
        }
    }
    
    func shareQuote() {
        self.sharedQuote = quote
    }
}

//
//  NetworkRepository.swift
//  motivaily
//
//  Created by Alexandre DUARTE on 09/10/2021.
//

import Foundation
import FirebaseFirestore

enum FirestoreError: Error {
    case requestError
    case noDataError
}

protocol NetworkRepository {
    func getListOfQuotes(completion: @escaping (Result<[QueryDocumentSnapshot], FirestoreError>) -> Void)
}

struct FirestoreRepository: NetworkRepository {
    func getListOfQuotes(completion: @escaping (Result<[QueryDocumentSnapshot], FirestoreError>) -> Void) {
        let database = Firestore.firestore()
        database.collection(Constants.QUOTES)
            .order(by: Constants.CREATED_AT)
            .limit(toLast: 1)
            .getDocuments(source: .server) { snapshot, error in
            if error != nil {
                completion(.failure(FirestoreError.requestError))
            } else if let snapshot = snapshot {
                completion(.success(snapshot.documents))
            } else {
                completion(.failure(FirestoreError.noDataError))
            }
        }
    }
}

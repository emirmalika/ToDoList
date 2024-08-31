//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Malik Em on 31.08.2024.
//

import Foundation

struct Todo: Codable {
    
    let todos: [Todos]
}

struct Todos: Codable {
    let todo: String
    let completed: Bool
}


class NetworkManager {
    
//    private let session: URLSession
//
//    lazy var jsonDecoder: JSONDecoder = {
//        JSONDecoder()
//    }()
//
//    init(with configuration: URLSessionConfiguration) {
//        session = URLSession(configuration: configuration)
//    }
//
//    func fetchData() async throws -> [Todo] {
//
//        guard let url = URL(string: "https://dummyjson.com/todo") else { return [] }
//        let urlRequest = URLRequest(url: url)
//        let responseData = try await session.data(for: urlRequest)
//
//        return try jsonDecoder.decode([Todo].self, from: responseData.0)
//    }
    
    static let shared = NetworkManager()
    
    private let urlString = "https://dummyjson.com/todo"
    
    func fetchData(completion: @escaping (Result<Todo, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(Todo.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

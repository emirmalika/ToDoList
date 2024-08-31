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

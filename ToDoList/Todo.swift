//
//  Task.swift
//  ToDoList
//
//  Created by Malik Em on 29.08.2024.
//

import Foundation

class ToDo {
    let todo: String
    let completed: Bool
    
    init(todo: String, completed: Bool) {
        self.todo = todo
        self.completed = completed
    }
}

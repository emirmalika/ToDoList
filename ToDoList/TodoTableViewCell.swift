//
//  TasksTableViewCell.swift
//  ToDoList
//
//  Created by Malik Em on 29.08.2024.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "Identifier"
    static let shared = TodoTableViewCell()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with viewModel: ToDo) {
        titleLabel.text = viewModel.todo
        if viewModel.completed == true {
            statusLabel.text = "Выполнен"
        } else {
            statusLabel.text = "Не выполнен"
        }
        dateLabel.text = setupDate()
    }
    
    func setupDate() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        let date = formatter.string(from: today)

        return date
    }
    
    private func setupLayout() {
        
        let firstStackView = UIStackView(arrangedSubviews: [titleLabel, statusLabel, dateLabel])
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        firstStackView.axis = .vertical
        firstStackView.spacing = 8
        
        contentView.addSubview(firstStackView)
    
        NSLayoutConstraint.activate([
            firstStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            firstStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            firstStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

//
//  TasksTableViewCell.swift
//  ToDoList
//
//  Created by Malik Em on 29.08.2024.
//

import UIKit

final class TasksTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "Identifier"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
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
    
    func configureCell(with task: Task) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        dateLabel.text = task.date
        statusLabel.text = task.status
    }
    
    private func setupLayout() {
        
        let firstStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel, statusLabel])
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        firstStackView.axis = .vertical
        firstStackView.spacing = 10
        
        contentView.addSubview(firstStackView)
    
        NSLayoutConstraint.activate([
            firstStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            firstStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            firstStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

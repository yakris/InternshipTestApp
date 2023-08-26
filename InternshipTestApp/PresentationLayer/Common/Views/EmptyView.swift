//
//  EmptyView.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 28.08.2023.
//

import UIKit

struct EmptyViewModel {
    let title: String
    let description: String
    let actionHandler: (() -> Void)?
}

final class EmptyView: UIView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 24
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var actionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: EmptyViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        actionHandler = model.actionHandler
    }
}

private extension EmptyView {
    func configure() {
        backgroundColor = .white
        
        imageView.image = UIImage(named: "empty-cat")
        
        actionButton.setTitle("Обновить", for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
    }
    
    func setupLayout() {
        addSubview(stackView)
        
        [imageView, titleLabel, descriptionLabel, actionButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc
    func buttonDidTap() {
        actionHandler?()
    }
}

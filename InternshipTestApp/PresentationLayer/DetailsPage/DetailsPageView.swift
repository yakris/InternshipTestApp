//
//  DetailsPageView.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 30.08.2023.
//

import UIKit

struct DetailsPageViewModel {
    let title: String
    let price: String
    let imageUrl: String
    let createdDate: String
    let description: String
    let email: String
    let phoneNumber: String
    let address: String
}

final class DetailsPageView: UIView {
    private enum Constants {
        static let imageCornerRadius = 5.0
        static let descriptionTitle = "Описание"
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Constants.imageCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 2
        view.axis = .vertical
        view.alignment = .top
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let addressLabel = UILabel()
    private let phoneLabel = UILabel()
    private let emailLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let createdDateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: DetailsPageViewModel) {
        imageView.setImage(from: URL(string: viewModel.imageUrl))
        
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        addressLabel.text = viewModel.address
        phoneLabel.text = viewModel.phoneNumber
        emailLabel.text = viewModel.email
        descriptionTitleLabel.text = Constants.descriptionTitle
        descriptionLabel.text = viewModel.description
        createdDateLabel.text = viewModel.createdDate
    }
}

// MARK: - Private

private extension DetailsPageView {
    func configure() {
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.numberOfLines = 2
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        addressLabel.numberOfLines = 0
        
        phoneLabel.font = UIFont.systemFont(ofSize: 16)
        
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        
        descriptionTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        createdDateLabel.font = UIFont.systemFont(ofSize: 12)
        createdDateLabel.textColor = .gray
    }
    
    func setupLayout() {
        [imageView, stackView].forEach {
            addSubview($0)
        }
        
        [titleLabel, priceLabel, addressLabel, phoneLabel, emailLabel,
         descriptionTitleLabel, descriptionLabel, createdDateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [priceLabel, emailLabel, descriptionTitleLabel, descriptionLabel].forEach {
            stackView.setCustomSpacing(16, after: $0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: imageView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

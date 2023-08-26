//
//  MainPageItemViewCell.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 27.08.2023.
//

import UIKit

struct MainPageItemViewModel {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String
}

final class MainPageItemViewCell: UICollectionViewCell {
    
    private enum Constants {
        static let imageCornerRadius = 5.0
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Constants.imageCornerRadius
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.axis = .vertical
        view.alignment = .top
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let locationLabel = UILabel()
    private let createdDateLabel = UILabel()
    
    private var actionHandler: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: MainPageItemViewModel) {
        imageView.setImage(from: URL(string: viewModel.imageUrl))
        
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        locationLabel.text = viewModel.location
        createdDateLabel.text = viewModel.createdDate
    }
}

private extension MainPageItemViewCell {
    func configure() {
        [locationLabel, createdDateLabel].forEach {
            $0.numberOfLines = 1
            $0.textAlignment = .left
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textColor = .gray
        }
    }
    
    func setupLayout() {
        [imageView, stackView].forEach {
            contentView.addSubview($0)
        }
        
        [titleLabel, priceLabel, locationLabel, createdDateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.setCustomSpacing(2, after: locationLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            stackView.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: imageView.rightAnchor)
        ])
    }
}

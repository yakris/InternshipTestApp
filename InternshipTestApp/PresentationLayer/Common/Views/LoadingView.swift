//
//  LoadingView.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 28.08.2023.
//

import UIKit
import Lottie

final class LoadingView: UIView {
    
    private enum Constants {
        static let animationViewSize = 300.0
    }
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.animationSpeed = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play(animationName: String) {
        animationView.animation = LottieAnimation.named(animationName)
        animationView.play()
    }
    
    func stop() {
        animationView.stop()
    }
}

private extension LoadingView {
    func configure() {
        backgroundColor = .white
    }
    
    func setupLayout() {
        addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.heightAnchor.constraint(equalToConstant: Constants.animationViewSize),
            animationView.widthAnchor.constraint(equalToConstant: Constants.animationViewSize)
        ])
    }
}

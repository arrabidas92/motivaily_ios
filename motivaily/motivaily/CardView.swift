//
//  CardView.swift
//  motivaily
//
//  Created by Alexandre DUARTE on 09/10/2021.
//

import UIKit

class CardView: UIView {
    
    // MARK: - UI
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.backgroundColor = .clear
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.7
        cardView.layer.shadowRadius = 2.0
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private lazy var cornerView: UIView = {
        let cornerView = UIView()
        cornerView.backgroundColor = .white
        cornerView.layer.cornerRadius = 16
        cornerView.layer.masksToBounds = true
        cornerView.translatesAutoresizingMaskIntoConstraints = false
        return cornerView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var quoteLabel: UILabel = {
        let quote = UILabel()
        quote.numberOfLines = 0
        quote.textColor = .black
        quote.textAlignment = .left
        quote.font = UIFont(name: "Futura-MediumItalic", size: 48)
        quote.translatesAutoresizingMaskIntoConstraints = false
        quote.adjustsFontSizeToFitWidth = true
        return quote
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    // MARK: - Public API
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    func setQuote(_ text: String) {
        quoteLabel.text = text
    }
}

// MARK: - Private helpers

extension CardView {
    private func initUI() {
        self.addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        cardView.addSubview(cornerView)
        cornerView.topAnchor.constraint(equalTo: cardView.topAnchor).isActive = true
        cornerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor).isActive = true
        cornerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor).isActive = true
        cornerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor).isActive = true
        
        cardView.addSubview(quoteLabel)
        quoteLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        quoteLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true
        quoteLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 32).isActive = true
        quoteLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -32).isActive = true
        
        cardView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
    }
}

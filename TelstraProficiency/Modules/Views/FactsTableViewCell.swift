//
//  FactsTableViewCell.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import UIKit

class FactsTableViewCell: UITableViewCell {
    
    //MARK: - Private properties
    
    private let factsImageView: UIImageView = {
        let factsImage = UIImageView()
        factsImage.contentMode = .scaleAspectFit
        factsImage.clipsToBounds = true
        factsImage.translatesAutoresizingMaskIntoConstraints = false
        factsImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        factsImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return factsImage
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont.preferredFont(forTextStyle: .subheadline)
        description.lineBreakMode = .byWordWrapping
        description.numberOfLines = 0
        description.clipsToBounds = true
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let horizantStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Public properties
    
    var onReuse: () -> Void = {}
    var factsImage: UIImage? {
        didSet {
            factsImageView.image = factsImage
            factsImageView.isHidden = false
        }
    }
    
    //MARK: - Initialiser Methods
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(verticalStackView)
        horizantStackView.addArrangedSubview(factsImageView)
        horizantStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(horizantStackView)
        verticalStackView.addArrangedSubview(descriptionLabel)
        updateCellConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented, please create using code.")
        
    }
    
    //MARK: - Lifecycle methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.width
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse()
        factsImageView.image = nil
    }
}

//MARK: - Private methods

private extension FactsTableViewCell {
    
    func updateCellConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0),
            verticalStackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 0),
            verticalStackView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0),
            verticalStackView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0)
        ])
    }
}

//MARK: - Public methods

extension FactsTableViewCell {
    
    func configure(_ row: FactsRow) {
        factsImageView.isHidden = true
        titleLabel.text = row.title
        descriptionLabel.text = row.description
    }
}

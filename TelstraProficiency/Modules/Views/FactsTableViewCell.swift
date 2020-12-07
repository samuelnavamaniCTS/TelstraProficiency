//
//  FactsTableViewCell.swift
//  TelstraProficiency
//
//  Created by Navamani, Samuel on 7/12/20.
//

import UIKit

class FactsTableViewCell: UITableViewCell {
    
    private let factsImageView: UIImageView = {
        let factsImage = UIImageView()
        factsImage.contentMode = .scaleAspectFit
        factsImage.clipsToBounds = true
        factsImage.translatesAutoresizingMaskIntoConstraints = false
        return factsImage
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = UIFont.boldSystemFont(ofSize: 14)
        description.lineBreakMode = .byWordWrapping
        description.numberOfLines = 0
        description.clipsToBounds = true
        description.translatesAutoresizingMaskIntoConstraints = false
        return description
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var onReuse: () -> Void = {}
    var factsImage: UIImage? {
        didSet {
            factsImageView.image = factsImage
        }
    }
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(factsImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        updateCellConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not implemented, please create using code.")
        
    }
    
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

private extension FactsTableViewCell {
    
    func updateCellConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0)
        ])
    }
}

extension FactsTableViewCell {
    
    func configure(_ row: FactsRow) {
        factsImageView.image = UIImage(named: "default")!
        titleLabel.text = row.title
        descriptionLabel.text = row.description
    }
}

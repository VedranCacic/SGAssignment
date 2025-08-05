import UIKit

/// A cell displaying the basic information of a GitHub repository.
final class RepositoryTableViewCell: UITableViewCell {
    /// The name of the repository.
    var name: String? {
        get {
            nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    /// The description of the repository.
    var descriptionText: String? {
        get {
            descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
        }
    }
    
    /// The star count of the repository. This text should be pre-formatted.
    var starCountText: String? {
        get {
            starCountLabel.text
        }
        set {
            starCountLabel.text = newValue
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        let baseFont = UIFont.preferredFont(forTextStyle: .body)
        let boldDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitBold)
        label.font = boldDescriptor.flatMap { UIFont(descriptor: $0, size: 0) } ?? baseFont
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .caption1))
        imageView.image = UIImage(systemName: "star.fill", withConfiguration: configuration)
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private let starCountLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize, weight: .regular)
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let starLeadingConstant: CGFloat = 4
    
    private var sameRowTopConstraint: NSLayoutConstraint? = nil
    private var sameRowLeadingConstraint: NSLayoutConstraint? = nil
    private var nextRowTopConstraint: NSLayoutConstraint? = nil
    private var nextRowLeadingConstraint:NSLayoutConstraint? = nil
    private var nextRowTrailingConstraint:NSLayoutConstraint? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        starImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        starCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(starImageView)
        contentView.addSubview(starCountLabel)
        contentView.addSubview(descriptionLabel)
        
        sameRowTopConstraint = NSLayoutConstraint(item: starImageView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nameLabel, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        sameRowLeadingConstraint = NSLayoutConstraint(item: starImageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nameLabel, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        
        nextRowTopConstraint = NSLayoutConstraint(item: starImageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nameLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        nextRowLeadingConstraint = NSLayoutConstraint(item: starImageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.leadingMargin, multiplier: 1, constant: 0)
        
        nextRowTrailingConstraint = NSLayoutConstraint(item: nameLabel, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.trailingMargin, multiplier: 1, constant: 0)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starCountLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel
                .leadingAnchor
                .constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            nameLabel
                .firstBaselineAnchor
                .constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1),
            
        ])
        
        sameRowTopConstraint?.isActive = true
        sameRowLeadingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            
            starCountLabel
                .leadingAnchor
                .constraint(equalTo: starImageView.trailingAnchor, constant: starLeadingConstant),
            starCountLabel
                .centerYAnchor
                .constraint(equalTo: starImageView.centerYAnchor),
            starCountLabel
                .trailingAnchor
                .constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            descriptionLabel
                .leadingAnchor
                .constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            descriptionLabel
                .firstBaselineAnchor
                .constraint(equalToSystemSpacingBelow: starImageView.lastBaselineAnchor, multiplier: 1),
            descriptionLabel
                .trailingAnchor
                .constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            contentView
                .layoutMarginsGuide
                .bottomAnchor
                .constraint(equalToSystemSpacingBelow: descriptionLabel.lastBaselineAnchor, multiplier: 1),
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews(){
        
        super.layoutSubviews()
        // calculating if views width is bigger than content view
        let layoutWidth = self.contentView.frame.width - contentView.layoutMargins.left - contentView.layoutMargins.right
        
        let dynamicWidth = (nameLabel.intrinsicContentSize.width + starImageView.frame.width + starCountLabel.intrinsicContentSize.width + starLeadingConstant)
        
        //applying constraints according to situation
        
        sameRowTopConstraint?.isActive = layoutWidth >= dynamicWidth
        sameRowLeadingConstraint?.isActive = layoutWidth >= dynamicWidth
        nextRowTopConstraint?.isActive = layoutWidth < dynamicWidth
        nextRowLeadingConstraint?.isActive = layoutWidth < dynamicWidth
        nextRowTrailingConstraint?.isActive = layoutWidth < dynamicWidth
        
    }
}


import UIKit

class PlanCell: UICollectionViewCell {
    static let identifier = "PurchasePlanCell"
    
    private let radioButton: UIView = {
        let outerCircle = UIView()
        outerCircle.layer.cornerRadius = 10
        outerCircle.layer.borderWidth = 2
        outerCircle.layer.borderColor = UIColor.white.cgColor
        outerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        let innerCircle = UIView()
        innerCircle.tag = 1
        innerCircle.backgroundColor = UIColor.foreground
        innerCircle.layer.cornerRadius = 6
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        outerCircle.addSubview(innerCircle)

        NSLayoutConstraint.activate([
            innerCircle.centerXAnchor.constraint(equalTo: outerCircle.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 12),
            innerCircle.heightAnchor.constraint(equalToConstant: 12),
        ])
        
        return outerCircle
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weekly"
        label.textColor = UIColor.white
        label.font = UIFont.appFont(ofSize: 18.dp, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No payment now"
        label.textColor = UIColor.secondaryLabel
        label.font = UIFont.appFont(ofSize: 14.dp, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$6.99 / Year"
        label.textColor = UIColor.white
        label.font = UIFont.appFont(ofSize: 18.dp, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 30.dp
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        
        containerStack.addArrangedSubview(titleLabel)
        containerStack.addArrangedSubview(subtitleLabel)

        contentView.addSubview(radioButton)
        contentView.addSubview(containerStack)
        contentView.addSubview(priceLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.dp),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 20.dp),
            radioButton.heightAnchor.constraint(equalToConstant: 20.dp),
            
            containerStack.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12),
            containerStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.dp),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(selected: Bool) {
        radioButton.viewWithTag(1)?.backgroundColor = selected ? UIColor.white : UIColor.clear
        
        contentView.layer.borderWidth = selected ? 2.0 : 0.5
    }
    
    func setupCell(with item: InAppItem, isSelected: Bool) {
        titleLabel.text = item.title
        subtitleLabel.text = item.offerText
        priceLabel.text = "\(item.fetchPrice())/\(item.duration)"
        configure(selected: isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

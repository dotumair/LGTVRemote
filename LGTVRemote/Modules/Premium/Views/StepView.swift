
import UIKit

class StepView: UIView {
    
    func makeLabel(with text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private lazy var titleLabel: UILabel = {
        let label = makeLabel(with: "", font: UIFont.appFont(ofSize: 18.dp, weight: .semibold), color: .white)
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = makeLabel(with: "", font: UIFont.appFont(ofSize: 16.dp, weight: .regular), color: UIColor(hex: "979797"))
        label.numberOfLines = 0
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18.dp
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = (UIColor(hex: "5682F3").withAlphaComponent(0.3)).cgColor
        
        return view
    }()
    
    let stepIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.foreground.withAlphaComponent(0.5)
        view.layer.cornerRadius = 4
        return view
    }()
    
    var stepHeight: CGFloat = 40.dp
    
    init(image: UIImage, title: String,titleColor: UIColor = UIColor(hex: "#393939"), description: String, backgroundColor: UIColor = UIColor.foreground, stepHeight: CGFloat = UIDevice.isPad ? 60.0 : 40.0, lastStep: Bool = false) {
        super.init(frame: .zero)
        imageView.image = image
        titleLabel.text = title
        titleLabel.textColor = titleColor
        descLabel.text = description
        imageContainer.backgroundColor = backgroundColor
        self.stepHeight = stepHeight
        stepIndicator.isHidden = lastStep
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, descLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 6.dp
        textStackView.distribution = .fillProportionally
        textStackView.alignment = .leading
        
        let imageStepStackView = UIStackView(arrangedSubviews: [imageContainer,stepIndicator])
        imageStepStackView.axis = .vertical
        imageStepStackView.spacing = 6.dp
        imageStepStackView.distribution = .fillProportionally
        imageStepStackView.alignment = .center
        
        let textContainer = UIView()
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        
        textContainer.addSubview(textStackView)
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        textStackView.addConstraints(top: .equalToSuperView(5.dp), left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToSuperView(0))
        
        let mainStackView = UIStackView(arrangedSubviews: [imageStepStackView, textContainer])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 20.dp
        mainStackView.distribution = .fill
        mainStackView.alignment = .top
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.equalToSuperView()
        
        imageContainer.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageContainer.widthAnchor.constraint(equalToConstant: 36.dp),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 1.0),
            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 18.dp),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            stepIndicator.heightAnchor.constraint(equalToConstant: stepHeight),
            stepIndicator.widthAnchor.constraint(equalToConstant: 8.dp)
        ])
    }
}

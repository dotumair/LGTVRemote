
import UIKit

class OnboardCell: UICollectionViewCell {
    
    private let items: [(title: String, subtitle: String)] = [
        (title: "Welcome!", subtitle: "Transform your Smartphone into Powerful Samsung TV Remote."),
        (title: "Customize Home Apps", subtitle: "Transform your Smartphone into Powerful Samsung TV Remote."),
        (title: "Handy keyboard", subtitle: "Speed up typing with keyboard features."),
        (title: "Intuitive Touchpad", subtitle: "Effortlessly control using a Touchpad or Classic buttons.")
    ]
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIDevice.isPad ? .scaleAspectFill : .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .clear
        bgView.layer.masksToBounds = true
        bgView.translatesAutoresizingMaskIntoConstraints = true
        return bgView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.appFont(ofSize: 24.dp, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 4
        label.font = UIFont.appFont(ofSize: 15.dp)
        label.textColor = UIColor(hex: "#ADADAD")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(imageView)
        contentView.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(subTitleLabel)
        
        imageView.equalToSuperView()
        
        titleLabel.addConstraints(top: .equalToSuperView(), left: .equalToSuperView(), right: .equalToSuperView())
        subTitleLabel.addConstraints(top: .equalToWithOffset(titleLabel.snp.bottom, 10.dp), left: .equalToSuperView(), right: .equalToSuperView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with index: IndexPath) {
        let imageName = UIDevice.isPad ? "onboarding_ipad_\(index.item+1)" : "onboarding_\(index.item+1)"
        imageView.image = UIImage(named: imageName)
        titleLabel.text = items[index.item].title
        subTitleLabel.text = items[index.item].subtitle
        
        let width = UIScreen.main.bounds.width - 40.dp
        
        let titleHeight = items[index.item].title.frame(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), font: UIFont.appFont(ofSize: 25.dp, weight: .medium)).height
        let subHeight = items[index.item].subtitle.frame(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), font: UIFont.appFont(ofSize: 15.dp)).height
        let totalHeight = titleHeight + subHeight + 10.dp
        let safeAreaInsets = UIApplication.shared.globalSafeAreaInsets
        
        if index.item < 2 {
            let y = UIScreen.main.bounds.height - totalHeight - safeAreaInsets.bottom - 150.dp
            bgView.frame = CGRect(x: 20.dp, y: y, width: width, height: totalHeight)
        } else {
            bgView.frame = CGRect(x: 20.dp, y: UIDevice.isPad ? safeAreaInsets.top + 50 : safeAreaInsets.top + 10, width: width, height: totalHeight)
        }
    }
}


import UIKit

class SettingCell: UICollectionViewCell {
    static let identifier = "SettingCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.font = UIFont.appFont(ofSize: 17.dp, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var imageViewCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "131313")
        view.layer.cornerRadius = 22.dp
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var switchView: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = UIColor.foreground
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(switchViewChange), for: .valueChanged)
        return sw
    }()
    
    @objc private func switchViewChange() {
        UserDefaults.standard.vibrationEnabled = switchView.isOn
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(imageViewCircle)
        imageViewCircle.addConstraints(left: .equalTo(20.dp), centerY: .equalToSuperView(0), width: .equalTo(44.dp), height: .equalTo(44.dp))
        
        imageViewCircle.addSubview(imageView)
        imageView.equalToSuperView(offsets: UIEdgeInsets(top: 12.dp, left: 12.dp, bottom: 12.dp, right: 12.dp))
        
        contentView.addSubview(titleLabel)
        titleLabel.addConstraints(left: .equalToWithOffset(imageViewCircle.snp.right, 16.dp), centerY: .equalToSuperView(0))
        
        contentView.addSubview(switchView)
        switchView.addConstraints(right: .equalToSuperView(-20.dp), centerY: .equalToSuperView(0))
        
        //divider
        let div = UIView()
        div.backgroundColor = UIColor(hex: "212121")
        contentView.addSubview(div)
        div.addConstraints(left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToSuperView(0), height: .equalTo(1))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with type: SettingType) {
        titleLabel.text = type.title
        imageView.image = UIImage(named: type.image)
        switchView.isHidden = type != .vibration
        switchView.isOn = UserDefaults.standard.vibrationEnabled
    }
}

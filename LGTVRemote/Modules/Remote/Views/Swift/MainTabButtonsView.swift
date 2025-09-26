
import UIKit

class MainTabButtonsView: UIView {
    
    private let colors = ["3B3A3E", "2A292D"]
    
    var onTabSelected: ((Int) -> Void)?
    
    private var selectedTabIndex = 0 {
        didSet {
            updateSelectedTab()
        }
    }
    
    private lazy var buttonView: GradientButton = {
        let button = GradientButton(type: .system)
        button.tag = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Buttons", for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 16.dp, weight: .medium)
        button.tintColor = .white
//        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var touchPadView: GradientButton = {
        let button = GradientButton(type: .system)
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Touchpad", for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 16.dp, weight: .medium)
        button.tintColor = .white
//        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        selectedTabIndex = 0
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hex: "131313")
//        backgroundView.startColor = UIColor(hex: "222123"); backgroundView.endColor = UIColor(hex: "141313")
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.cornerRadius = 30
        backgroundView.layer.cornerRadius = 30.dp
        backgroundView.layer.borderWidth = 2.0
        backgroundView.layer.borderColor = UIColor(hex: "161515").cgColor
        addSubview(backgroundView)
        
        backgroundView.equalToSuperView()

        backgroundView.addSubview(buttonView)
        buttonView.addTarget(self, action: #selector(didPressedTabButton(_:)), for: .touchUpInside)
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(5)
            make.leading.bottom.equalTo(backgroundView).inset(5)
            make.width.equalTo(backgroundView).multipliedBy(0.49)
        }
        
        backgroundView.addSubview(touchPadView)
        touchPadView.addTarget(self, action: #selector(didPressedTabButton(_:)), for: .touchUpInside)
        touchPadView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(5)
            make.trailing.equalTo(backgroundView).offset(-5)
            make.bottom.equalTo(backgroundView).offset(-5)
            make.width.equalTo(backgroundView).multipliedBy(0.49)
        }
    }
    
    @objc func didPressedTabButton(_ sender: UIButton) {
        selectedTabIndex = sender.tag
        onTabSelected?(sender.tag)
    }
    
    private func updateSelectedTab() {
        let isSelected = selectedTabIndex == 0
        
        buttonView.startColor = isSelected ? UIColor(hex: colors.first!) : .clear
        buttonView.endColor = isSelected ? UIColor(hex: colors.last!) : .clear
        buttonView.addInnerShadow = isSelected

        touchPadView.startColor = isSelected ? .clear : UIColor(hex: colors.first!)
        touchPadView.endColor = isSelected ? .clear : UIColor(hex: colors.last!)
        touchPadView.addInnerShadow = !isSelected
    }
}

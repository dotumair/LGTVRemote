
import UIKit

class TrialSwitchView: UIView {
    var action: (Bool) -> Void

    lazy var enableSwitch: UISwitch = {
        let swith = UISwitch()
        swith.translatesAutoresizingMaskIntoConstraints = false
        swith.isOn = false
        swith.onTintColor = UIColor.foreground
        return swith
    }()

    override init(frame: CGRect) {
        self.action = { _ in }
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.action = { _ in }
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let label = UILabel()
        label.text = "Enable Free Trial"
        label.font = UIFont.appFont(ofSize: 16.dp, weight: .regular)
        label.textColor = UIColor.white

        addSubview(label)
        label.addConstraints(left: .equalToSuperView(20.dp), centerY: .equalToSuperView(0))
        
        addSubview(enableSwitch)
        enableSwitch.addConstraints(right: .equalToSuperView(-15.dp), centerY: .equalToSuperView(0))
        enableSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }
    
    @objc private func switchValueChanged() {
        action(enableSwitch.isOn)
    }
}


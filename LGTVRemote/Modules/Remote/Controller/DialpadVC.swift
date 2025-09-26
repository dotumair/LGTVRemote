
import UIKit
import BottomPopup

class DialpadVC: BottomPopupViewController {
    
    override var popupHeight: CGFloat {
        return 350.dp
    }
    
    override var popupTopCornerRadius: CGFloat {
        return 30.dp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor(hex: "131313")
        
        let mainStackView = UIStackView()
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 12.dp
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        // Column 1
        let col1Stack = createVerticalStackView()
        col1Stack.addArrangedSubview(createNumberButton(number: 1))
        col1Stack.addArrangedSubview(createNumberButton(number: 4))
        col1Stack.addArrangedSubview(createNumberButton(number: 7))
        let spacer1 = UIView()
        spacer1.backgroundColor = .clear
        col1Stack.addArrangedSubview(spacer1)
        
        // Column 2
        let col2Stack = createVerticalStackView()
        col2Stack.addArrangedSubview(createNumberButton(number: 2))
        col2Stack.addArrangedSubview(createNumberButton(number: 5))
        col2Stack.addArrangedSubview(createNumberButton(number: 8))
        col2Stack.addArrangedSubview(createNumberButton(number: 0))
        
        // Column 3
        let col3Stack = createVerticalStackView()
        col3Stack.addArrangedSubview(createNumberButton(number: 3))
        col3Stack.addArrangedSubview(createNumberButton(number: 6))
        col3Stack.addArrangedSubview(createNumberButton(number: 9))
        
        let spacer2 = UIView()
        spacer2.backgroundColor = .clear
        col3Stack.addArrangedSubview(spacer2)
        
        // Column 4
        let col4Stack = createVerticalStackView()
        col4Stack.addArrangedSubview(createColorButton(color: .systemRed, tag: 0))
        col4Stack.addArrangedSubview(createColorButton(color: .systemGreen, tag: 1))
        col4Stack.addArrangedSubview(createColorButton(color: .systemYellow, tag: 2))
        col4Stack.addArrangedSubview(createColorButton(color: .systemBlue, tag: 3))
        
        mainStackView.addArrangedSubview(col1Stack)
        mainStackView.addArrangedSubview(col2Stack)
        mainStackView.addArrangedSubview(col3Stack)
        mainStackView.addArrangedSubview(col4Stack)
        
        mainStackView.equalToSuperView(offsets: UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20))
    }
    
    func createVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.dp
        return stackView
    }
    
    func createNumberButton(number: Int) -> UIButton {
        let button = GradientButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(number), for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 22.dp, weight: .regular)
        button.tintColor = .white
        button.clipsToBounds = true
        button.cornerRadius = 16.dp
        button.tag = number
        button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    func createColorButton(color: UIColor, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.cornerRadius = 16.dp
        button.tag = tag
        button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func numberButtonTapped(_ sender: UIButton) {
        if (0...9).contains(sender.tag) {
//            let keys: [TVRemoteCommand.Params.ControlKey] = [
//                .number0, .number1, .number2, .number3, .number4,
//                .number5, .number6, .number7, .number8, .number9
//            ]
//            TVHelper.shared.sendCommand(keys[sender.tag])
        }
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
//        let colors: [TVRemoteCommand.Params.ControlKey] = [
//            .colorRed, .colorGreen, .colorYellow, .colorBlue
//        ]
//
//        if (0..<colors.count).contains(sender.tag) {
//            TVHelper.shared.sendCommand(colors[sender.tag])
//        }
    }
}

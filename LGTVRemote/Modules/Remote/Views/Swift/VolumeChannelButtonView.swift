
import UIKit
import WebOSClient

class VolumeChannelButtonView: UIView {
    
    private lazy var volumeUpButton = createSymbolButton(systemName: "plus", tag: 1)
    private lazy var volumeDownButton = createSymbolButton(systemName: "minus", tag: 2)
    private lazy var volumeLabel = createLabel(text: "vol")
    private lazy var volumeStackView = createVerticalContainer(subviews: [volumeUpButton, volumeLabel, volumeDownButton])

    // Channel Controls
    private lazy var channelUpButton = createSymbolButton(systemName: "chevron.up", tag: 3)
    private lazy var channelDownButton = createSymbolButton(systemName: "chevron.down", tag: 4)
    private lazy var channelLabel = createLabel(text: "CH")
    private lazy var channelStackView = createVerticalContainer(subviews: [channelUpButton, channelLabel, channelDownButton])

    // Center Buttons
    private lazy var muteButton = createCircularButton(imageName: "speaker.slash.fill", tag: 5)
    private lazy var sterikButton = createCircularButton(imageName: "asterisk", tag: 6)
    private lazy var assistantButton = createCircularButton(imageName: "ellipsis", tag: 7)
    private lazy var gearButton = createCircularButton(title: "Menu", tag: 8)
    
    private lazy var resetButton = createGradientButton(imageName: "arrow.uturn.backward", tag: 9)
    private lazy var homeButton = createGradientButton(imageName: "house", tag: 10)
    private lazy var keyboardButton = createGradientButton(imageName: "keyboard", tag: 11)
    
    private let spacing: CGFloat = 30.dp
    
    var onViewAction: ((ViewAction) -> Void)? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        // --- Create Center Grid with StackViews ---
        let topRowStackView = UIStackView(arrangedSubviews: [muteButton, assistantButton])
        topRowStackView.axis = .horizontal
        topRowStackView.distribution = .fillEqually
        topRowStackView.spacing = 20.dp

        let bottomRowStackView = UIStackView(arrangedSubviews: [sterikButton, gearButton])
        bottomRowStackView.axis = .horizontal
        bottomRowStackView.distribution = .fillEqually
        bottomRowStackView.spacing = 20.dp
        
        let centerContainerStackView = UIStackView(arrangedSubviews: [topRowStackView, bottomRowStackView])
        centerContainerStackView.axis = .vertical
        centerContainerStackView.distribution = .fillEqually
        centerContainerStackView.spacing = 20.dp
        
        let firstColView = UIView()
        firstColView.backgroundColor = .clear
        [muteButton, sterikButton].forEach({firstColView.addSubview($0)})
        muteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(muteButton.snp.width)
        }
        sterikButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(sterikButton.snp.width)
        }
        
        let lastColView = UIView()
        lastColView.backgroundColor = .clear
        [assistantButton, gearButton].forEach({lastColView.addSubview($0)})
        assistantButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(assistantButton.snp.width)
        }
        gearButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(gearButton.snp.width)
        }

        // --- Create Main Layout StackView ---
        let mainStackView = UIStackView(arrangedSubviews: [volumeStackView, firstColView, lastColView, channelStackView])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = spacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add only the main stack view to the superview
        addSubview(mainStackView)
        mainStackView.addConstraints(top: .equalToSuperView(0), left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalTo(-(calculateButtonHeight() + 20)))
        
        [resetButton, keyboardButton, homeButton].forEach({addSubview($0)})
        resetButton.addConstraints(top: .equalToWithOffset(mainStackView.snp.bottom, 20), left: .equalToSuperView(0), width: .equalTo(calculateButtonHeight()), height: .equalTo(calculateButtonHeight()))
        
        keyboardButton.addConstraints(top: .equalToWithOffset(mainStackView.snp.bottom, 0), centerX: .equalToSuperView(0), width: .equalTo(calculateButtonHeight()), height: .equalTo(calculateButtonHeight()))
        
        homeButton.addConstraints(top: .equalToWithOffset(mainStackView.snp.bottom, 20), right: .equalToSuperView(0), width: .equalTo(calculateButtonHeight()), height: .equalTo(calculateButtonHeight()))
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if (1...4).contains(sender.tag) {
            AppButtonsClickManager.shared.handleClick(for: .main) {
                let cmds: [WebOSKeyTarget] = [
                    .volumeUp, .volumeDown, .channelUp, .channelDown
                ]
                onViewAction?(.tvCommand(cmds[sender.tag - 1]))
            } limitAction: {
                if let parent = self.parentViewController as? RemoteVC {
                    parent.buttonsLimitReached(for: ButtonsType.circular)
                }
            }
        } else {
            AppButtonsClickManager.shared.handleClick(for: .others) {
                let cmds = [ViewAction.tvCommand(.mute), .tvCommand(.asterisk), .more, .tvCommand(.menu), .tvCommand(.back), .tvCommand(.home), .keyboard]
                onViewAction?(cmds[sender.tag - 5])
            } limitAction: {
                if let parent = self.parentViewController as? RemoteVC {
                    parent.buttonsLimitReached(for: ButtonsType.circular)
                }
            }
        }
//        switch sender.tag {
//        case 1:
//            onViewAction?(.tvCommand(.volumeUp))
//            break
//        case 2:
//            onViewAction?(.tvCommand(.volumeDown))
//            break
//        case 3:
//            onViewAction?(.tvCommand(.channelUp))
//            break
//        case 4:
//            onViewAction?(.tvCommand(.channelDown))
//            break
//        case 5:
//            onViewAction?(.tvCommand(.mute))
//            break
//        case 6:
//            onViewAction?(.tvCommand(.guide))
//            break
//        case 7:
//            onViewAction?(.tvCommand(.channelList))
//            break
//        case 8:
//            onViewAction?(.more)
//            break
//        case 9:
//            onViewAction?(.tvCommand(.returnKey))
//            break
//        case 10:
//            onViewAction?(.tvCommand(.home))
//            break
//        default:
//            break
//        }
    }
    
    func calculateButtonHeight() -> CGFloat {
        let margin: CGFloat = 20.dp
        let parentWidth = UIScreen.main.bounds.width
        let totalPadding: CGFloat = (UIDevice.isPad ? (margin * 7) : (margin * 1.5)) * 2
        let numberOfSubviews: CGFloat = 4
        let totalSpacing = spacing * (numberOfSubviews - 1)

        let availableWidth = parentWidth - totalPadding - totalSpacing
        let individualDimen = availableWidth / numberOfSubviews
        return individualDimen
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.appFont(ofSize: 16.dp, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createGradientButton(imageName: String, tag: Int) -> GradientButton {
        let button = GradientButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let xmarkImage = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold))
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        button.tag = tag
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func createSymbolButton(systemName: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18.dp, weight: .bold)), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }

    private func createVerticalContainer(subviews: [UIView]) -> RoundStackView {
        let stackView = RoundStackView(arrangedSubviews: subviews)
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func createCircularButton(title: String? = nil, imageName: String? = nil, tag: Int) -> GradientButton {
        let button = GradientButton(type: .system)
        button.addInnerShadow = false
        if let title = title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.appFont(ofSize: 14.dp, weight: .regular)
        } else if let imageName = imageName {
            button.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold)), for: .normal)
            button.tintColor = .white
            if imageName == "ellipsis" {
                let image = createDotsImage(circleDiameter: 7, spacing: 3)
                button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    func createDotsImage(circleDiameter: CGFloat = 40, spacing: CGFloat = 20) -> UIImage {
        //red, green, yellow, blue
        let colors: [UIColor] = [UIColor(hex: "F44336"), UIColor(hex: "4CAF50"), UIColor(hex: "FFEB3B"), UIColor(hex: "2196F3")]
        let numberOfDots = colors.count
        
        let imageWidth = CGFloat(numberOfDots) * circleDiameter + CGFloat(numberOfDots - 1) * spacing
        let imageHeight = circleDiameter
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let renderer = UIGraphicsImageRenderer(size: size, format: UIGraphicsImageRendererFormat.default())
        
        let image = renderer.image { context in
            for (index, color) in colors.enumerated() {
                let x = CGFloat(index) * (circleDiameter + spacing)
                let y: CGFloat = 0
                let rect = CGRect(x: x, y: y, width: circleDiameter, height: circleDiameter)
                
                let path = UIBezierPath(ovalIn: rect)
                color.setFill()
                path.fill()
            }
        }
        
        return image
    }

    private func createAssistantButton() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let colors: [UIColor] = [.systemBlue, .systemRed, .systemYellow, .systemGreen]
        let dotsStackView = UIStackView()
        dotsStackView.axis = .horizontal
        dotsStackView.spacing = 5
        dotsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for color in colors {
            let dot = UIView()
            dot.backgroundColor = color
            dot.layer.cornerRadius = 5
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 10),
                dot.heightAnchor.constraint(equalToConstant: 10)
            ])
            dotsStackView.addArrangedSubview(dot)
        }
        
        view.addSubview(dotsStackView)
        NSLayoutConstraint.activate([
            dotsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dotsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
}

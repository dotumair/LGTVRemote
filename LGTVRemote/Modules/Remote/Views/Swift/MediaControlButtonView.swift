
import UIKit
import WebOSClient

class MediaControlButtonView: UIView {
    
    private lazy var backwardButton = createButton(image: "backward.fill", tag: 0)
    private lazy var playButton = createButton(image: "play.fill", tag: 1)
    private lazy var pauseButton = createButton(image: "pause.fill", tag: 2)
    private lazy var forwardButton = createButton(image: "forward.fill", tag: 3)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initViews() {
        let mainStackView = UIStackView(arrangedSubviews: [backwardButton, playButton, pauseButton, forwardButton])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add only the main stack view to the superview
        addSubview(mainStackView)
        mainStackView.equalToSuperView()
    }
    
    private func createButton(image: String, tag: Int) -> GradientButton {
        let button = GradientButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let xmarkImage = UIImage(systemName: image, withConfiguration: UIImage.SymbolConfiguration(pointSize: 14.dp, weight: .regular))
        button.setImage(xmarkImage, for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        button.cornerRadius = 10
        button.tag = tag
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if (0...3).contains(sender.tag) {
            AppButtonsClickManager.shared.handleClick(for: ButtonsType.others) {
                let keys: [WebOSKeyTarget] = [
                    .rewind, .play, .pause, .fastForward
                ]
                TVHelper.shared.sendCommand(keys[sender.tag])
            } limitAction: {
                if let parent = self.parentViewController as? RemoteVC {
                    parent.buttonsLimitReached(for: ButtonsType.circular)
                }
            }
        }
    }
}

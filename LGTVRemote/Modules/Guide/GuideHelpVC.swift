
import UIKit
import BottomPopup

class GuideHelpVC: BottomPopupViewController {
    
    override var popupHeight: CGFloat {
        return 300
    }
    
    override var popupTopCornerRadius: CGFloat {
        return 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "0C111B")
        
        let dragHandleView = UIView()
        dragHandleView.translatesAutoresizingMaskIntoConstraints = false
        dragHandleView.backgroundColor = UIColor(hex: "262930")
        dragHandleView.layer.cornerRadius = 3.dp
        view.addSubview(dragHandleView)
        dragHandleView.addConstraints(top: .equalToSuperView(10.dp), centerX: .equalToSuperView(), width: .equalTo(80.dp), height: .equalTo(6.dp))
        
        let howToLabel = createLabel(text: "How to Connect", font: UIFont.appFont(ofSize: 20.dp, weight: .semibold))
        view.addSubview(howToLabel)
        howToLabel.addConstraints(top: .equalToWithOffset(dragHandleView.snp.bottom, 20.dp), centerX: .equalToSuperView())
        
        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16.dp, weight: .bold))
        closeButton.setImage(xmarkImage, for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.addConstraints(right: .equalToSuperView(-20.dp), centerY: .equalToWithOffset(howToLabel.snp.centerY, 0))
        
        let instructionsLabel = UILabel()
        let helpText = "1. Turn on your TV.\n2. Connect your phone to your WiFi Network.\n3. Connect your TV to the Same WiFi Network."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .left
        instructionsLabel.attributedText = NSMutableAttributedString(string: helpText, attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        instructionsLabel.textColor = .white
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = UIFont.appFont(ofSize: 16, weight: .medium)
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionsLabel)
        instructionsLabel.addConstraints(top: .equalToWithOffset(howToLabel.snp.bottom, 25.dp), left: .equalToSuperView(30.dp), right: .equalToSuperView(-30.dp))
    }
    
    private func createLabel(text: String, textColor: UIColor = .white, textAlignment: NSTextAlignment = .left, font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = textAlignment
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = 0
        return label
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}

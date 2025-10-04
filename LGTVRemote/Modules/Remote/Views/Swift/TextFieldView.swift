
import UIKit

class TextFieldView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Views
    
    private lazy var textField: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.tintColor = .white
        tf.font = .systemFont(ofSize: 17.dp, weight: .medium)
        return tf
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send Text", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.appFont(ofSize: 16, weight: .semibold)
        btn.backgroundColor = UIColor(hex: "262626")
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
    }
    
    // MARK: - Private Setup Methods
    
    /// Sets up the initial view hierarchy and layers.
    private func setupView() {
        // The main background of the view is clear, as the shape layers will provide the color.
        backgroundColor = UIColor(hex: "131313")
        
        addSubview(textField)
        textField.equalToSuperView(offsets: UIEdgeInsets(top: 12.dp, left: 12.dp, bottom: 12.dp, right: 12.dp))
        
        addSubview(sendButton)
        sendButton.addConstraints(right: .equalToSuperView(-15.dp), bottom: .equalToSuperView(-15.dp), width: .equalTo(100), height: .equalTo(40))
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendButtonTapped() {
        guard var text = textField.text else { return }
        if isValidText(text) {
            TVHelper.shared.sendText(text)
        }
    }
    
    func isValidText(_ text: String) -> Bool {
        // Trim whitespace and newlines from both ends
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        // Ensure trimmed string is not empty
        return !trimmed.isEmpty
    }
}


import UIKit
import BottomPopup

class KeyboardVC: BottomPopupViewController {
    
    override var popupHeight: CGFloat {
        return 250.dp
    }
    
    // MARK: - Views
    
    private lazy var textField: TextFieldView = {
        let view = TextFieldView()
        view.clipsToBounds = true
        view.cornerRadius = 20.dp
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = UIColor.background
        
        view.addSubview(textField)
        textField.addConstraints(top: .equalToSuperView(20.dp), left: .equalToSuperView(20.dp), right: .equalToSuperView(-20.dp), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, -20.dp))
    }
}

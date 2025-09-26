
import UIKit

class InAppExperienceCell: UICollectionViewCell {
    static let identifier = "InAppExperienceCell"
    
    private let stepsView: ExperienceStepsView = {
        let view = ExperienceStepsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(hex: "131313")
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(stepsView)
        stepsView.equalToSuperView(offsets: UIEdgeInsets(top: 20.dp, left: 20.dp, bottom: 20.dp, right: 20.dp))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

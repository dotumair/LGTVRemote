
import UIKit

class AppCell: UICollectionViewCell {
    static let identifier = "AppCell"
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(hex: "212121")
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        imageView.equalToSuperView(offsets: UIEdgeInsets(top: 25.dp, left: 25.dp, bottom: 25.dp, right: 25.dp))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with image: String) {
        imageView.image = UIImage(named: image)
    }
}

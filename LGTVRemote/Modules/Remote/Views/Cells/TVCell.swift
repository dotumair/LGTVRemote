
import UIKit

protocol TVCellDelegate: AnyObject {
    func tvCell(_ cell: TVCell, didTapConnectButtonFor tv: TVDevice)
}

class TVCell: UICollectionViewCell {
    static let reuseIdentifier = "TVCell"
    
    private let nameLabel = UILabel()
    private let uriLabel = UILabel()
    private let connectButton = UIButton(type: .system)
    
    var tv: TVDevice? = nil
    weak var delegate: TVCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(hex: "1B1B1B")
        contentView.layer.cornerRadius = 8.dp

        nameLabel.font = UIFont.systemFont(ofSize: 17.dp)
        nameLabel.textColor = .label
        
        uriLabel.font = UIFont.systemFont(ofSize: 13.dp)
        uriLabel.textColor = .secondaryLabel
        
        connectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.dp, weight: .medium)
        connectButton.tintColor = .white
        connectButton.setTitle("Connect", for: .normal)
        connectButton.backgroundColor = UIColor.black
        connectButton.layer.cornerRadius = 6.dp
        connectButton.addTarget(self, action: #selector(didTapConnect), for: .touchUpInside)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        uriLabel.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(uriLabel)
        contentView.addSubview(connectButton)
        
        nameLabel.addConstraints(top: .equalToSuperView(10.dp), left: .equalToSuperView(12.dp), right: .equalToSuperView(-12.dp))
        uriLabel.addConstraints(top: .equalToWithOffset(nameLabel.snp.bottom, 4.dp), left: .equalToWithOffset(nameLabel.snp.left, 0), right: .equalToWithOffset(nameLabel.snp.right, 0))
        connectButton.addConstraints(right: .equalToSuperView(-12.dp), centerY: .equalToSuperView(0), width: .equalTo(80.dp))
    }
    
    func configure(with tv: TVDevice) {
        self.tv = tv
        nameLabel.text = tv.name
        uriLabel.text = tv.host
    }
    
    @objc func didTapConnect() {
        guard let tv = self.tv else { return }
        delegate?.tvCell(self, didTapConnectButtonFor: tv)
    }
}

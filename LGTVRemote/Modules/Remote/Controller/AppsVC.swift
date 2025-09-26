
import UIKit

class AppsVC: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.register(AppCell.self, forCellWithReuseIdentifier: AppCell.identifier)
        return view
    }()
    
    private let appsDataSource: [(id: String, image: String)] = [
        (id: "netflix", image: "ntfLogo"),
        (id: "youtube.leanback.v4", image: "ytLogo"),
        (id: "amazon", image: "prmLogo"),
        (id: "spotify-beehive", image: "sptfyLogo"),
        (id: "hulu", image: "hluLogo"),
        (id: "com.hbo.hbomax", image: "hbLogo")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        //to prevent collection view cells color going to tabbar
        let placeholderView = UIView()
        placeholderView.backgroundColor = .clear
        view.addSubview(placeholderView)
        placeholderView.addConstraints(left: .equalToSuperView(0), right: .equalToSuperView(0), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, 0), height: .equalTo(1))

        view.addSubview(collectionView)
        collectionView.addConstraints(top: .equalToWithOffset(view.safeAreaLayoutGuide.snp.top, 30), left: .equalToSuperView(25), right: .equalToSuperView(-25), bottom: .equalToWithOffset(placeholderView.snp.top, -20))
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension AppsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appsDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimen = (collectionView.frame.width / 2) - 8
        let scale = 0.62
        return CGSize(width: dimen, height: dimen * scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TVHelper.shared.launchApp(app: appsDataSource[indexPath.item].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppCell.identifier, for: indexPath) as! AppCell
        cell.setupCell(with: appsDataSource[indexPath.item].image)
        return cell
    }
}

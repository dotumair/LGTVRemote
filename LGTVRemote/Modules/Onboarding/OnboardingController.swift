
import UIKit

class OnboardingController: UIViewController {
        
    private var currentIndex: Int = 0
    private let itemsCount = 4
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardCell.self, forCellWithReuseIdentifier: "OnboardCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "1584E9")
        pageControl.pageIndicatorTintColor = .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let continueButton: UIButton = {
        let button = GradientButton(type: .system)
        button.startColor = UIColor(hex: "70B9FD")
        button.endColor = UIColor(hex: "1584E9")
        button.addInnerShadow = false
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.appFont(ofSize: 18.dp, weight: .bold)
        button.backgroundColor = .main
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25.dp
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0C111B")
        
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        pageControl.numberOfPages = itemsCount
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        
        [collectionView, pageControl, continueButton].forEach({view.addSubview($0)})
        
        collectionView.equalToSuperView()
        continueButton.addConstraints(left: .equalToSuperView(20.dp), right: .equalToSuperView(-20.dp), bottom: .equalToWithOffset(view.safeAreaLayoutGuide.snp.bottom, -20.dp), height: .equalTo(50.dp))
        pageControl.addConstraints(bottom: .equalToWithOffset(continueButton.snp.top, -10.dp), centerX: .equalToSuperView(0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc private func continueTapped() {
        if currentIndex < itemsCount - 1 {
            currentIndex += 1
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = currentIndex
        } else {
            let vc = MainTabBarVC.initController(from: Storyboards.Main)
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    @objc private func pageControlChanged() {
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentIndex = pageControl.currentPage
    }
    
}

// MARK: - UICollectionView DataSource & Delegate

extension OnboardingController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardCell", for: indexPath) as! OnboardCell
        cell.configure(with: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        currentIndex = pageControl.currentPage
    }
}

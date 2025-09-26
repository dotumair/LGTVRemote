
import UIKit

class TrialStepsView: UIView {
    
    let firstStep: StepView = {
        let view = StepView(image: .proInstallIcon, title: "Install App", titleColor: UIColor.white, description: "You're all set to start your journey!", stepHeight: 25.dp)
        return view
    }()
    
    let secondStep: StepView = {
        let view = StepView(image: .proUnlockIcon, title: "Today: Unlock Full Access", titleColor: UIColor.white, description: "Enjoy premium features like unlimited email creation, advanced email tools, custom prompts, and more.", stepHeight: 60.dp)
        return view
    }()
    
    let thirdStep: StepView = {
        let view = StepView(image: .proBellIcon, title: "Day 2: Trial Reminder", titleColor: UIColor.white, description: "Heads up: Your trial will end soon.", backgroundColor: UIColor.white, stepHeight: 25.dp)
        return view
    }()
    
    let fourthStep: StepView = {
        var date = Date()
        date = date.addingTimeInterval(60 * 60 * 24 * 3)
        
        let view = StepView(image: .proCalIcon, title: "Day 3: Trial Ends", titleColor: UIColor.white, description: "You'll be charged on \(date.formatted(date: .abbreviated, time: .omitted)), unless you cancel before then", backgroundColor: UIColor.white, stepHeight: 50.dp, lastStep: true)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [secondStep,thirdStep,fourthStep])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 6.dp
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.equalToSuperView()
    }
}

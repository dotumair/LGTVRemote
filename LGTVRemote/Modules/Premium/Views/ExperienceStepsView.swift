
import UIKit

class ExperienceStepsView: UIView {
    let firstStep: StepView = {
        let view = StepView(image: UIImage(), title: "Transcription Speech with AI", titleColor: UIColor.white, description: "You're all set to start your journey!", stepHeight: 25.dp)
        return view
    }()
    
    let secondStep: StepView = {
        let view = StepView(image: UIImage(), title: "Record or import audio", titleColor: UIColor.white, description: "We’ll Notify you before your trial end. Cancel anytime..", stepHeight: 25.dp)
        return view
    }()
    
    let thirdStep: StepView = {
        let view = StepView(image: UIImage(), title: "AI quiz & Flashcards", titleColor: UIColor.white, description: "Save 50% and pay just 59.99 29.00 for a whole year of premium.", backgroundColor: UIColor.white, stepHeight: 50.dp)
        return view
    }()
    
    let fourthStep: StepView = {
        let view = StepView(image: UIImage(), title: "Smart Summarization", titleColor: UIColor.white, description: "Save 50% and pay just 59.99 29.00 for a whole year of premium. ", backgroundColor: UIColor.white, stepHeight: 50.dp, lastStep: true)
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
        let stackView = UIStackView(arrangedSubviews: [firstStep,secondStep,thirdStep,fourthStep])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 6.dp
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.equalToSuperView()
    }
}

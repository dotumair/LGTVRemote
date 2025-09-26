
import UIKit

class PageBarsView: UIView {
    
    var numberOfPages: Int = 2 {
        didSet { setNeedsDisplay() }
    }
    
    var currentPage: Int = 0 {
        didSet { setNeedsDisplay() }
    }
    
    var activeColor: UIColor = .white
    var inactiveColor: UIColor = UIColor.white.withAlphaComponent(0.2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard numberOfPages > 0 else { return }
        
        let barHeight: CGFloat = rect.height
        let totalGap: CGFloat = 20
        let totalWidth = rect.width - CGFloat(numberOfPages - 1) * totalGap
        let barWidth: CGFloat = totalWidth / CGFloat(numberOfPages)
        let cornerRadius = barHeight / 2
        
        for i in 0..<numberOfPages {
            let x = CGFloat(i) * (barWidth + totalGap)
            let barRect = CGRect(x: x,
                                 y: rect.midY - barHeight/2,
                                 width: barWidth,
                                 height: barHeight)
            let path = UIBezierPath(roundedRect: barRect, cornerRadius: cornerRadius)
            
            let color = (i <= currentPage) ? activeColor : inactiveColor
            color.setFill()
            path.fill()
        }
    }
}

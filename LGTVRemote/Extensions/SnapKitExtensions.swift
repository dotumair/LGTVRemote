
import UIKit
import SnapKit

extension UIView {
    enum SnapKitEnum {
        case equalToSuperView(_ offset: CGFloat = 0)
        case equalTo(_ value: CGFloat = 0)
        case equalToWithOffset(_ target: ConstraintRelatableTarget, _ offset: CGFloat)
    }
    
    func addConstraints(top: SnapKitEnum? = nil, left: SnapKitEnum? = nil, right: SnapKitEnum? = nil, bottom: SnapKitEnum? = nil, centerX: SnapKitEnum? = nil, centerY: SnapKitEnum? = nil, width: SnapKitEnum? = nil, height: SnapKitEnum? = nil) {
        
        self.snp.makeConstraints { make in
            if let top = top {
                switch top {
                case .equalToSuperView(offset: let offset):
                    make.top.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.top.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.top.equalTo(target).offset(offset)
                }
            }
            
            if let left = left {
                switch left {
                case .equalToSuperView(offset: let offset):
                    make.left.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.left.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.left.equalTo(target).offset(offset)
                }
            }
            
            if let right = right {
                switch right {
                case .equalToSuperView(offset: let offset):
                    make.right.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.right.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.right.equalTo(target).offset(offset)
                }
            }
            
            if let bottom = bottom {
                switch bottom {
                case .equalToSuperView(offset: let offset):
                    make.bottom.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.bottom.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.bottom.equalTo(target).offset(offset)
                }
            }
            
            if let centerY = centerY {
                switch centerY {
                case .equalToSuperView(offset: let offset):
                    make.centerY.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.centerY.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.centerY.equalTo(target).offset(offset)
                }
            }
            
            if let centerX = centerX {
                switch centerX {
                case .equalToSuperView(offset: let offset):
                    make.centerX.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.centerX.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.centerX.equalTo(target).offset(offset)
                }
            }
            
            if let height = height {
                switch height {
                case .equalToSuperView(offset: let offset):
                    make.height.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.height.equalTo(value)
                case .equalToWithOffset(let target,let offset):
                    make.height.equalTo(target).offset(offset)
                }
            }
            
            if let width = width {
                switch width {
                case .equalToSuperView(offset: let offset):
                    make.width.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.width.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.width.equalTo(target).offset(offset)
                }
            }
        }
    }
    
    func updateConstraints(top: SnapKitEnum? = nil, left: SnapKitEnum? = nil, right: SnapKitEnum? = nil, bottom: SnapKitEnum? = nil, centerX: SnapKitEnum? = nil, centerY: SnapKitEnum? = nil, width: SnapKitEnum? = nil, height: SnapKitEnum? = nil) {
        
        self.snp.updateConstraints { make in
            if let top = top {
                switch top {
                case .equalToSuperView(offset: let offset):
                    make.top.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.top.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.top.equalTo(target).offset(offset)
                }
            }
            
            if let left = left {
                switch left {
                case .equalToSuperView(offset: let offset):
                    make.left.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.left.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.left.equalTo(target).offset(offset)
                }
            }
            
            if let right = right {
                switch right {
                case .equalToSuperView(offset: let offset):
                    make.right.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.right.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.right.equalTo(target).offset(offset)
                }
            }
            
            if let bottom = bottom {
                switch bottom {
                case .equalToSuperView(offset: let offset):
                    make.bottom.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.bottom.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.bottom.equalTo(target).offset(offset)
                }
            }
            
            if let centerY = centerY {
                switch centerY {
                case .equalToSuperView(offset: let offset):
                    make.centerY.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.centerY.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.centerY.equalTo(target).offset(offset)
                }
            }
            
            if let centerX = centerX {
                switch centerX {
                case .equalToSuperView(offset: let offset):
                    make.centerX.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.centerX.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.centerX.equalTo(target).offset(offset)
                }
            }
            
            if let height = height {
                switch height {
                case .equalToSuperView(offset: let offset):
                    make.height.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.height.equalTo(value)
                case .equalToWithOffset(let target,let offset):
                    make.height.equalTo(target).offset(offset)
                }
            }
            
            if let width = width {
                switch width {
                case .equalToSuperView(offset: let offset):
                    make.width.equalToSuperview().offset(offset)
                case .equalTo(value: let value):
                    make.width.equalTo(value)
                case .equalToWithOffset(let target, let offset):
                    make.width.equalTo(target).offset(offset)
                }
            }
            
            self.layoutIfNeeded()
        }
    }
    
    func equalToSuperView() {
        self.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    func equalToSuperView(offsets: UIEdgeInsets) {
        self.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(offsets.left)
            make.right.equalToSuperview().offset(-offsets.right)
            make.bottom.equalToSuperview().offset(-offsets.bottom)
            make.top.equalToSuperview().offset(offsets.top)
        }
    }
}


import UIKit
import SwiftUI

class SelectRemoteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        
        setupViews()
    }
    
    private func setupViews() {
        let contentView = SelectRemoteView()
        let hostingController = UIHostingController(rootView: contentView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // 4. Set up constraints for the hosting controller's view.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.equalToSuperView()
    }
}

struct SelectRemoteView: View {
    
    @State private var selectedRemoteId: Int?
    
    // --- GRID LAYOUT DEFINITION ---
    
    // Defines a two-column grid with flexible-width columns and spacing.
    private let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // --- BODY ---
    
    var body: some View {
        ZStack {
            // Background Layer
            Color.background.ignoresSafeArea()
            
            // Content Layer
            VStack(spacing: 24) {
                // Screen Title
                Text("Select remote")
                    .font(.appFont(ofSize: 20.dp, weight: .semibold))
                    .foregroundColor(.white)
                
                // Scrollable Grid of Remotes
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: gridColumns, spacing: 16) {
                        ForEach(0...14, id: \.self) { index in
                            RemoteCell(
                                index: index,
                                isSelected: index == selectedRemoteId
                            )
                            .onTapGesture {
                                // Update the selected ID when a cell is tapped
                                withAnimation(.spring()) {
                                    selectedRemoteId = index
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

// MARK: - Subviews

// Represents a single cell in the remote selection grid.
// Breaking this out makes the main view's body cleaner and promotes reusability.
struct RemoteCell: View {
    let index: Int
    let isSelected: Bool
    
    var body: some View {
        Image("tv_\(index + 1)_remote")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
            .frame(height: 220) // Fixed height for uniform cells
            .frame(maxWidth: .infinity)
            .background(Color.init(uiColor: UIColor(hex: "1D1D1D")))
            .cornerRadius(12)
            .overlay(
                SelectionIndicator(isSelected: isSelected)
            )
    }
}

// A view for the selection border and the checkmark icon.
// Encapsulating this logic keeps the RemoteCell clean.
struct SelectionIndicator: View {
    let isSelected: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Pink selection border
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isSelected ? Color.foreground : Color.clear,
                    lineWidth: 2.5
                )
            
            // Checkmark icon
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .font(.title)
                    .foregroundColor(.foreground)
                    .background(Circle().fill(Color.white))
                    .padding(10)
                    .transition(.scale.combined(with: .opacity)) // Animate appearance
            }
        }
    }
}

// MARK: - Preview
// The #Preview macro lets you see your UI design in Xcode without running the app.
#Preview {
    SelectRemoteView()
}

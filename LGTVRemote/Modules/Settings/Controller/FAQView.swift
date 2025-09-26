
import SwiftUI

// MARK: - Model

/// A single FAQ item (question + answer + expanded state).
struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    var isExpanded: Bool = false
}

// MARK: - ViewModel

/// Holds an array of FAQ items (using your provided content, re‐numbered with a., b., c. and i., ii., iii. for nested bullets).
class FAQViewModel: ObservableObject {
    @Published var items: [FAQItem] = [
        FAQItem(
            question: "Why is there still no free space on my phone after cleaning it?",
            answer:
            """
            a.  Cleaner’s cleaning process follows the same procedure as the iOS Photos app: any deleted photos or videos will be moved to the Recently Deleted album in your library for 30 days. As a result, they will still occupy space on your phone. To free up this space, open the Photos app on your iPhone and navigate to the Recently Deleted album.
            
            b. Select the photos or videos you wish to delete and tap Delete.
            
            c. Remember, deleting files from the Recently Deleted album will permanently remove them from your phone.
            
            """
        ),
        FAQItem(
            question: "How can I recover deleted photos and videos?",
            answer:
            """
            a.  If you accidentally deleted a photo or video, don’t worry. Cleaner’s cleaning process follows the same procedure as the iOS Photos app: deleted photos and videos are moved to the Recently Deleted album in your library for 30 days. This means you can recover deleted files within 30 days if needed. After that, iOS automatically deletes them from your iPhone.
            
            b. To recover a photo or video deleted within the last 30 days, follow these steps:
            
               i.   Open the Photos app on your phone and go to the Recently Deleted album.
            
               ii.  Tap Select in the top-right corner.
            
               iii. Choose the files you want to restore, then tap Recover.
            
               iv.  If you want to recover everything in the Recently Deleted album, tap Select and then Recover All. Note that this album contains both manually deleted photos and those removed by Cleaner.
            
            """
        ),
        FAQItem(
            question: "Can Cleaner guarantee that my photos won’t be uploaded anywhere?",
            answer:
            """
            a.  Cleaner doesn’t need an internet connection, so it doesn’t upload your photos anywhere. It scans and analyzes your photos directly on your phone. The app only sends anonymous technical logs, like app crashes. 
            
            b. To scan your photo library, Cleaner needs your permission and may use info like whether a photo was edited, favorited, or has face detection data.
            
            """
        ),
        FAQItem(
            question: "How does Cleaner select the best photos?",
            answer:
            """
            a.  Cleaner uses face recognition and compares similar photos, taking into account edited or favorited images.
            
            b. It then selects the “Best Result” based on its algorithm. However, you should always check the app’s suggestions to make sure they match what you want.
            
            """
        ),
        FAQItem(
            question: "Can I use Cleaner on my other Apple devices?",
            answer:
            """
            a.  Cleaner works only on iPhones with iOS 14 or higher.
            
            b. The number of devices you can use with your subscription is based on the App Store’s subscription terms and conditions.
            
            """
        ),
        FAQItem(
            question: "How do I cancel my subscription?",
            answer:
            """
            You can cancel your Cleanup subscription like any other App Store subscription:
               a.  Go to Settings on your iPhone.
            
               b.  Tap on your Apple ID name at the top of the screen, then select “View Apple ID” under iTunes & App Stores.
            
               c.  Tap on “Subscriptions” and then select “Cleanup.”
            
               d.  Finally, tap “Cancel Subscription” at the bottom of the screen.
            
            """
        ),
        FAQItem(
            question: "How can I scan the photos in my Photo Library?",
            answer:
            """
            a.  When you open Cleaner for the first time, it will automatically scan and analyze your photos.
            
            b. If you have a lot of pictures, it might take a little while and use some resources, so just be patient! After the first scan, Cleaner will only check for the newest changes, making future scans quicker and easier. 😊
            
            """
        ),
        FAQItem(
            question: "How does Cleaner organize photos?",
            answer:
            """
            Cleaner organizes your photos into four categories: Similar, Duplicates, Screenshots, and Other. Here’s how each category works:
            
               a.  Similar
                    This includes nearly identical photos, usually taken around the same time and featuring the same objects or people with similar backgrounds, even if taken from different angles. Cleaner will identify a set of similar photos, mark one as the “Best Result,” and select the rest for you to delete.
            
               b.  Duplicates
                    This category includes photos that are exact copies of each other. You can delete all duplicates at once while keeping the original versions.
            
               c.  Screenshots
                    Screenshots in your library will be grouped here. Cleaner will automatically mark them for removal but leaves the final decision to you. If there are screenshots you want to keep, simply add them to your Keep List.
            
               d.  Other
                    Photos that don’t fall into the above categories are grouped here. Cleaner makes it easy to review these photos, swipe through them, and clean your library.
            
            """
        ),
        FAQItem(
            question: "What does Cleaner classify as “Similar”?",
            answer:
            """
            a.  Cleaner groups similar photos into sets, typically taken within seconds of each other, showing the same subject or background with slight variations in pose or angle (e.g., someone posing in front of a museum).
            
            b. Using advanced detection, Cleaner selects the Best Result from each set and marks the rest for removal, excluding favorited photos. Be sure to review the selections before starting the cleanup process.
            
            """
        ),
        FAQItem(
            question: "What does Cleaner classify as “Other”?",
            answer:
            """
            The “Other” category includes photos that don’t fit into any of the other categories. Cleaner won’t suggest which ones to keep or delete but lets you decide using a simple swipe mechanism—swipe right to keep and left to delete.
            
            """
        ),
        FAQItem(
            question: "How do I review all photos in a specific category?",
            answer:
            """
            To view a photo up close, simply tap on it. In the Similar category, photos are grouped into sets by creation date. Scroll through the sets and tap any to view. For other categories, photos aren’t grouped, so just scroll and tap to review individual images.
            
            """
        ),
        FAQItem(
            question: "How can I delete unwanted photos?",
            answer:
            """
            a.  Cleaner will suggest photos for removal, marked with a red checkmark. Select the photos to delete, then tap Delete. Make sure to move photos you want to keep to your Keep List.
            
            b. Open the Similar category, choose a set, and decide what to keep or remove. If you agree with the app’s suggestion, tap Move to Trash. If not, unmark the ones you want to keep, add them to the Keep List, and mark those to delete. Once done, tap the trash bin and Delete to complete the process.
            
            """
        ),
        FAQItem(
            question: "How can I use the swiping feature?",
            answer:
            """
            Cleaner makes it easy and fun to browse Videos and Other categories. Swipe left to remove a photo, right to keep it. Your progress is saved, and deletion is final once the session is complete.
            
            """
        ),
        FAQItem(
            question: "Can I delete videos using Cleaner?",
            answer:
            """
            Yes, you can. While analyzing and sorting videos by similarity is resource-intensive, Cleaner lists all your videos in the Videos category. You can sort them by size or date and swipe left or right to keep or delete. Plus, Cleaner also offers a video compression feature.
            
            """
        ),
        FAQItem(
            question: "Should I review all the photos scanned by Cleaner?",
            answer:
            """
            Yes, we recommend reviewing all the photos before deleting any. Cleaner uses smart algorithms to group and suggest photos, but you may not always agree. While it speeds up the process, the final decision is yours to ensure no important photos are deleted.
            """
        )
    ]
}

// MARK: - FAQRowView

/// A single FAQ row: shows the question with a plus/minus icon, and conditionally shows the answer when expanded.
/// 
struct FAQRowView: View {
    @Binding var item: FAQItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(item.question)
                    .font(.appFont(ofSize: 16.dp, weight: .semibold))
                    .foregroundColor(.white)
                    .lineSpacing(1.0)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.foreground)
                        .frame(width: 24, height: 24)
                    Image(systemName: item.isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                }.padding(.trailing, 0)
            }
            .padding(20)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    item.isExpanded.toggle()
                }
            }

            // Answer body (only if expanded)
            if item.isExpanded {
                Text(item.answer)
                    .font(.appFont(ofSize: 16.dp, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .lineSpacing(1.0)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.init(uiColor: UIColor(hex: "131313")))
        .cornerRadius(20)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct FAQView: View {
    @StateObject private var viewModel = FAQViewModel()

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach($viewModel.items) { $item in
                            FAQRowView(item: $item)
                        }
                    }
                    .padding(.top, 10)
                }
                .background(Color.background.edgesIgnoringSafeArea(.all))
                .navigationTitle("FAQ")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: Button(action: {
                    if let topViewController = UIApplication.topViewController() {
                        topViewController.navigationController?.popViewController(animated: true)
                    }
                }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .font(.system(size: 12, weight: .bold))
                        .frame(width: 16,height: 16)
                        .foregroundColor(.white)
                }))
            }
            // Force dark mode styling (optional)
            .preferredColorScheme(.dark)
        }
    }
}

#Preview(body: {
    FAQView()
})

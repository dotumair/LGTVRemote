
import UIKit

class PushTransitionStyle: NSObject, UIViewControllerTransitioningDelegate {

    // This method is called when PRESENTING a view controller
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushTransitor() // Use our custom push animator
    }

    // This method is called when DISMISSING a view controller
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopTransitor() // Use our custom pop animator for the reverse
    }
}

fileprivate class PushTransitor: NSObject, UIViewControllerAnimatedTransitioning {

    // 1. Define the duration of the transition
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    // 2. Define the animation itself
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get the view controllers and views from the context
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }

        let containerView = transitionContext.containerView
        let toView = toViewController.view!
        let fromView = fromViewController.view!

        // The final frame for the incoming view is the container's bounds
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        
        // --- Setup the initial state ---
        // Add the incoming view to the container
        containerView.addSubview(toView)
        // Position the incoming view offscreen to the right
        toView.frame = finalFrame.offsetBy(dx: containerView.bounds.width, dy: 0)

        // --- Animate to the final state ---
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        // Move the incoming view to its final position (on-screen)
                        toView.frame = finalFrame
                        // Move the outgoing view slightly to the left to create a parallax effect
                        fromView.frame = finalFrame.offsetBy(dx: -containerView.bounds.width / 3, dy: 0)
        }) { _ in
            // --- Clean up ---
            // Tell the system the transition is complete
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

fileprivate class PopTransitor: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        let containerView = transitionContext.containerView
        let toView = toViewController.view!
        let fromView = fromViewController.view!
        
        // Add the view we are returning TO, placing it behind the current view
        containerView.insertSubview(toView, belowSubview: fromView)

        // --- Setup the initial state ---
        // Position the "to" view (the one we're returning to) offscreen to the left
        toView.frame = transitionContext.finalFrame(for: toViewController).offsetBy(dx: -containerView.bounds.width / 3, dy: 0)

        // --- Animate to the final state ---
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        // Move the "from" view (the one being dismissed) offscreen to the right
                        fromView.frame = fromView.frame.offsetBy(dx: containerView.bounds.width, dy: 0)
                        // Move the "to" view back to its final on-screen position
                        toView.frame = transitionContext.finalFrame(for: toViewController)
        }) { _ in
            // --- Clean up ---
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

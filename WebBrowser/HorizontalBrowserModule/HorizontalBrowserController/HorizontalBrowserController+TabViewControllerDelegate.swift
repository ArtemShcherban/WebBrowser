//
//  HorizontalBrowserController+TabViewControllerDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 21.02.2023.
//

import UIKit

extension HorizontalBrowserController {
    override func tabViewControllerDidScroll(yOffsetChange: CGFloat) {
        let toolbarHeight = horizontalBrowserView.toolbar.frame.height
        let fractionComplete = abs(yOffsetChange) / toolbarHeight
        let isScrollingDown = yOffsetChange < 0
        
        if isScrollingDown && toolbarIsHide == false {
            guard !isCollapsed else { return }
            
            if collapsingToolbarAnimator == nil || collapsingToolbarAnimator?.state == .inactive {
                setupCollapsingToolbarAnimator()
            }
            
            if fractionComplete < 1 {
                collapsingToolbarAnimator?.fractionComplete = fractionComplete
            } else {
                isCollapsed = true
                collapsingToolbarAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0.1)
            }
        } else {
            guard isCollapsed && toolbarIsHide == false else { return }
            if expandingToolbarAnimator == nil || expandingToolbarAnimator?.state == .inactive {
                setupExpandingToolbarAnimator()
            }
            
            if yOffsetChange > toolbarHeight {
                isCollapsed = false
                expandingToolbarAnimator?.startAnimation()
            }
        }
    }
    
    override func tabViewControllerDidEndDraging(yOffsetChange: CGFloat = 0.0) {
        if
            let collapsingToolbarAnimator,
            collapsingToolbarAnimator.state == .active,
            !isCollapsed {
            if abs(yOffsetChange) > 35 {
                isCollapsed = true
                collapsingToolbarAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.1)
            } else {
                reverseCollapsingToolbarAnimation()
            }
        }
        collapsingToolbarAnimator = nil
        expandingToolbarAnimator = nil
    }
}

extension HorizontalBrowserController {
    override func setupCollapsingToolbarAnimator() {
        collapsingToolbarAnimator?.stopAnimation(true)
        collapsingToolbarAnimator?.finishAnimation(at: .current)
        
        collapsingToolbarAnimator = AnimatorFactory.animator(
            for: horizontalBrowserView,
            duration: 0.2,
            animation: {
                if self.toolbarIsHide {
                    self.horizontalBrowserView.toolbarHalfCollapseAnimation()
                } else {
                    self.horizontalBrowserView.toolbarFullCollapseAnimation()
                }
            },
            completion: nil
        )
        collapsingToolbarAnimator?.pauseAnimation()
    }
    
    override func setupExpandingToolbarAnimator() {
        expandingToolbarAnimator = AnimatorFactory.animator(
            for: horizontalBrowserView,
            duration: 0.1,
            animation: {
                self.horizontalBrowserView.toolbarFullExpandAnimation()
            },
            completion: nil
        )
    }
    
    private func reverseCollapsingToolbarAnimation() {
        guard let collapsingToolbarAnimator else { return }
        collapsingToolbarAnimator.stopAnimation(true)
        collapsingToolbarAnimator.finishAnimation(at: .current)
        let reverseAnimator = AnimatorFactory.animator(
            for: horizontalBrowserView,
            duration: 0.1,
            animation: horizontalBrowserView.toolbarFullExpandAnimation,
            completion: nil
        )
        reverseAnimator.startAnimation()
    }
}

extension HorizontalBrowserController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y == 0.0 && toolbarIsHide == false {
            isCollapsed = false
            expandingToolbarAnimator?.startAnimation()
        }
    }
}

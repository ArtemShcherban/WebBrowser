//
//  VerticalBrowserController+TabViewControllerDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 21.02.2023.
//

import UIKit

extension VerticalBrowserController {
    override func tabViewControllerDidScroll(yOffsetChange: CGFloat) {
        let offsetChangeBeforeFullAnimation: CGFloat = 30
        let animationFractionComplete = abs(yOffsetChange) / offsetChangeBeforeFullAnimation
        let thresholdBeforeAnimationComplete: CGFloat = 0.6
        let isScrollingDown = yOffsetChange < 0
        
        if isScrollingDown && toolbarIsHide == false {
            guard !isCollapsed else { return }
            
            if collapsingToolbarAnimator == nil || collapsingToolbarAnimator?.state == .inactive {
                setupCollapsingToolbarAnimator()
            }
            
            if animationFractionComplete < thresholdBeforeAnimationComplete {
                collapsingToolbarAnimator?.fractionComplete = animationFractionComplete
            } else {
                isCollapsed = true
                collapsingToolbarAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        } else {
            guard isCollapsed && toolbarIsHide == false else { return }
            
            if expandingToolbarAnimator == nil || expandingToolbarAnimator?.state == .inactive {
                setupExpandingToolbarAnimator()
            }
            
            if animationFractionComplete < thresholdBeforeAnimationComplete {
                expandingToolbarAnimator?.fractionComplete = animationFractionComplete
            } else {
                isCollapsed = false
                expandingToolbarAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        }
    }
    
    override func tabViewControllerDidEndDraging(yOffsetChange: CGFloat = 0.0) {
        if
            let collapsingToolbarAnimator,
            collapsingToolbarAnimator.state == .active,
            !isCollapsed {
            reverseCollapsingToolbarAnimation()
        }
        
        if
            let expandingToolbarAnimator,
            expandingToolbarAnimator.state == .active,
            isCollapsed {
            reverseExpandingToolbarAnimation()
        }
        collapsingToolbarAnimator = nil
        expandingToolbarAnimator = nil
    }
}

extension VerticalBrowserController {
    override func setupCollapsingToolbarAnimator() {
        collapsingToolbarAnimator?.stopAnimation(true)
        collapsingToolbarAnimator?.finishAnimation(at: .current)
        
        collapsingToolbarAnimator = AnimatorFactory.animator(
            for: verticalBrowserView,
            duration: 0.1,
            animation: {
                self.verticalBrowserView.toolbarHalfCollapseAnimation()
            },
            completion: {
                self.verticalBrowserView.toolbarFullCollapseAnimation()
                let addressBarTransformAnimator = AnimatorFactory.animator(
                    for: self.verticalBrowserView,
                    duration: 0.2,
                    animation: {
                        self.verticalBrowserView.addressBarScalingDownAnimation()
                    },
                    completion: nil
                )
                addressBarTransformAnimator.startAnimation()
            }
        )
        collapsingToolbarAnimator?.pauseAnimation()
    }
    
    @objc func reverseCollapsingToolbarAnimation() {
        // isReversed property does not work correctly with autolayout constraints so we have to manually animate back collapsing state
        // http://www.openradar.me/34674968
        
        guard let collapsingToolbarAnimator else { return }
        verticalBrowserView.toolbarHalfCollapseAnimation()
        verticalBrowserView.layoutIfNeeded()
        collapsingToolbarAnimator.stopAnimation(true)
        collapsingToolbarAnimator.finishAnimation(at: .current)
        verticalBrowserView.toolbarFullExpandAnimation()
        let addressBarTransformAnimator = AnimatorFactory.animator(
            for: verticalBrowserView,
            duration: 0.1,
            animation: verticalBrowserView.addressBarScalingUpAnimation,
            completion: nil
        )
        addressBarTransformAnimator.startAnimation()
    }
    
    override func setupExpandingToolbarAnimator() {
        expandingToolbarAnimator?.stopAnimation(true)
        expandingToolbarAnimator?.finishAnimation(at: .current)
        
        expandingToolbarAnimator = AnimatorFactory.animator(
            for: verticalBrowserView,
            duration: 0.1,
            animation: {
                self.verticalBrowserView.toolbarHalfExpandAnimation()
            },
            completion: {
                self.verticalBrowserView.toolbarFullExpandAnimation()
                let addressBarTransformAnimator = AnimatorFactory.animator(
                    for: self.verticalBrowserView,
                    duration: 0.2,
                    animation: {
                        self.verticalBrowserView.addressBarScalingUpAnimation()
                    },
                    completion: nil
                )
                addressBarTransformAnimator.startAnimation()
            })
        expandingToolbarAnimator?.pauseAnimation()
    }
    
    @objc func reverseExpandingToolbarAnimation() {
        guard let expandingToolbarAnimator else { return }
        verticalBrowserView.toolbarHalfCollapseAnimation()
        verticalBrowserView.layoutIfNeeded()
        expandingToolbarAnimator.stopAnimation(true)
        expandingToolbarAnimator.finishAnimation(at: .current)
        verticalBrowserView.toolbarFullCollapseAnimation()
        let addressBarTransformAnimator = AnimatorFactory.animator(
            for: verticalBrowserView,
            duration: 0.1,
            animation: verticalBrowserView.addressBarScalingDownAnimation,
            completion: nil
        )
        addressBarTransformAnimator.startAnimation()
    }
}

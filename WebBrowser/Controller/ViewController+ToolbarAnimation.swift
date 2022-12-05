//
//  ViewController+ToolbarAnimation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit

extension ViewController: TabViewControllerDelegate {
    func tabViewControllerDidScroll(yOffsetChange: CGFloat) {
        let offsetChangeBeforeFullAnimation: CGFloat = 30
        let animationFractionComplete = abs(yOffsetChange) / offsetChangeBeforeFullAnimation
        let thresholdBeforeAnimationComplete: CGFloat = 0.6
        let isScrollingDown = yOffsetChange < 0
        
        if isScrollingDown {
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
            guard isCollapsed else { return }
            
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
    
    func tabViewControllerDidEndDraging() {
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
    
    func tabViewController(_ tabViewController: TabViewController, didStartLoadingURL url: URL) {
        guard
            let tabIndex = tabViewControllers.firstIndex(of: tabViewController),
            let addressBar = webBrowserView.addressBars[safe: tabIndex] else {
            return
        }
        addressBar.setLoadingProgress(0, animated: false)
        addressBar.domainLabel.text = webBrowserModel.getDomain(from: url)
    }
    
    func tabViewController(_ tabViewController: TabViewController, didChangeLoadingProgressTo progress: Float) {
        guard
            let tabIndex = tabViewControllers.firstIndex(of: tabViewController),
            let addressBar = webBrowserView.addressBars[safe: tabIndex] else {
            return
        }
        addressBar.setLoadingProgress(progress, animated: true)
    }
}

extension ViewController {
    func setupCollapsingToolbarAnimator() {
        collapsingToolbarAnimator?.stopAnimation(true)
        collapsingToolbarAnimator?.finishAnimation(at: .current)
        
        webBrowserView.addressBarScrollViewBottomConstraint?.constant =
        webBrowserView.addressBarCollapsingHalfwayBottomOffset
        
        webBrowserView.toolbarBottomConstraint?.constant =
        webBrowserView.toolbarCollapsingHalfwayBottomOffset
        
        collapsingToolbarAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .linear) { [weak self] in
            self?.setAddressBarContainersAlpha(0.0)
            self?.webBrowserView.layoutIfNeeded()
        }
        collapsingToolbarAnimator?.addCompletion { [weak self] _ in
            guard let self else { return }
            self.webBrowserView.addressBarScrollViewBottomConstraint?.constant =
            self.webBrowserView.addressBarCollapsingFullyBottomOffset
            
            self.webBrowserView.toolbarBottomConstraint?.constant =
            self.webBrowserView.toolbarCollapsingFullyBottomOffset
            
            UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) { [weak self] in
                guard let self else { return }
                self.currentAddressBar.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 0.8)
                self.currentAddressBar.domainLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.leftAddressBar?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 0.8)
                self.rightAddressBar?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 0.8)
                self.webBrowserView.addressBarScrollView.isScrollEnabled = false
                self.webBrowserView.layoutIfNeeded()
            }.startAnimation()
        }
        collapsingToolbarAnimator?.pauseAnimation()
    }
    
    func reverseCollapsingToolbarAnimation() {
        // isReversed property does not work correctly with autolayout constraints so we have to manually animate back collapsing state
        // http://www.openradar.me/34674968
        
        guard let collapsingToolbarAnimator else { return }
        
        webBrowserView.addressBarScrollViewBottomConstraint?.constant =
        webBrowserView.addressBarCollapsingHalfwayBottomOffset *
        collapsingToolbarAnimator.fractionComplete
        
        webBrowserView.toolbarBottomConstraint?.constant =
        webBrowserView.toolbarCollapsingHalfwayBottomOffset *
        collapsingToolbarAnimator.fractionComplete
        
        webBrowserView.layoutIfNeeded()
        collapsingToolbarAnimator.stopAnimation(true)
        collapsingToolbarAnimator.finishAnimation(at: .current)
        
        webBrowserView.addressBarScrollViewBottomConstraint?.constant =
        webBrowserView.addressBarExpandingFullyBottomOffset
        
        webBrowserView.toolbarBottomConstraint?.constant = 0
        
        UIViewPropertyAnimator(duration: 0.1, curve: .linear) { [weak self] in
            self?.setAddressBarContainersAlpha(1)
            self?.webBrowserView.layoutIfNeeded()
        }.startAnimation()
    }
    
    func setupExpandingToolbarAnimator() {
        expandingToolbarAnimator?.stopAnimation(true)
        expandingToolbarAnimator?.finishAnimation(at: .current)
        webBrowserView.addressBarScrollViewBottomConstraint?.constant =
        webBrowserView.addressBarExpandingHalfwayBottomOffset
        webBrowserView.toolbarBottomConstraint?.constant =
        webBrowserView.toolBarExpandingHalfwayBottomOffset
        
        expandingToolbarAnimator = UIViewPropertyAnimator(duration: 0.1, curve: .linear) {[weak self] in
            self?.webBrowserView.layoutIfNeeded()
        }
        expandingToolbarAnimator?.addCompletion { [weak self] _ in
            guard let self else { return }
            self.webBrowserView.addressBarScrollViewBottomConstraint?.constant =
            self.webBrowserView.addressBarExpandingFullyBottomOffset
            self.webBrowserView.toolbarBottomConstraint?.constant =
            self.webBrowserView.toolBarExpandingFullyBottomOffset
            UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) { [weak self] in
                guard let self else { return }
                self.currentAddressBar.containerView.transform = .identity
                self.currentAddressBar.domainLabel.transform = .identity
                self.leftAddressBar?.containerView.transform = .identity
                self.rightAddressBar?.containerView.transform = .identity
                self.webBrowserView.addressBarScrollView.isScrollEnabled = true
                self.setAddressBarContainersAlpha(1)
                self.webBrowserView.layoutIfNeeded()
            }.startAnimation()
        }
        expandingToolbarAnimator?.pauseAnimation()
    }
    
    func reverseExpandingToolbarAnimation() {
        guard let expandingToolbarAnimator else { return }
        
        webBrowserView.addressBarScrollViewBottomConstraint?.constant =
        webBrowserView.addressBarExpandingHalfwayBottomOffset *
        expandingToolbarAnimator.fractionComplete
        
        webBrowserView.toolbarBottomConstraint?.constant =
        webBrowserView.toolBarExpandingHalfwayBottomOffset *
        expandingToolbarAnimator.fractionComplete
        
        webBrowserView.layoutIfNeeded()
        expandingToolbarAnimator.stopAnimation(true)
        expandingToolbarAnimator.finishAnimation(at: .current)
        
        webBrowserView.addressBarScrollViewBottomConstraint?.constant =
        webBrowserView.addressBarCollapsingFullyBottomOffset
        
        webBrowserView.toolbarBottomConstraint?.constant =
        webBrowserView.toolBarExpandingFullyBottomOffset
        
        UIViewPropertyAnimator(duration: 0.1, curve: .linear) { [weak self] in
            self?.setAddressBarContainersAlpha(0)
            self?.webBrowserView.layoutIfNeeded()
        }.startAnimation()
    }
    
    private func setAddressBarContainersAlpha(_ alpha: CGFloat) {
        currentAddressBar.containerView.alpha = alpha
        leftAddressBar?.containerView.alpha = alpha
        
        let rightAddressBarIndex = currentTabIndex + 1
        if !hasHiddenTab || rightAddressBarIndex < tabViewControllers.count - 1 {
            rightAddressBar?.containerView.alpha = alpha
        }
    }
}

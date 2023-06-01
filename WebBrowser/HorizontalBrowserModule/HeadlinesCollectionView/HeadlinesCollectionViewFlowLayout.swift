//
//  HeadlinesCollectionViewFlowLayout.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 22.05.2023.
//

import UIKit
import RxDataSources

class HeadlinesCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private var dragOffset: CGFloat {
        return itemWidth
    }
    
    var cache: [UICollectionViewLayoutAttributes] = []
    private var insertingIndexPaths: [IndexPath] = []
    private var updatingIndexPaths: [IndexPath] = []
    
    var numberOfItems: Int {
        guard let collectionView else { return 0 }
        return collectionView.numberOfItems(inSection: 0)
    }
    
    var itemWidth: CGFloat {
        guard let collectionView else { return 0.0 }
        if numberOfItems < 7 {
            return round(collectionView.bounds.width / CGFloat(numberOfItems))
        } else {
            return round(collectionView.bounds.width / 7)
        }
    }
    
    var itemHeight: CGFloat {
        guard let collectionView else { return 0.0 }
        return collectionView.bounds.height
    }
    
    var leftmostItemIndex: Int {
        guard let collectionView else { return 0 }
        let leftmostItemIndex = max(Int(collectionView.contentOffset.x / dragOffset), 0)
        return leftmostItemIndex
    }
    
    var rightmostItemIndex: Int {
        guard
            let collectionView,
            collectionView.contentOffset.x > 0 else { return 6 }
        return 6 + Int(collectionView.contentOffset.x / itemWidth + 1)
    }
    
    var nextItemPercentageOffset: CGFloat {
        guard let collectionView else { return 0 }
        return collectionView.contentOffset.x / dragOffset - CGFloat(leftmostItemIndex)
    }
}

extension HeadlinesCollectionViewFlowLayout {
    override var collectionViewContentSize: CGSize {
        let contentWidth = itemWidth * CGFloat(numberOfItems)
        return CGSize(width: contentWidth, height: itemHeight)
    }
    
    override func prepare() {
        guard let collectionView else { return }
        cache.removeAll(keepingCapacity: false)
        var x: CGFloat = 0.0

        for item in 0..<numberOfItems {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            attributes.zIndex = rightmostItemIndex > item ? item : 0

            if item == leftmostItemIndex {
                x = max(collectionView.contentOffset.x, 0)
            } else if item == leftmostItemIndex + 1 {
                let xOffset = max((itemWidth * nextItemPercentageOffset), 0)
                x -= xOffset
            }

            if item == rightmostItemIndex {
                x = collectionView.bounds.maxX - itemWidth
            }

            let frame = CGRect(x: x, y: 0, width: itemWidth, height: itemHeight)
            attributes.frame = frame
            cache.append(attributes)
            x = frame.maxX
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let collectionView else { return .zero }
        return collectionView.contentOffset
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPaths.removeAll()
        updatingIndexPaths.removeAll()

        for updateItem in updateItems {
            if
                let indexPath = updateItem.indexPathAfterUpdate,
                updateItem.updateAction == .insert {
                insertingIndexPaths.append(indexPath)
            } else if updateItem.updateAction == .delete {
                guard let collectionView else { return }
                updatingIndexPaths = collectionView.indexPathsForVisibleItems
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        insertingIndexPaths.removeAll()
        updatingIndexPaths.removeAll()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard
            let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {
            return nil
        }
        
        if insertingIndexPaths.contains(itemIndexPath) {
            attributes.transform = translationTransform
        } else if
            !updatingIndexPaths.isEmpty,
            let maxIndexPath = updatingIndexPaths.max(by: { $0.row < $1.row }),
            maxIndexPath == itemIndexPath {
            attributes.transform = translationTransform
        }
        
        return attributes
    }
    
    private var translationTransform: CGAffineTransform {
        guard let collectionView else { return CGAffineTransform() }
        return CGAffineTransform(
            translationX: collectionView.bounds.maxX + collectionView.bounds.width * 0.1,
            y: collectionView.bounds.midY)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}

class DublicateLayout: HeadlinesCollectionViewFlowLayout {
    override func prepare() {
        guard let collectionView else { return }
        cache.removeAll(keepingCapacity: false)
        var x: CGFloat = 0.0
        
        for item in 0..<numberOfItems {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: 0))
            attributes.zIndex = rightmostItemIndex > item ? item : 0
            
            if item == leftmostItemIndex {
                x = max(collectionView.contentOffset.x, 0)
            } else if item == leftmostItemIndex + 1 {
                let xOffset = max((itemWidth * nextItemPercentageOffset), 0)
                x -= xOffset
            }
            
            let frame = CGRect(x: x, y: 0, width: itemWidth, height: itemHeight)
            attributes.frame = frame
            cache.append(attributes)
            x = frame.maxX
        }
    }
}

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
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var insertingIndexPaths: [IndexPath] = []
    
    private var numberOfItems: Int {
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
    
    private var itemHeight: CGFloat {
        guard let collectionView else { return 0.0 }
        return collectionView.bounds.height
    }
    
    private var leftmostItemIndex: Int {
        guard let collectionView else { return 0 }
        let leftmostItemIndex = max(Int(collectionView.contentOffset.x / dragOffset), 0)
        return leftmostItemIndex
    }
    
    private var rightmostItemIndex: Int {
        guard
            let collectionView,
            collectionView.contentOffset.x > 0 else { return 6 }
        return 6 + Int(collectionView.contentOffset.x / itemWidth + 1)
    }
    
    private var nextItemPercentageOffset: CGFloat {
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
            attributes.zIndex = item
            
            if item == leftmostItemIndex {
                x = max(collectionView.contentOffset.x, 0)
            } else if item == leftmostItemIndex + 1 {
                let xOffset = max((itemWidth * nextItemPercentageOffset), 0)
                x -= xOffset
            }
            
            if item == rightmostItemIndex {
                attributes.zIndex = 0
                x = collectionView.bounds.width + collectionView.contentOffset.x - itemWidth
            }
            
            let frame = CGRect(x: x, y: 0, width: itemWidth, height: itemHeight)
            attributes.frame = frame
            cache.append(attributes)
            x = frame.maxX
        }
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPaths.removeAll()
        
        for updateItem in updateItems {
            if
                let indexPath = updateItem.indexPathAfterUpdate,
                updateItem.updateAction == .insert {
                insertingIndexPaths.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        insertingIndexPaths.removeAll()
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
            var attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath),
            let collectionView = collectionView else { return nil }
        
        if insertingIndexPaths.contains(itemIndexPath) {
            attributes.transform = CGAffineTransform(
                translationX: collectionView.bounds.maxX + collectionView.bounds.width * 0.1,
                y: collectionView.bounds.midY)
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}

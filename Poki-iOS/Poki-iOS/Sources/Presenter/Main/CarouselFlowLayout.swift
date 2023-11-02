//
//  CarouselFlowLayout.swift
//  Poki-iOS
//
//  Created by Insu on 11/2/23.
//

import UIKit

final class CarouselFlowLayout: UICollectionViewFlowLayout {
    public var sideItemScale: CGFloat = 0.5
    public var sideItemAlpha: CGFloat = 0.5
    public var spacing: CGFloat = 10

    public var isPagingEnabled: Bool = true
    
    private var isSetup: Bool = false
    
    override public func prepare() {
        super.prepare()
        if isSetup == false {
            setupLayout()
            isSetup = true
        }
    }
    
    private func setupLayout() {
        guard let collectionView = self.collectionView else { return }
                
        let collectionViewSize = collectionView.bounds.size
        
        let xInset = (collectionViewSize.width - self.itemSize.width) / 2
        let yInset = (collectionViewSize.height - self.itemSize.height) / 2
        
        self.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let itemWidth = self.itemSize.width
        
        let scaledItemOffset = (itemWidth - (itemWidth * (self.sideItemScale + (1 - self.sideItemScale) / 2))) / 2
        self.minimumLineSpacing = spacing - scaledItemOffset

        self.scrollDirection = .horizontal
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
              let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
        else { return nil }
        
        return attributes.map { self.transformLayoutAttributes(attributes: $0) }
    }
    
    private func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard let collectionView = self.collectionView else { return attributes }
        
        let collectionCenter = collectionView.frame.size.width / 2
        let contentOffset = collectionView.contentOffset.x
        let center = attributes.center.x - contentOffset
        
        let maxDistance = 2 * (self.itemSize.width + self.minimumLineSpacing)
        let distance = min(abs(collectionCenter - center), maxDistance)

        let ratio = (maxDistance - distance) / maxDistance

        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        
        attributes.alpha = alpha
        
        if abs(collectionCenter - center) > maxDistance + 1 {
            attributes.alpha = 0
        }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let dist = attributes.frame.midX - visibleRect.midX
        var transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        transform = CATransform3DTranslate(transform, 0, 0, -abs(dist / 1000))
        attributes.transform3D = transform
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView,
              let nearestAttribute = findNearestAttribute(toX: proposedContentOffset.x)
        else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        return CGPoint(x: nearestAttribute.center.x - collectionView.bounds.width * 0.5, y: proposedContentOffset.y)
    }

    private func findNearestAttribute(toX position: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }

        let searchRect = CGRect(x: position - collectionView.bounds.width, y: 0, width: collectionView.bounds.width * 2, height: collectionView.bounds.height)

        guard let attributes = super.layoutAttributesForElements(in: searchRect) else { return nil }

        var closestAttribute: UICollectionViewLayoutAttributes?

        for attribute in attributes {
            let distance = abs(attribute.center.x - position - collectionView.bounds.width * 0.5)
            if closestAttribute == nil || distance < abs(closestAttribute!.center.x - position - collectionView.bounds.width * 0.5) {
                closestAttribute = attribute
            }
        }

        return closestAttribute
    }
}

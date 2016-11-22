//
//  HorizontalCardsLayout.swift
//  HorizontalCollectionViewIssue
//
//  Created by Konstantin Pavlikhin on 17/10/2016.
//  Copyright © 2016 Konstantin Pavlikhin. All rights reserved.
//

import AppKit

// For reference see NSCollectionViewFlowLayout implementation in UIFoundation private framework.
class HorizontalCardsLayout : NSCollectionViewLayout
{
  // This is insane...
  open var scrollDirection: NSCollectionViewScrollDirection
  {
    get
    {
      return .horizontal
    }
  }

  public var margins: EdgeInsets = NSEdgeInsetsMake(20, 20, 20, 20)
  {
    didSet
    {
      if !NSEdgeInsetsEqual(margins, oldValue)
      {
        invalidateLayoutOfAllItems()
      }
    }
  }

  public var interitemSpacing: CGFloat = 20
  {
    didSet
    {
      if !interitemSpacing.isEqual(to: oldValue)
      {
        invalidateLayoutOfAllItems()
      }
    }
  }

  // Width / height ratio.
  public var itemAspect: CGFloat = 1
  {
    didSet
    {
      if !itemAspect.isEqual(to: oldValue)
      {
        invalidateLayoutOfAllItems()
      }
    }
  }

  private func invalidateLayoutOfAllItems()
  {
    let context = NSCollectionViewLayoutInvalidationContext()

    var indexPaths: Set<IndexPath> = []

    for n in 0..<numberOfItems
    {
      indexPaths.insert(IndexPath(item: n, section: 0))
    }

    context.invalidateItems(at: indexPaths)

    invalidateLayout(with: context)
  }

  override open func invalidateLayout(with context: NSCollectionViewLayoutInvalidationContext)
  {
    super.invalidateLayout(with: context)

    if context.invalidateDataSourceCounts
    {
      let currentNumberOfItems = numberOfItems

      for index in attributesCache.keys
      {
        if index >= currentNumberOfItems
        {
          attributesCache.removeValue(forKey: index)
        }
      }
    }
    else if let invalidatedItemIndexPaths = context.invalidatedItemIndexPaths
    {
      let indices = invalidatedItemIndexPaths.map({ (indexPath) -> Int in
        return indexPath.item
      })

      for index in indices
      {
        attributesCache.removeValue(forKey: index)
      }
    }
  }

  private var lastKnownClipViewHeight: CGFloat = 0

  private var itemSize: NSSize
  {
    get
    {
      let height = lastKnownClipViewHeight - (margins.top + margins.bottom)

      return NSSize(width: height * itemAspect, height: height)
    }
  }

  private var attributesCache: [Int: NSCollectionViewLayoutAttributes] = [:]

  private func backingAlignedFrame(fotItemAt index: Int) -> NSRect
  {
    let x = margins.left + (itemSize.width + interitemSpacing) * CGFloat(index)

    let nonAlignedFrame = NSMakeRect(x, margins.bottom, itemSize.width, itemSize.height)

    return collectionView?.backingAlignedRect(nonAlignedFrame, options: [.alignAllEdgesNearest]) ?? nonAlignedFrame
  }

  override open func prepare()
  {
    super.prepare()

    lastKnownClipViewHeight = collectionView?.enclosingScrollView?.contentView.bounds.height ?? 0

    // Prepare the layout attributes in advance.
    for i in 0..<numberOfItems
    {
      if attributesCache[i] == nil
      {
        attributesCache[i] = layoutAttributesForItem(at: IndexPath(item: i, section: 0))
      }
    }
  }

  private var numberOfItems: Int
  {
    get
    {
      return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
  }

  override open func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes]
  {
    let intersected = attributesCache.values.flatMap { (attributes) -> NSCollectionViewLayoutAttributes? in
      NSIntersectsRect(rect, attributes.frame) ? attributes : nil
    }

    return Array(intersected)
  }

  override open func layoutAttributesForItem(at indexPath: IndexPath) -> NSCollectionViewLayoutAttributes?
  {
    let attributes = NSCollectionViewLayoutAttributes(forItemWith: indexPath)

    attributes.frame = backingAlignedFrame(fotItemAt: indexPath.item)

    return attributes
  }

  // Этот метод вызывается при скроллинге!
  override open func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool
  {
    let newBoundsHeight = newBounds.height

    if newBoundsHeight != lastKnownClipViewHeight
    {
      lastKnownClipViewHeight = newBoundsHeight

      return true
    }
    else
    {
      return false
    }
  }

  override open func invalidationContext(forBoundsChange newBounds: NSRect) -> NSCollectionViewLayoutInvalidationContext
  {
    let context = super.invalidationContext(forBoundsChange: newBounds)

    var indexPaths: Set<IndexPath> = []

    for n in 0..<numberOfItems
    {
      indexPaths.insert(IndexPath(item: n, section: 0))
    }

    context.invalidateItems(at: indexPaths)

    return context
  }

  override var collectionViewContentSize: NSSize
  {
    guard numberOfItems > 0 else
    {
      return NSZeroSize
    }

    let width = margins.left + itemSize.width * CGFloat(numberOfItems) + interitemSpacing * CGFloat(numberOfItems - 1) + margins.right

    return NSMakeSize(ceil(width), lastKnownClipViewHeight)
  }
}

//
//  Controller.swift
//  HorizontalCollectionViewIssue
//
//  Created by Konstantin Pavlikhin on 17/10/2016.
//  Copyright © 2016 Konstantin Pavlikhin. All rights reserved.
//

import AppKit

class Controller: NSObject, NSCollectionViewDataSource, NSCollectionViewDelegate
{
  var thingies: [Int] = []

  @IBOutlet var collectionView: NSCollectionView!

  // MARK: NSObject Overrides

  override public func awakeFromNib()
  {
    super.awakeFromNib()

    thingies = Array(0...42)

    // * * *.

    collectionView.register(NSNib(nibNamed: "SnippetCell", bundle: nil), forItemWithIdentifier: "SnippetCell")

    // * * *.

    collectionView.reloadData()
  }

  // MARK: - NSCollectionViewDataSource Protocol Implementation

  public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int
  {
    return thingies.count
  }

  public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem
  {
    let cell = collectionView.makeItem(withIdentifier: "SnippetCell", for: indexPath)

    cell.representedObject = thingies[indexPath.item]

    return cell
  }

  public func numberOfSections(in collectionView: NSCollectionView) -> Int
  {
    return 1
  }

  // MARK: - NSCollectionViewDelegate Protocol Implementation
}

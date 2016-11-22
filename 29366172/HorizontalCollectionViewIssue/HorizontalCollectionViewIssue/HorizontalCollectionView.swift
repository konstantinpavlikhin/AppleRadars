//
//  HorizontalCollectionView.swift
//  HorizontalCollectionViewIssue
//
//  Created by Konstantin Pavlikhin on 18/10/2016.
//  Copyright © 2016 Konstantin Pavlikhin. All rights reserved.
//

import AppKit

public class HorizontalCollectionView: NSCollectionView
{
  override public func awakeFromNib()
  {
    super.awakeFromNib()

    layer?.backgroundColor = NSColor.yellow.withAlphaComponent(0.3).cgColor
  }
}

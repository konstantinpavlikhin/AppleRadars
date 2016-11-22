//
//  SnippetCell.swift
//  HorizontalCollectionViewIssue
//
//  Created by Konstantin Pavlikhin on 17/10/2016.
//  Copyright © 2016 Konstantin Pavlikhin. All rights reserved.
//

import AppKit

class SnippetCell: NSCollectionViewItem
{
  // MARK: NSObject Overrides

  override public func awakeFromNib()
  {
    super.awakeFromNib()

    // * * *.

    view.layer?.backgroundColor = NSColor.green.withAlphaComponent(0.4).cgColor

    view.layer?.cornerRadius = 7

    view.layer?.borderWidth = 2

    view.layer?.borderColor = NSColor.black.cgColor
  }
}

//
//  HeightValueTableCellView.m
//  OutlineViewRowHeightIssue
//
//  Created by Konstantin Pavlikhin on 20.10.15.
//  Copyright © 2015 Konstantin Pavlikhin. All rights reserved.
//

#import "HeightValueTableCellView.h"

@implementation HeightValueTableCellView

- (void) setFrame: (NSRect) frame
{
  [super setFrame: frame];

  // * * *.

  self.label.stringValue = [NSString stringWithFormat: @"↕ %.2f", frame.size.height];
}

@end

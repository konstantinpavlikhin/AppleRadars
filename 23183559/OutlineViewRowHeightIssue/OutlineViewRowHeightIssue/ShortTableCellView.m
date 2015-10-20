//
//  ShortTableCellView.m
//  OutlineViewConstraintsIssue
//
//  Created by Konstantin Pavlikhin on 04/09/15.
//  Copyright (c) 2015 Konstantin Pavlikhin. All rights reserved.
//

#import "ShortTableCellView.h"

@implementation ShortTableCellView

- (void) setFrame: (NSRect) frame
{
  [super setFrame: frame];

  // * * *.

  self.heightLabel.stringValue = [NSString stringWithFormat: @"↕ %.2f points", self.frame.size.height];
}

- (void) setObjectValue: (id) objectValue
{
  [super setObjectValue: objectValue];

  // * * *.

  self.label.objectValue = [NSString stringWithFormat: @"Section (%@ nested objects)", @(((NSArray*)objectValue).count)];
}

- (void) setBackgroundStyle: (NSBackgroundStyle) backgroundStyle
{
  [super setBackgroundStyle: backgroundStyle];

  // * * *.

  ((NSTextFieldCell*)[self.label cell]).backgroundStyle = backgroundStyle;

  ((NSTextFieldCell*)[self.heightLabel cell]).backgroundStyle = backgroundStyle;
}

@end

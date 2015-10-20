//
//  TallTableCellView.m
//  OutlineViewConstraintsIssue
//
//  Created by Konstantin Pavlikhin on 04/09/15.
//  Copyright (c) 2015 Konstantin Pavlikhin. All rights reserved.
//

#import "TallTableCellView.h"

@implementation TallTableCellView

- (void) awakeFromNib
{
  [super awakeFromNib];

  // * * *.

  [self.label bind: @"value" toObject: self withKeyPath: @"objectValue" options: nil];
}

@end

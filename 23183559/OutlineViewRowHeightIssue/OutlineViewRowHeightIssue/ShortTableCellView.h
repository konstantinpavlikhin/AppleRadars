//
//  ShortTableCellView.h
//  OutlineViewConstraintsIssue
//
//  Created by Konstantin Pavlikhin on 04/09/15.
//  Copyright (c) 2015 Konstantin Pavlikhin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ShortTableCellView : NSTableCellView

@property(readwrite, strong, nonatomic) IBOutlet NSTextField* label;

@property(readwrite, strong, nonatomic) IBOutlet NSTextField* heightLabel;

@end

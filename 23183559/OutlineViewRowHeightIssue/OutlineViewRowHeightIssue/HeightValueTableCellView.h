//
//  HeightValueTableCellView.h
//  OutlineViewRowHeightIssue
//
//  Created by Konstantin Pavlikhin on 20.10.15.
//  Copyright © 2015 Konstantin Pavlikhin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HeightValueTableCellView : NSTableCellView

@property(readwrite, strong, nonatomic) IBOutlet NSTextField* label;

@end

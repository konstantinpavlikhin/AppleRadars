//
//  AppDelegate.m
//  OutlineViewRowHeightIssue
//
//  Created by Konstantin Pavlikhin on 20.10.15.
//  Copyright © 2015 Konstantin Pavlikhin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property(weak) IBOutlet NSWindow *window;

@property(readwrite, strong, nonatomic) IBOutlet NSOutlineView* outlineView;

@end

@implementation AppDelegate
{
  NSMutableArray* _sections;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  _sections = [NSMutableArray array];

  // * * *.

  for(NSUInteger i = 0; i < 1; i++)
  {
    NSMutableArray* const nestedArray = [NSMutableArray array];

    for(NSUInteger j = 0; j < 5; j++)
    {
      [nestedArray addObject: [NSString stringWithFormat: @"Nested item #%lu", j]];
    }

    [_sections addObject: nestedArray];
  }

  // * * *.

  self.outlineView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleSourceList;

  self.outlineView.rowHeight = 1;

  self.outlineView.intercellSpacing = NSMakeSize(0, 0);

  // * * *.

  {{
    [self.outlineView registerNib: [[NSNib alloc] initWithNibNamed: @"ShortTableCellView" bundle: nil] forIdentifier: @"ShortTableCellView"];

    [self.outlineView registerNib: [[NSNib alloc] initWithNibNamed: @"TallTableCellView" bundle: nil] forIdentifier: @"TallTableCellView"];

    [self.outlineView registerNib: [[NSNib alloc] initWithNibNamed: @"HeightValueTableCellView" bundle: nil] forIdentifier: @"HeightValueTableCellView"];
  }}

  // * * *.

  [self.outlineView reloadData];
}

#pragma mark - Interface Callbacks

- (IBAction) insertNewSectionAtTheBeginningButtonDown: (id) sender
{
  [_sections insertObject: @[] atIndex: 0];

  [self.outlineView insertItemsAtIndexes: [NSIndexSet indexSetWithIndex: 0] inParent: nil withAnimation: NSTableViewAnimationEffectNone];
}

#pragma mark - NSOutlineViewDataSource Protocol Implementation

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable id)item
{
  if(!item)
  {
    return _sections.count;
  }
  else if([item isKindOfClass: [NSArray class]])
  {
    return ((NSArray*)item).count;
  }
  else if([item isKindOfClass: [NSString class]])
  {
    return 0;
  }
  else
  {
    return 0;
  }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable id)item
{
  if(!item)
  {
    return _sections[index];
  }
  else if([item isKindOfClass: [NSArray class]])
  {
    return ((NSArray*)item)[index];
  }
  else if([item isKindOfClass: [NSString class]])
  {
    return nil;
  }
  else
  {
    return nil;
  }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
  return [_sections containsObject: item];
}

- (id) outlineView: (NSOutlineView*) outlineView objectValueForTableColumn: (NSTableColumn*) tableColumn byItem: (id) item
{
  return item;
}

#pragma mark - NSOutlineViewDelegate Protocol Implementation

- (nullable NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(nullable NSTableColumn *)tableColumn item:(id)item
{
  if([item isKindOfClass: [NSArray class]])
  {
    if([tableColumn.identifier isEqualToString: @"MainColumn"] || !tableColumn)
    {
      return [outlineView makeViewWithIdentifier: @"ShortTableCellView" owner: nil];
    }
    else
    {
      return nil;
    }
  }
  else if([item isKindOfClass: [NSString class]])
  {
    if([tableColumn.identifier isEqualToString: @"MainColumn"])
    {
      return [outlineView makeViewWithIdentifier: @"TallTableCellView" owner: nil];
    }
    else if([tableColumn.identifier isEqualToString: @"SecondaryColumn"])
    {
      return [outlineView makeViewWithIdentifier: @"HeightValueTableCellView" owner: nil];
    }
    else
    {
      return nil;
    }
  }
  else
  {
    return nil;
  }
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
  if([item isKindOfClass: [NSArray class]])
  {
    return 24;
  }
  else if([item isKindOfClass: [NSString class]])
  {
    return 32;
  }
  else
  {
    return 0;
  }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
  return [_sections containsObject: item];
}

@end

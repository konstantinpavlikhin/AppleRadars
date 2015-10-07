//
//  AppDelegate.m
//  OutlineViewConstraintsIssue
//
//  Created by Konstantin Pavlikhin on 04/09/15.
//  Copyright (c) 2015 Konstantin Pavlikhin. All rights reserved.
//

#import "AppDelegate.h"

#import "TallTableCellView.h"

#import "ShortTableCellView.h"

// * * *.

@interface AppDelegate () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (weak) IBOutlet NSWindow* window;

@property(readwrite, strong, nonatomic) IBOutlet NSOutlineView* outlineView;

@end

// * * *.

@implementation AppDelegate
{
  NSMutableArray* _groups;
}

- (void) applicationDidFinishLaunching: (NSNotification*) aNotification
{
  _groups = [NSMutableArray array];

  // * * *.

  for(NSUInteger i = 0; i < 100; i++)
  {
    NSMutableArray* const nestedArray = [NSMutableArray array];

    for(NSUInteger j = 0; j < 10; j++)
    {
      [nestedArray addObject: [NSString stringWithFormat: @"Nested item number %lu", j]];
    }

    [_groups addObject: nestedArray];
  }

  // * * *.

  {{
    [self.outlineView registerNib: [[NSNib alloc] initWithNibNamed: @"TallTableCellView" bundle: nil] forIdentifier: @"TallTableCellView"];

    [self.outlineView registerNib: [[NSNib alloc] initWithNibNamed: @"ShortTableCellView" bundle: nil] forIdentifier: @"ShortTableCellView"];
  }}

  // * * *.

  [self.outlineView reloadData];
}

#pragma mark - Private Methods

// No caching is made for the sake of simplicity.
- (CGFloat) _heightOfPrototypeCellWithClass: (Class) class nibName: (NSString*) nibName columnWidth: (CGFloat) columnWidth
{
  NSArray* topLevelObjects = nil;

  __unused const BOOL result = [[[NSNib alloc] initWithNibNamed: nibName bundle: nil] instantiateWithOwner: nil topLevelObjects: &topLevelObjects];

  NSAssert(result, @"Unable to instantiate nib file.");

  NSPredicate* const predicate = [NSPredicate predicateWithFormat: @"self isKindOfClass: %@", class];

  NSTableCellView* const prototype = [[topLevelObjects filteredArrayUsingPredicate: predicate] firstObject];

  NSLayoutConstraint* const widthConstraint = [NSLayoutConstraint constraintWithItem: prototype attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1 constant: 0];

  widthConstraint.constant = columnWidth;

  [prototype addConstraint: widthConstraint];

  [prototype layoutSubtreeIfNeeded];

  return [prototype fittingSize].height;
}

#pragma mark - NSOutlineViewDataSource Implementation

- (NSInteger) outlineView: (NSOutlineView*) outlineView numberOfChildrenOfItem: (id) item
{
  if(!item)
  {
    return _groups.count;
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

- (id) outlineView: (NSOutlineView*) outlineView child: (NSInteger) index ofItem: (id) item
{
  if(!item)
  {
    return _groups[index];
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

- (BOOL) outlineView: (NSOutlineView*) outlineView isItemExpandable: (id) item
{
  return [item isKindOfClass: [NSArray class]];
}

- (id) outlineView: (NSOutlineView*) outlineView objectValueForTableColumn: (NSTableColumn*) tableColumn byItem: (id) item
{
  return item;
}

#pragma mark - NSOutlineViewDelegate Implementation

- (NSView*) outlineView: (NSOutlineView*) outlineView viewForTableColumn: (NSTableColumn*) tableColumn item: (id) item
{
  if([item isKindOfClass: [NSArray class]])
  {
    return [outlineView makeViewWithIdentifier: @"TallTableCellView" owner: nil];
  }
  else if([item isKindOfClass: [NSString class]])
  {
    return [outlineView makeViewWithIdentifier: @"ShortTableCellView" owner: nil];
  }

  return nil;
}

- (CGFloat) outlineView: (NSOutlineView*) outlineView heightOfRowByItem: (id) item
{
  const CGFloat columnWidth = [outlineView tableColumnWithIdentifier: @"MainColumn"].width;

  // * * *.

  if([item isKindOfClass: [NSArray class]])
  {
    return [self _heightOfPrototypeCellWithClass: [TallTableCellView class] nibName: @"TallTableCellView" columnWidth: columnWidth];
  }
  else if([item isKindOfClass: [NSString class]])
  {
    return [self _heightOfPrototypeCellWithClass: [ShortTableCellView class] nibName: @"ShortTableCellView" columnWidth: columnWidth];
  }

  return 0;
}

- (BOOL) outlineView: (NSOutlineView*) outlineView shouldSelectItem: (id) item
{
  return YES;
}

@end

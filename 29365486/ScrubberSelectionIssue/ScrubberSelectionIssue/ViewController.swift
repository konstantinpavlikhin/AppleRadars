//
//  ViewController.swift
//  ScrubberSelectionIssue
//
//  Created by Konstantin Pavlikhin on 22/11/2016.
//  Copyright © 2016 Konstantin Pavlikhin. All rights reserved.
//

import Cocoa

fileprivate extension NSTouchBarItemIdentifier {

    static let elementsItemIdentifier = NSTouchBarItemIdentifier("com.konstantinpavlikhin.ScrubberSelectionIssue.TouchBarItem.Elements")
}

class ViewController: NSViewController, NSTouchBarDelegate, NSScrubberDataSource, NSScrubberDelegate, NSScrubberFlowLayoutDelegate {

    var elements: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    var elementsScrubber: NSScrubber?

    @IBAction
    public func addButtonDown(_ sender: AnyObject?) {
        elements.append(elements.last! + 1)

        elementsScrubber?.performSequentialBatchUpdates {
            elementsScrubber?.insertItems(at: IndexSet(integer: elements.count - 1))
        }
    }

    private func elementName(for index: Int) -> String {
        return "Element \(elements[index])"
    }

    private static let elementItemIdentifier = "ElementItemIdentifier"

    // MARK: NSResponder Overrides
    override public func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()

        // No customization for now.
        touchBar.customizationIdentifier = nil

        touchBar.customizationAllowedItemIdentifiers = []

        touchBar.customizationRequiredItemIdentifiers = []

        touchBar.defaultItemIdentifiers = [.elementsItemIdentifier]

        touchBar.principalItemIdentifier = nil

        touchBar.delegate = self
        
        return touchBar
    }

    // MARK: NSTouchBarDelegate Protocol Implementation

    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {

        switch identifier {
            case NSTouchBarItemIdentifier.elementsItemIdentifier:
                let customItem = NSCustomTouchBarItem(identifier: identifier)

                customItem.view = {
                    let scrubber = NSScrubber(frame: NSZeroRect)

                    // Register an item view class before setting a delegate!
                    scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: ViewController.elementItemIdentifier)

                    scrubber.dataSource = self

                    scrubber.delegate = self

                    scrubber.scrubberLayout = {
                        let layout = NSScrubberFlowLayout()

                        layout.itemSpacing = 5

                        return layout
                    }()

                    scrubber.selectedIndex = -1

                    scrubber.mode = .free

                    scrubber.itemAlignment = .none

                    scrubber.isContinuous = false

                    scrubber.floatsSelectionViews = false

                    scrubber.selectionBackgroundStyle = nil

                    scrubber.selectionOverlayStyle = NSScrubberSelectionStyle.outlineOverlay

                    scrubber.showsArrowButtons = false

                    scrubber.showsAdditionalContentIndicators = true

                    scrubber.backgroundColor = nil

                    scrubber.backgroundView = nil

                    scrubber.reloadData()

                    scrubber.selectedIndex = elements.endIndex - 1

                    scrubber.scrollItem(at: scrubber.selectedIndex, to: .none)

                    elementsScrubber = scrubber

                    return scrubber
                }()

                customItem.customizationLabel = "Elements"

                return customItem

            default:
                return nil
        }
    }

    // MARK: NSScrubberDataSource Protocol Implementation
    public func numberOfItems(for scrubber: NSScrubber) -> Int {
        return elements.count
    }

    public func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        let itemView = scrubber.makeItem(withIdentifier: type(of: self).elementItemIdentifier, owner: nil) as! NSScrubberTextItemView

        itemView.textField.stringValue = elementName(for: index)

        return itemView
    }

    // MARK: NSScrubberDelegate Protocol Implementation

    public func scrubber(_ scrubber: NSScrubber, didSelectItemAt selectedIndex: Int) {
    }

    public func scrubber(_ scrubber: NSScrubber, didHighlightItemAt highlightedIndex: Int) {
    }

    // MARK: NSScrubberFlowLayoutDelegate Protocol Implementation

    private static let elementItemPrototype = NSScrubberTextItemView(frame: NSZeroRect)

    public func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {

        ViewController.elementItemPrototype.textField.stringValue = elementName(for: itemIndex)

        let additionalPadding: CGFloat = 5

        return NSMakeSize(additionalPadding + ViewController.elementItemPrototype.fittingSize.width + additionalPadding, 30)
    }
}

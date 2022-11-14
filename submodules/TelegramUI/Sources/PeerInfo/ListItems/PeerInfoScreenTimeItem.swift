import Foundation
import UIKit
import AsyncDisplayKit
import Display
import TelegramPresentationData
import ItemListAddressItem
import SwiftSignalKit
import AccountContext
import Postbox
import PeerInfoUI
import ItemListUI

final class PeerInfoScreenTimeItem: PeerInfoScreenItem {
    let id: AnyHashable
    
    init(
        id: AnyHashable
    ) {
        self.id = id
    }

    func node() -> PeerInfoScreenItemNode {
        return PeerInfoScreenTimeItemNode()
    }
}

private final class PeerInfoScreenTimeItemNode: PeerInfoScreenItemNode {
    //private var itemNode: ItemListTimeItemNode?

    private var item: PeerInfoScreenTimeItem?
    private var itemNode: ItemListTimeItemNode?

    override init() {
        super.init()
    }

    override func update(width: CGFloat, safeInsets: UIEdgeInsets, presentationData: PresentationData, item: PeerInfoScreenItem, topItem: PeerInfoScreenItem?, bottomItem: PeerInfoScreenItem?, hasCorners: Bool, transition: ContainedViewLayoutTransition) -> CGFloat {
        guard let item = item as? PeerInfoScreenTimeItem else {
            return 10.0
        }
        
        self.item = item

        let sideInset: CGFloat = 16.0 + safeInsets.left

        let itemNode: ItemListTimeItemNode
        if let current = self.itemNode {
            itemNode = current
            updateNode(width: width)
            /*
            addressItem.updateNode(async: { $0() }, node: {
                return itemNode
            }, params: params, previousItem: nil, nextItem: nil, animation: .None, completion: { (layout, apply) in
                let nodeFrame = CGRect(origin: CGPoint(), size: CGSize(width: width, height: layout.size.height))

                itemNode.contentSize = layout.contentSize
                itemNode.insets = layout.insets
                itemNode.frame = nodeFrame

                apply(ListViewItemApply(isOnScreen: true))
            })*/
        } else {
            itemNode = TextNode()
            self.itemNode = itemNode
            self.addSubnode(itemNode)
            updateNode(width: width)
            /*
            var itemNodeValue: ListViewItemNode?
            addressItem.nodeConfiguredForParams(async: { $0() }, params: params, synchronousLoads: false, previousItem: nil, nextItem: nil, completion: { node, apply in
                itemNodeValue = node
                apply().1(ListViewItemApply(isOnScreen: true))
            })
            itemNode = itemNodeValue as! ItemListCallListItemNode
            itemNode.isUserInteractionEnabled = false
            self.itemNode = itemNode
            self.addSubnode(itemNode)*/
        }


        let height : CGFloat = 20// itemNode.calculatedSize.height

        transition.updateFrame(node: itemNode, frame: CGRect(origin: CGPoint(), size: itemNode.bounds.size))
        
        return height + 20
    }

    func updateNode(width: CGFloat) {
        Queue.mainQueue().async {
            let makeLayout = TextNode.asyncLayout(self.itemNode)

            /*let (layout, apply) = makeLayout(
             TextNodeLayoutArguments(
             attributedString:NSAttributedString(
             string: "Moscow Time"),
             maximumNumberOfLines:1,
             truncationType: .end))*/

            let (_, apply) = makeLayout(
                TextNodeLayoutArguments(
                    attributedString: NSAttributedString(
                        string: "Moscow Time"),
                    maximumNumberOfLines: 1,
                    truncationType: .end,
                    constrainedSize: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                    alignment: .left,
                    verticalAlignment: .top,
                    lineSpacing: 0))

            Queue.mainQueue().async {
                    //completion(layout, { _ in
                _ = apply()
                    //})
            }
        }
    }
}


public class ItemListTimeItemNode: ListViewItemNode {
    let titleNode: TextNode
}



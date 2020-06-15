//
//  RxTableViewSectionedReloadDataSource.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 6/27/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if !RX_NO_MODULE
    import RxCocoa
    import RxSwift
#endif

#if os(iOS) || os(tvOS)
    import Differentiator
    import Foundation
    import UIKit

    open class RxTableViewSectionedReloadDataSource<Section: SectionModelType>:
        TableViewSectionedDataSource<Section>,
        RxTableViewDataSourceType {
        public typealias Element = [Section]

        open func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
            Binder(self) { dataSource, element in
                #if DEBUG
                    dataSource._dataSourceBound = true
                #endif
                dataSource.setSections(element)
                tableView.reloadData()
            }.on(observedEvent)
        }
    }

#elseif os(macOS)

    import AppKit
    import Foundation

    open class RxTableViewReloadDataSource<Item>:
        TableViewDataSource<Item>,
        RxTableViewDataSourceType {
        public typealias Element = [Item]

        open func tableView(_ tableView: NSTableView, observedEvent: Event<Element>) {
            Binder(self) { dataSource, element in
                #if DEBUG
                    dataSource._dataSourceBound = true
                #endif
                dataSource.setItems(element)
                tableView.reloadData()
            }.on(observedEvent)
        }
    }

#endif

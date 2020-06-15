//
//  TableViewDataSource.swift
//  RxDataSources
//
//  Created by Fabian Mücke on 15.06.20.
//  Copyright © 2020 kzaher. All rights reserved.
//

#if os(macOS)

    import AppKit
    import Foundation
    #if !RX_NO_MODULE
        import RxCocoa
    #endif
    import Differentiator

    open class TableViewDataSource<Item>:
        NSObject,
        NSTableViewDataSource,
        SectionedViewDataSourceType {
        public typealias ConfigureCell = (TableViewDataSource<Item>, NSTableView, NSTableColumn?, Int, Item) -> Any?

        public init(configureCell: @escaping ConfigureCell) {
            self.configureCell = configureCell
        }

        #if DEBUG
            // If data source has already been bound, then mutating it
            // afterwards isn't something desired.
            // This simulates immutability after binding
            var _dataSourceBound: Bool = false

            private func ensureNotMutatedAfterBinding() {
                assert(
                    !_dataSourceBound,
                    "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions."
                )
            }

        #endif

        private var _items: [Item] = []

        open var items: [Item] { _items }

        open subscript(index: Int) -> Item {
            _items[index]
        }

        open subscript(indexPath: IndexPath) -> Item {
            get { _items[indexPath.item] }
            set(item) { _items[indexPath.item] = item }
        }

        open func model(at indexPath: IndexPath) throws -> Any {
            self[indexPath]
        }

        open func setItems(_ items: [Item]) {
            _items = items
        }

        open var configureCell: ConfigureCell {
            didSet {
                #if DEBUG
                    ensureNotMutatedAfterBinding()
                #endif
            }
        }

        // MARK: - NSTableViewDataSource

        public func numberOfRows(in tableView: NSTableView) -> Int {
            _items.count
        }

        public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
            precondition(row < _items.count)

            return configureCell(self, tableView, tableColumn, row, self[row])
        }
    }

#endif

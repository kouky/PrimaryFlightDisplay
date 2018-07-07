//
//  TapeCellTriad.swift
//  PrimaryFlightDisplay
//
//  Created by Michael Koukoullis on 6/02/2016.
//  Copyright © 2016 Michael Koukoullis. All rights reserved.
//

typealias TapeCellStatus = (containsValue: Bool, cell: TapeCell)


class TapeCellTriad {
    
    private let cells: [TapeCell]
    
    init(cell1: TapeCell, cell2: TapeCell, cell3: TapeCell) {
        cells = [cell1, cell2, cell3]
    }
    
    func statusForValue(value: Double) throws -> (TapeCellStatus, TapeCellStatus, TapeCellStatus) {
        let statusCells = try cells
            .sorted { (a, b) throws in a.model.midValue < b.model.midValue }
            .map    { ($0.model.containsValue(value: value), $0) }
        return (statusCells[0], statusCells[1], statusCells[2])
    }
}

extension TapeCellTriad : Sequence {
    func makeIterator() -> Array<TapeCell>.Iterator {
        return cells.makeIterator()
    }
}

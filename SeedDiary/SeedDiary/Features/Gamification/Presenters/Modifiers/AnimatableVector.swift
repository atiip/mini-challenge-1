//
//  AnimatableVector.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 01/08/23.
//

import enum Accelerate.vDSP
import SwiftUI

struct AnimatableVector: VectorArithmetic {
    var values: [Float]
    
    static var zero = AnimatableVector(values: [0.0])

    static func + (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = min(lhs.values.count, rhs.values.count)
        return AnimatableVector(
            values: vDSP.add(
                lhs.values[0..<count],
                rhs.values[0..<count]
            )
        )
    }

    static func += (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = min(lhs.values.count, rhs.values.count)
        vDSP.add(
            lhs.values[0..<count],
            rhs.values[0..<count],
            result: &lhs.values[0..<count]
        )
    }

    static func - (lhs: AnimatableVector, rhs: AnimatableVector) -> AnimatableVector {
        let count = min(lhs.values.count, rhs.values.count)
        return AnimatableVector(
            values: vDSP.subtract(
                lhs.values[0..<count],
                rhs.values[0..<count]
            )
        )
    }

    static func -= (lhs: inout AnimatableVector, rhs: AnimatableVector) {
        let count = min(lhs.values.count, rhs.values.count)
        vDSP.subtract(
            lhs.values[0..<count],
            rhs.values[0..<count],
            result: &lhs.values[0..<count]
        )
    }

    mutating func scale(by rhs: Double) {
        vDSP.multiply(
            Float(rhs),
            values,
            result: &values
        )
    }

    var magnitudeSquared: Double {
        Double(
            vDSP.sum(
                vDSP.multiply(values, values)
            )
        )
    }
    
    var count: Int {
        values.count
    }
    
    subscript(_ i: Int) -> Float {
        get {
            values[i]
        } set {
            values[i] = newValue
        }
    }
}

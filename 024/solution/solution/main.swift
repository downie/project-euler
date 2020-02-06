//
//  main.swift
//  solution
//
//  Created by Chris Downie on 1/19/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import Foundation

/// Measure how long it takes to execute the `method` closure
/// - Parameter method: The method to benchmark.
func benchmark<T>(method: () -> T) {
    let start = Date().timeIntervalSinceReferenceDate
    let result = method()
    let end = Date().timeIntervalSinceReferenceDate
    print(String(format: "Solved in %.4fs", end - start))
    print(result)
}

func orderedPermutationsOf(digits: [Int]) -> [String] {
    orderedPermutationsOf(digits: digits.map(String.init))
}
func orderedPermutationsOf(digits: [String]) -> [String] {
    guard digits.count > 1 else {
        return digits
    }
    
    let results = digits.enumerated().map { offset, digit -> [String] in
        var localDigits = digits
        localDigits.remove(at: offset)
        return orderedPermutationsOf(digits: localDigits).map { "\(digit)\($0)" }
    }
    return results.reduce([]) { result, permutations -> [String] in
        var result = result
        result.append(contentsOf: permutations)
        return result
    }
}
benchmark {
    orderedPermutationsOf(digits: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])[1_000_000 - 1]
}

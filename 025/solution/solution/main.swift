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

// Recycling BigInt from problem 20:
struct BigInt {
    let value: String
    var size: Int {
        value.count
    }

    subscript(index: Int) -> Int {
        // this is the reverse of the string. [0] is the ones digit, [1] is the tens digit, etc.
        // out of bounds access is always 0.
        guard index >= 0 else {
            return 0
        }
        guard index < value.count else {
            return 0
        }
        let vIndex = value.index(value.endIndex, offsetBy: -(index + 1))
        return Int(String(value[vIndex]))!
    }
    
    init(_ number: Int) {
        value = String(format: "%d", number)
    }

    init(_ string: String) {
        value = string.replacingOccurrences(of: "[^0-9]+", with: "", options: .regularExpression)
    }
    
    static func +(lhs: BigInt, rhs: BigInt) -> BigInt {
        var carry = 0
        var sum = ""
        for i in 0..<(max(lhs.size, rhs.size)) {
            let digit = lhs[i] + rhs[i] + carry
            if digit < 9 {
                carry = 0
                sum.append("\(digit)")
            } else {
                carry = digit / 10
                sum.append("\(digit % 10)")
            }
        }
        if carry > 0 {
            sum.append("\(carry)")
        }
        return BigInt(String(sum.reversed()))
    }
    
    static func *(lhs: BigInt, rhs: BigInt) -> BigInt {
        var terms = [BigInt]()
        let longerNumber = lhs.size > rhs.size ? lhs : rhs
        let smallerNumber = lhs.size > rhs.size ? rhs : lhs
        for i in 0..<smallerNumber.size  {
            var carry = 0
            var term = String(repeating: "0", count: i)
            for j in 0..<longerNumber.size {
                let digit = longerNumber[j] * smallerNumber[i] + carry
                if digit < 9 {
                    carry = 0
                    term.append("\(digit)")
                } else {
                    carry = digit / 10
                    term.append("\(digit % 10)")
                }
            }
            if carry > 0 {
                term.append("\(carry)")
            }
            terms.append(BigInt(String(term.reversed())))
        }
        
        return terms.reduce(BigInt(0), +)
    }
}

func fibonacciIndexOf(length: Int) -> Int? {
    var first = BigInt(1)
    var second = BigInt(1)
    for index in (3...) {
        let next = first + second
        if next.size >= length {
            return index
        }
        first = second
        second = next
        
        if index % 1000 == 0 {
            print(index)
        }
    }
    return nil
}

benchmark {
    fibonacciIndexOf(length: 1000)
}

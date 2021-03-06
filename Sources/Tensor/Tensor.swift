//
//  Tensor.swift
//
//
//  Created by Rahul Bhalley on 01/08/19.
//

public protocol Initable {
    init()
}

public protocol BasicMathOps {
    static func + (left: Self, right: Self) -> Self
    static func - (left: Self, right: Self) -> Self
    static func * (left: Self, right: Self) -> Self
    static func / (left: Self, right: Self) -> Self
}

extension Int:      BasicMathOps, Initable {}
extension Float:    BasicMathOps, Initable {}
extension Double:   BasicMathOps, Initable {}

public struct Tensor<T: Initable & BasicMathOps> {
    var elements = [T]()
    var size: Int { return elements.count }
    private var axes = [Int]()
    public var shape: [Int] {
        get { return self.axes }
        set { precondition(newValue != [], "Error: Shape must not be empty.") }
    }
    public var rank: Int { return shape.count }
    /**
     Initializers:
     - `init(shape:)`: all elements are initialized with`0` of `Tensor` with `shape`
     - `init(shape:element)`:
     - `init(shape:elements)`:
     - `init(elements:)`:
     */
    public init(shape axes: [Int]) {
        self.axes = axes
        var count = 1
        var length: Int {
            for axis in shape { count *= axis }
            return count
        }
        elements = Array<T>(repeating: T(), count: length)
    }
    
    public init(shape axes: [Int], element: T) {
        self.axes = axes
        var count = 1
        var length: Int {
            for axis in shape { count *= axis }
            return count
        }
        elements = Array<T>(repeating: element, count: length)
    }
    
    public init(shape axes: [Int], elements: [T]) {
        self.axes = axes
        self.elements = elements
    }
    
    public init(elements: [T]) {
        self.axes.append(elements.count)
        self.elements = elements
    }
    
    /**
     Tensor index validation methods:
     - index validation
     - Shape validation
     */
    fileprivate func isValid(_ index: Int) -> Bool {
        return index == 0 && index < self.shape[0]
    }
    
    fileprivate func isValid(_ shape: [Int]) -> Bool {
        for index in 0..<shape.count {
            if shape[index] < 0 || shape[index] >= self.shape[index] {
                return false
            }
        }
        return true
    }
    /**
     Subscript overloads to access `Tensor` values (`set` and `get` properties)
     - 1D subscipt
     - 2D subscript
     */
    public subscript(index: Int) -> T {
        get {
            assert(isValid(index), "Error: Index is not valid.")
            return self.elements[index]
        }
        set {
            assert(isValid(index), "Error: Index is not valid.")
        }
    }
    
    public subscript(shape: Int...) -> T {
        get {
            assert(isValid(shape), "Error: Shape is not valid.")
            var indexValue = Double((shape[0] * self.shape[1]) + shape[1])
            for _ in 0..<shape.count - 2 {
                var newIndexValue: Double = 1
                for j in 0..<self.shape.count - 1 {
                    newIndexValue *= Double(self.shape[j])
                    if j == shape.count - 2 {
                        newIndexValue *= Double(shape[j + 1])
                    }
                }
                indexValue += newIndexValue
            }
            let index = Int(indexValue)
            return elements[index]
        }
        set {
            assert(isValid(shape), "Error: SHape is not valid.")
            var indexValue = Double((shape[0] * self.shape[1]) + shape[1])
            for _ in 0..<shape.count - 2 {
                var newIndexValue: Double = 1
                for j in 0..<self.shape.count - 1 {
                    newIndexValue *= Double(self.shape[j])
                    if j == shape.count - 2 {
                        newIndexValue *= Double(shape[j + 1])
                    }
                }
                indexValue += newIndexValue
            }
            let index = Int(indexValue)
            elements[index] = newValue
        }
    }
    /**
     `Tensor` rank validation:
     - `isVector`
     - `isMatrix`
     */
    fileprivate var isVector: Bool {
        if shape[0] == 1 || shape[1] == 1 {
            return true
        } else if shape[0] == 1 && shape[1] == 1 {
            return false
        }
        return false
    }
    
    fileprivate var isMatrix: Bool {
        if shape.count == 2 && shape[0] != 1 && shape[1] != 1 {
            return true
        }
        return false
    }
    
    /**
     Computed properties to compute:
     - `transpose` of a vector or matrix
     */
    public var transpose: Tensor {
        assert(self.shape.count == 2, "Error: Must be a vector (shape = [1, ?] or [?, 1]) or matrix for transpose.")
        var newShape = [Int]()
        if self.isVector {
            newShape = shape.reversed()
            return Tensor(shape: newShape, elements: self.elements)
        } else if self.isMatrix {
            var transposedMatrix = self
            for row in 0..<self.shape[0] {
                for column in 0..<self.shape[1] {
                    transposedMatrix[column, row] = self[row, column]
                }
            }
            return transposedMatrix
        } else {
            print("Error: Must be a vector (shape = [1, ?] or [?, 1]) or matrix for transpose.")
            return self
        }
    }
}

extension Tensor {
    /**
     Advanced operators:
     - Addition
     - Subtraction
     - Multiplication
     - Division
     */
    public static func + (left: Tensor, right: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        // Suffices for left and right as matrices
        if left.shape == right.shape {
            for axis in 0..<left.size {
                output.append(left.elements[axis] + right.elements[axis])
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        } else if left.isVector && right.isMatrix {
            assert(left.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<right.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in 0..<left.shape[1] {
                    output.append(left[0, column] + right[row, column])
                }
            }
            outputTensor = Tensor(shape: right.shape, elements: output)
        } else if left.isMatrix && right.isVector {
            assert(right.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<left.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in 0..<right.shape[1] {
                    output.append(left[row, column] + right[0, column])
                }
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        }
        return outputTensor
    }
    
    public static func - (left: Tensor, right: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        // Suffices for left and right as matrices
        if left.shape == right.shape {
            for axis in 0..<left.size {
                output.append(left.elements[axis] - right.elements[axis])
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        } else if left.isVector && right.isMatrix {
            assert(left.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<right.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in 0..<left.shape[1] {
                    output.append(left[0, column] - right[row, column])
                }
            }
            outputTensor = Tensor(shape: right.shape, elements: output)
        } else if left.isMatrix && right.isVector {
            assert(right.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<left.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in 0..<right.shape[1] {
                    output.append(left[row, column] - right[0, column])
                }
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        }
        return outputTensor
    }
    
    public static func * (left: Tensor, right: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        // Suffices for left and right as matrices
        if left.shape == right.shape {
            for axis in 0..<left.size {
                output.append(left.elements[axis] * right.elements[axis])
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        } else if left.isVector && right.isMatrix {
            assert(left.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<right.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in 0..<left.shape[1] {
                    output.append(left[0, column] * right[row, column])
                }
            }
            outputTensor = Tensor(shape: right.shape, elements: output)
        } else if left.isMatrix && right.isVector {
            assert(right.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<left.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in 0..<right.shape[1] {
                    output.append(left[row, column] * right[0, column])
                }
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        }
        return outputTensor
    }
    
    public static func / (left: Tensor, right: Tensor) -> Tensor {
        var output = [T]()
        var outputTensor = Tensor<T>(shape: [0], elements: [T()])
        // Suffices for left and right as matrices
        if left.shape == right.shape {
            for axis in 0..<left.size {
                output.append(left.elements[axis] / right.elements[axis])
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        } else if left.isVector && right.isMatrix {
            assert(left.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<right.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in 0..<left.shape[1] {
                    output.append(left[0, column] / right[row, column])
                }
            }
            outputTensor = Tensor(shape: right.shape, elements: output)
        } else if left.isMatrix && right.isVector {
            assert(right.shape[0] == 1, "Error: For matrix and vector addition, the shape of vector must be [1, ?]. Hint: use transpose(_:)")
            for row in 0..<left.shape[0] {
                // Make sure the algorithm's idea is correct
                for column in 0..<right.shape[1] {
                    output.append(left[row, column] / right[0, column])
                }
            }
            outputTensor = Tensor(shape: left.shape, elements: output)
        }
        return outputTensor
    }
}

extension Tensor {
    public static func * <T: BasicMathOps & Initable> (element: T, tensor: Tensor<T>) -> Tensor<T> {
        var outputs = [T]()
        /// Apply operator on each element of `Tensor`.
        for tensorElement in tensor.elements {
            outputs.append(element * tensorElement)
        }
        return Tensor<T>(shape: tensor.shape, elements: outputs)
    }
}

/**
 Tensor operations:
 - `matrixProduct(_:_:)`: Matrix multiplication.
 */
/// TODO: Make `matMul(_:_:)` generic.

public func matMul(_ matrixA: Tensor<Float>, _ matrixB: Tensor<Float>) -> Tensor<Float> {
    assert(matrixA.shape.count == 2 && matrixB.shape.count == 2, "Error: Must be a matrix.")
    assert(matrixA.shape[1] == matrixB.shape[0], "Error: Column and row size condition not staisfied.")
    var result = [Float]()
    for row in 0..<matrixA.shape[0] {
        for column in 0..<matrixB.shape[1] {
            var product: Float = 0
            for x in 0..<matrixA.shape[1] {
                product += matrixA[row, x] * matrixB[x, column]
            }
            result.append(product)
        }
    }
    let newRow = matrixA.shape[0]
    let newColumn = matrixB.shape[1]
    return Tensor(shape: [newRow, newColumn], elements: result)
}

/**
 Visualization
 - `visualize(_:)`: Prints the matrix or vector
 */
public func visualize<T>(_ matrix: Tensor<T>) {
    assert(matrix.shape.count == 2, "Only vector (shape = [1, ?] or [?, 1]) or matrix are visualizable.")
    for row in 0..<matrix.shape[0] {
        for column in 0..<matrix.shape[1] {
            print(matrix[row, column], terminator: " ")
        }
        print()
    }
}


/**
 Retroactive modeling for `Tensor`
 */

# Swift Tensor

###### Tensor.swift

This is a very lightweight library written in Swift for working with `Tensor` data type. It offers simplicity and flexibility in initializing and manipulating the `Tensor` instance. Swift's `subscript` feature is used to access the data of `Tensor` instance. Many specific functions are also provided to do important matrix and vector-based operations.

Moreover, `Tensor` automatically infers its type from the type of `elements` you provide to it. In addition to its generic nature, it is intentionally restricted to work with `Int`, `Float`, or `Double` data types because it is a computational library. 



## Initialization

Creating a `Tensor` instance is pretty simple:

```swift
let vector = Tensor(shape: [1, 4], elements: [1, 2, 3, 4])  // a vector, 1-D `Tensor`
var matrix = Tensor(shape: [3, 3], element: 3)              // a matrix, 2-D `Tensor`
let tensor = Tensor(shape: [3, 3, 3, 4], element: 2)        // a tensor, 4-D `Tensor`
```

### Flexible Initialization

`Tensor` data type's initializers allow flexible initialization:

* `init(shape:)`: Must provide the `shape` and `Tensor` instance is automatically initialized with `0` in every place
* `init(shape:element:)`: Must provide the `shape` and an `element` to initialize the `Tensor` instance with `element` in all places
* `init(shape:elements:)`: Must provide the `shape` and the `elements` array to initialize `Tensor` with `shape` and `elements` in their respective places
* `init(elements:)`: Must provide the `elements` and the `shape` is automatically set equal to the number of `elements`


## Accessing Values

`Tensor` uses Swift's powerful feature called `subscript` for accessing and modifying the values of the `Tensor` instances. To access data at a specific position in N dimensional `Tensor`, N `subscript` parameters are provided as follows:

```swift
visualize(matrix)

/** Prints
3 3 3
3 3 3
3 3 3
**/

// Modify the `Tensor` values using subscript syntax:
matrix[0, 0] = 1
matrix[1, 1] = 1
matrix[2, 2] = 1

visualize(matrix)

/** Prints
1 3 3
3 1 3
3 3 1
**/
```


## Some Powerful Methods, Computed Properties

In addition to flexibility in initialization, the `Tensor` also provides some useful and powerful methods and properties to manipulate the `Tensor` instances.

### Binary Operators

The basic binary operators that perform element-wise operations are listed below:

* `+` performs addition on two `Tensor` instances
* `-` performs subtraction on two `Tensor` instances
* `*` performs multiplication on two `Tensor` instances
* `/` performs division between two `Tensor` instances

A simple example on the usage of binary operators listed above:

```swift
let matrixOne = Tensor(shape: [4, 4], element: 8)
let matrixTwo = Tensor(shape: [4, 4], element: 2)

let result = matrixOne / matrixTwo
visualize(result)

/** Prints
4 4 4 4 
4 4 4 4 
4 4 4 4 
4 4 4 4
**/
```

**Note**: The `*` operator does element-wise multiplication of `Tensor` instances. To perform matrix multiplication, use `matrixProduct(_:_:)` function.


### Additional Functions, Properties

Extra functions and properties to manipulate `Tensor` instance data are listed below:

* `matrixProduct(_:_:)`: It takes two matrix shaped `Tensor` instances as parameters and returns the resulting multiplied matrix `Tensor`
* `visualize(_:)`: It takes one matrix or vector shaped `Tensor` instance and gives its visualization by printing it
* `transpose`: This is a computed property called on the `Tensor` instance to return the transposed `Tensor`


#### Important Notes

* The visualize(_:) function can be helpful in testing the elements' position in the `Tensor` (matrix or vector) by visualizing them
* Note that `transpose` can be applied on a matrix or vector shaped `Tensor` instance only


## Contribution

Contributions are welcome. Please comply with the existing coding style as it helps in easily understanding the code. For instance,
* `////` have been used for comments
* `///` is used as a comment for TODO. For instance, `/// TODO: Make matrixProduct(_:_:) generic`

This project aims to grow with more operations and performance optimizations which are important to `Tensor` data type including any other data type representable by it. You may pull a request to add new features or for fixing bugs. Better and complete documentation is coming soon.

#### We hope to grow this project into a complete tool for performing insane deep learning tasks!

## Contact 

You may contact me directly at [rahulbhalley@icloud.com](rahulbhalley@icloud.com)

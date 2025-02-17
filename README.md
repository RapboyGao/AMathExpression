# AMathExpression

AMathExpression is a Swift library for parsing and evaluating mathematical expressions. It supports basic arithmetic operations, function calls, and parentheses grouping.

## Features

- Supports basic arithmetic operations: addition, subtraction, multiplication, division, modulus, and exponentiation.
- Supports function calls: such as `sqrt`, `log`, `sin`, etc.
- Supports parentheses grouping, including both Chinese and English parentheses.
- Supports custom functions.

## Installation

Add AMathExpression to your Swift project. You can use Swift Package Manager to add the dependency.

```swift
dependencies: [
    .package(url: "https://github.com/RapboyGao/AMathExpression.git", from: "1.0.0")
]
```

## Usage

### Parsing and Evaluating Expressions

```swift
import AMathExpression

let expression = AMathExpression<Double>("3 + 5 * (2 - 8)")
if let result = expression?.evaluate() {
    print("Result: \(result)")  // Output: Result: -25.0
}
```

### Custom Functions

You can pass a dictionary of custom functions to extend the library's functionality.

```swift
let customFunctions: [String: @Sendable ([Double?]) -> Double?] = [
    "double": { values in
        guard let value = values.first, let number = value else { return nil }
        return number * 2
    }
]

let expression = AMathExpression<Double>("double(4)")
if let result = expression?.evaluate(customFunctions) {
    print("Result: \(result)")  // Output: Result: 8.0
}
```

### More Examples

#### Using Built-in Functions

```swift
let expression1 = AMathExpression<Double>("sqrt(16)")
if let result1 = expression1?.evaluate() {
    print("Result: \(result1)")  // Output: Result: 4.0
}

let expression2 = AMathExpression<Double>("log(100)")
if let result2 = expression2?.evaluate() {
    print("Result: \(result2)")  // Output: Result: 4.605170185988092
}

let expression3 = AMathExpression<Double>("sin(30)")
if let result3 = expression3?.evaluate() {
    print("Result: \(result3)")  // Output: Result: 0.5
}
```

#### Using Parentheses Grouping

```swift
let expression = AMathExpression<Double>("(3 + 5) * 2")
if let result = expression?.evaluate() {
    print("Result: \(result)")  // Output: Result: 16.0
}
```

#### Handling Chinese Parentheses

```swift
let expression = AMathExpression<Double>("3 + 5 × （2 - 8）")
if let result = expression?.evaluate() {
    print("Result: \(result)")  // Output: Result: -27.0
}
```

#### Handling Scientific Notation

```swift
let expression = AMathExpression<Double>("1.2e3 + 4.5e-2")
if let result = expression?.evaluate() {
    print("Result: \(result)")  // Output: Result: 1200.045
}
```

#### Handling Custom Functions

```swift
let customFunctions: [String: @Sendable ([Double?]) -> Double?] = [
    "triple": { values in
        guard let value = values.first, let number = value else { return nil }
        return number * 3
    }
]

let expression = AMathExpression<Double>("triple(3)")
if let result = expression?.evaluate(customFunctions) {
    print("Result: \(result)")  // Output: Result: 9.0
}
```

## Supported Default Functions

- `sqrt`
- `log`
- `log10`
- `sin`
- `cos`
- `tan`
- `asin`
- `acos`
- `atan`
- `sinh`
- `cosh`
- `tanh`
- `exp`
- `pow`
- `max`
- `min`
- `average`
- `abs`
- `ceil`
- `floor`
- `round`
- `atan2`
- `hypot`

These are just the default functions, and users can customize more functions as needed.

## License

This project is licensed under the MIT License. For more information, please see the LICENSE file.

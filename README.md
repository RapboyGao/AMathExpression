# AMathExpression

AMathExpression 是一个用于解析和计算数学表达式的 Swift 库。它支持基本的算术运算、函数调用以及括号分组。

## 功能

- 支持基本的算术运算：加法、减法、乘法、除法、取模和幂运算。
- 支持函数调用：如 `sqrt`、`log`、`sin` 等。
- 支持括号分组，支持中文和英文括号。
- 支持自定义函数。

## 安装

将 AMathExpression 添加到您的 Swift 项目中。您可以使用 Swift Package Manager 来添加依赖。

```swift
dependencies: [
    .package(url: "https://github.com/RapboyGao/AMathExpression.git", from: "1.0.0")
]
```

## 使用方法

### 解析和计算表达式

```swift
import AMathExpression

let expression = AMathExpression<Double>("3 + 5 * (2 - 8)")
if let result = expression?.evaluate() {
    print("结果: \(result)")  // 输出: 结果: -25.0
}
```

### 自定义函数

您可以传递自定义函数字典来扩展库的功能。

```swift
let customFunctions: [String: @Sendable ([Double?]) -> Double?] = [
    "double": { values in
        guard let value = values.first, let number = value else { return nil }
        return number * 2
    }
]

let expression = AMathExpression<Double>("double(4)")
if let result = expression?.evaluate(customFunctions) {
    print("结果: \(result)")  // 输出: 结果: 8.0
}
```

### 更多示例

#### 使用内置函数

```swift
let expression1 = AMathExpression<Double>("sqrt(16)")
if let result1 = expression1?.evaluate() {
    print("结果: \(result1)")  // 输出: 结果: 4.0
}

let expression2 = AMathExpression<Double>("log(100)")
if let result2 = expression2?.evaluate() {
    print("结果: \(result2)")  // 输出: 结果: 4.605170185988092
}

let expression3 = AMathExpression<Double>("sin(30)")
if let result3 = expression3?.evaluate() {
    print("结果: \(result3)")  // 输出: 结果: 0.5
}
```

#### 使用括号分组

```swift
let expression = AMathExpression<Double>("(3 + 5) * 2")
if let result = expression?.evaluate() {
    print("结果: \(result)")  // 输出: 结果: 16.0
}
```

#### 处理中文括号

```swift
let expression = AMathExpression<Double>("3 + 5 × （2 - 8）")
if let result = expression?.evaluate() {
    print("结果: \(result)")  // 输出: 结果: -27.0
}
```

#### 处理科学计数法

```swift
let expression = AMathExpression<Double>("1.2e3 + 4.5e-2")
if let result = expression?.evaluate() {
    print("结果: \(result)")  // 输出: 结果: 1200.045
}
```

#### 处理自定义函数

```swift
let customFunctions: [String: @Sendable ([Double?]) -> Double?] = [
    "triple": { values in
        guard let value = values.first, let number = value else { return nil }
        return number * 3
    }
]

let expression = AMathExpression<Double>("triple(3)")
if let result = expression?.evaluate(customFunctions) {
    print("结果: \(result)")  // 输出: 结果: 9.0
}
```

## 支持的默认函数

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

这些只是默认的函数，用户可以根据需要自定义更多的函数。

## 许可证

此项目使用 MIT 许可证。有关更多信息，请参阅 LICENSE 文件。

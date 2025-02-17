import Foundation
import Numerics

public enum AMathExpression<ANumber: Codable & Sendable & Hashable>: Codable, Sendable, Hashable, CustomStringConvertible {
    case number(ANumber)  // A number (e.g., 1, 2.5, etc.)
    indirect case addition(AMathExpression, AMathExpression)  // Addition operation (e.g., a + b)
    indirect case subtraction(AMathExpression, AMathExpression)  // Subtraction operation (e.g., a - b)
    indirect case multiplication(AMathExpression, AMathExpression)  // Multiplication operation (e.g., a * b)
    indirect case division(AMathExpression, AMathExpression)  // Division operation (e.g., a / b)
    indirect case modulus(AMathExpression, AMathExpression)  // Modulus operation (e.g., a % b)
    indirect case power(AMathExpression, AMathExpression)  // Power operation (e.g., a ^ b)
    indirect case function(String, [AMathExpression])  // Function with a name and arguments (e.g., sin(x), log(x))
    indirect case parenthesis(AMathExpression)  // Parentheses for grouping (e.g., (a + b))

    init?(_ string: String) {
        let parser = AMathExpressionParser<ANumber>()
        guard let result = parser.parse(string) ?? parser.parse(string + ")") else {
            return nil
        }
        self = result
    }

    var priority: Int {
        switch self {
        case .addition, .subtraction:
            return 1  // Addition and subtraction have the same priority.
        case .multiplication, .division, .modulus:
            return 2  // Multiplication, division, and modulus have higher priority than addition and subtraction.
        case .power:
            return 3  // Power operation has higher priority than multiplication/division.
        case .function:
            return 4  // Functions have the highest priority (depending on implementation, this might vary).
        case .parenthesis:
            return 5  // Parentheses are used to alter normal precedence and should be treated as the highest priority.
        case .number:
            return 6  // Numbers have the highest priority as they are just values.
        }
    }

    public var description: String {
        switch self {
        case .number(let value):
            return "\(value)"
        case .addition(let left, let right):
            return "\(left.wrapIfNeeded(priority: 1)) + \(right.wrapIfNeeded(priority: 1))"
        case .subtraction(let left, let right):
            return "\(left.wrapIfNeeded(priority: 1)) - \(right.wrapIfNeeded(priority: 1))"
        case .multiplication(let left, let right):
            return "\(left.wrapIfNeeded(priority: 2)) * \(right.wrapIfNeeded(priority: 2))"
        case .division(let left, let right):
            return "\(left.wrapIfNeeded(priority: 2)) / \(right.wrapIfNeeded(priority: 2))"
        case .modulus(let left, let right):
            return "\(left.wrapIfNeeded(priority: 2)) % \(right.wrapIfNeeded(priority: 2))"
        case .power(let base, let exponent):
            return "\(base.wrapIfNeeded(priority: 3)) ^ \(exponent.wrapIfNeeded(priority: 3))"
        case .function(let name, let arguments):
            let args = arguments.map { $0.description }.joined(separator: ", ")
            return "\(name)(\(args))"
        case .parenthesis(let expression):
            return "(\(expression.description))"
        }
    }

    private func wrapIfNeeded(priority currentPriority: Int) -> String {
        if priority < currentPriority {
            return "(\(description))"
        } else {
            return description
        }
    }


}

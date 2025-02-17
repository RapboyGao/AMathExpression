import Foundation

public struct AMathExpressionParser<ANumber: Codable & Sendable & Hashable> {
    func parse(_ input: String) -> AMathExpression<ANumber>? {
        var tokens = tokenize(input)
        return parseExpression(&tokens)
    }

    private func tokenize(_ input: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        var previousChar: Character?
        var parenthesisLevel = 0

        for char in input {
            if char.isWhitespace {
                continue
            }
            if char == "(" || char == "（" {
                parenthesisLevel += 1
            } else if char == ")" || char == "）" {
                parenthesisLevel -= 1
            }

            if char.isNumber || char == "." || (char == "-" && (previousChar == nil || previousChar == "(" || previousChar == "（" || "+-×*/%^÷".contains(previousChar!))) {
                currentToken.append(char)
            } else if char == "," && parenthesisLevel == 0 && !currentToken.isEmpty && currentToken.last?.isNumber == true {
                continue // Ignore commas within numbers outside parentheses
            } else if char.isLetter || char == "e" {
                currentToken.append(char) // Accumulate letters for function names or scientific notation
            } else {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                // Check for Chinese parentheses and treat them as their English counterparts
                if char == "（" {
                    tokens.append("(")
                } else if char == "）" {
                    tokens.append(")")
                } else if char == "÷" {
                    tokens.append("/") // Treat `÷` as `/`
                } else {
                    tokens.append(String(char))
                }
            }
            previousChar = char
        }
        if !currentToken.isEmpty {
            tokens.append(currentToken)
        }

        return tokens
    }

    private func parseExpression(_ tokens: inout [String]) -> AMathExpression<ANumber>? {
        var leftExpression = parseTerm(&tokens)

        while let token = tokens.first, token == "+" || token == "-" {
            tokens.removeFirst()
            let rightExpression = parseTerm(&tokens)
            if let left = leftExpression, let right = rightExpression {
                if token == "+" {
                    leftExpression = .addition(left, right)
                } else {
                    leftExpression = .subtraction(left, right)
                }
            } else {
                return nil
            }
        }

        return leftExpression
    }

    private func parseTerm(_ tokens: inout [String]) -> AMathExpression<ANumber>? {
        var leftExpression = parseFactor(&tokens)

        while let token = tokens.first, token == "*" || token == "/" || token == "%" || token == "×" || token == "÷" {
            tokens.removeFirst()
            let rightExpression = parseFactor(&tokens)
            if let left = leftExpression, let right = rightExpression {
                switch token {
                case "*", "×": // 支持 "*" 和 "×" 符号作为乘法运算符
                    leftExpression = .multiplication(left, right)
                case "/", "÷": // 支持 "/" 和 "÷" 符号作为除法运算符
                    leftExpression = .division(left, right)
                case "%":
                    leftExpression = .modulus(left, right)
                default:
                    return nil
                }
            } else {
                return nil
            }
        }

        return leftExpression
    }

    private func parseFactor(_ tokens: inout [String]) -> AMathExpression<ANumber>? {
        var leftExpression = parsePrimary(&tokens)

        while let token = tokens.first, token == "^" {
            tokens.removeFirst()
            let rightExpression = parsePrimary(&tokens)
            if let left = leftExpression, let right = rightExpression {
                leftExpression = .power(left, right)
            } else {
                return nil
            }
        }

        return leftExpression
    }

    private func parsePrimary(_ tokens: inout [String]) -> AMathExpression<ANumber>? {
        guard let token = tokens.first else {
            return nil
        }

        // Check if the token is a function name
        if token.allSatisfy({ $0.isLetter }) && tokens.count > 1 {
            tokens.removeFirst() // Remove the function name token
            return parseFunction(token, &tokens)
        }

        tokens.removeFirst()

        // Remove commas and try to parse the number
        let sanitizedToken = token.replacingOccurrences(of: ",", with: "")

        if let data = sanitizedToken.data(using: .utf8), let number = try? JSONDecoder().decode(ANumber.self, from: data) {
            return .number(number)
        } else if token == "(" || token == "（" { // 支持中文和英文的左括号
            let expression = parseExpression(&tokens)
            if tokens.first == ")" || tokens.first == "）" { // 支持中文和英文的右括号
                tokens.removeFirst()
            }
            return expression.map { .parenthesis($0) }
        }

        return nil
    }

    private func parseFunction(_ name: String, _ tokens: inout [String]) -> AMathExpression<ANumber>? {
        // Ensure there's an opening parenthesis
        guard let nextToken = tokens.first, nextToken == "(" || nextToken == "（" else {
            return nil
        }
        tokens.removeFirst() // Remove the opening parenthesis

        var arguments: [AMathExpression<ANumber>] = []
        while let argument = parseExpression(&tokens) {
            arguments.append(argument)
            // Check for a comma for additional arguments
            if let comma = tokens.first, comma == "," {
                tokens.removeFirst() // Remove the comma
            } else {
                break // No more arguments
            }
        }

        // Ensure there's a closing parenthesis
        if tokens.first == ")" || tokens.first == "）" {
            tokens.removeFirst()
        } else {
            return nil // Mismatched parenthesis
        }

        return .function(name, arguments)
    }
}

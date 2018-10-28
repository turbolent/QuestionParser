
public indirect enum Value: Equatable {
    case named([Token])
    case number([Token])
    case numberWithUnit([Token], unit: [Token])
    case relationship(Value, Value, token: Token)
    case or([Value])
    case and([Value])
}

extension Value: Encodable {

    private enum CodingKeys: CodingKey {
        case type
        case subtype
        case tokens
        case unit
        case first
        case second
        case token
        case values
    }

    private enum Subtype: String, Encodable {
        case named
        case number
        case numberWithUnit = "number-with-unit"
        case relationship
        case or
        case and
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("value", forKey: .type)

        switch self {
        case let .named(tokens):
            try container.encode(Subtype.named, forKey: .subtype)
            try container.encode(tokens, forKey: .tokens)

        case let .number(tokens):
            try container.encode(Subtype.number, forKey: .subtype)
            try container.encode(tokens, forKey: .tokens)

        case let .numberWithUnit(tokens, unit):
            try container.encode(Subtype.numberWithUnit, forKey: .subtype)
            try container.encode(tokens, forKey: .tokens)
            try container.encode(unit, forKey: .unit)

        case let .relationship(first, second, token):
            try container.encode(Subtype.relationship, forKey: .subtype)
            try container.encode(first, forKey: .first)
            try container.encode(second, forKey: .second)
            try container.encode(token, forKey: .token)

        case let .or(values):
            try container.encode(Subtype.or, forKey: .subtype)
            try container.encode(values, forKey: .values)

        case let .and(values):
            try container.encode(Subtype.and, forKey: .subtype)
            try container.encode(values, forKey: .values)
        }
    }
}

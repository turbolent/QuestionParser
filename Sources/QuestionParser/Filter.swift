
public indirect enum Filter: Equatable {
    case plain(Value)
    case withModifier(modifier: [Token], value: Value)
    case withComparativeModifier(modifier: [Token], value: Value)
    case and([Filter])
    case or([Filter])
}

extension Filter: Encodable {

    private enum CodingKeys: CodingKey {
        case type
        case subtype
        case value
        case modifier
        case filters
    }

    private enum Subtype: String, Encodable {
        case plain
        case withModifier = "with-modifier"
        case withComparativeModifier = "with-comparative-modifier"
        case and
        case or
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("filter", forKey: .type)

        switch self {
        case let .plain(value):
            try container.encode(Subtype.plain, forKey: .subtype)
            try container.encode(value, forKey: .value)

        case let .withModifier(modifier, value):
            try container.encode(Subtype.withModifier, forKey: .subtype)
            try container.encode(modifier, forKey: .modifier)
            try container.encode(value, forKey: .value)

        case let .withComparativeModifier(modifier, value):
            try container.encode(Subtype.withComparativeModifier, forKey: .subtype)
            try container.encode(modifier, forKey: .modifier)
            try container.encode(value, forKey: .value)

        case let .and(filters):
            try container.encode(Subtype.and, forKey: .subtype)
            try container.encode(filters, forKey: .filters)

        case let .or(filters):
            try container.encode(Subtype.or, forKey: .subtype)
            try container.encode(filters, forKey: .filters)
        }
    }
}

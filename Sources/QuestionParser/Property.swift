
public indirect enum Property: Equatable {
    case named([Token])
    case withFilter(name: [Token], filter: Filter)
    case inverseWithFilter(name: [Token], filter: Filter)
    case adjectiveWithFilter(name: [Token], filter: Filter)
    case and([Property])
    case or([Property])
}

extension Property: Encodable {

    private enum CodingKeys: CodingKey {
        case type
        case subtype
        case tokens
        case name
        case filter
        case properties
    }

    private enum Subtype: String, Encodable {
        case named
        case withFilter = "with-filter"
        case inverseWithFilter = "inverse-with-filter"
        case adjectiveWithFilter = "adjective-with-filter"
        case and
        case or
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("property", forKey: .type)

        switch self {
        case let .named(tokens):
            try container.encode(Subtype.named, forKey: .subtype)
            try container.encode(tokens, forKey: .tokens)

        case let .withFilter(name, filter):
            try container.encode(Subtype.withFilter, forKey: .subtype)
            try container.encode(name, forKey: .name)
            try container.encode(filter, forKey: .filter)

        case let .adjectiveWithFilter(name, filter):
            try container.encode(Subtype.adjectiveWithFilter, forKey: .subtype)
            try container.encode(name, forKey: .name)
            try container.encode(filter, forKey: .filter)

        case let .inverseWithFilter(name, filter):
            try container.encode(Subtype.inverseWithFilter, forKey: .subtype)
            try container.encode(name, forKey: .name)
            try container.encode(filter, forKey: .filter)

        case let .and(properties):
            try container.encode(Subtype.and, forKey: .subtype)
            try container.encode(properties, forKey: .properties)

        case let .or(properties):
            try container.encode(Subtype.or, forKey: .subtype)
            try container.encode(properties, forKey: .properties)
        }
    }
}

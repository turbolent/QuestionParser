
public indirect enum Query: Equatable {
    case named([Token])
    case withProperty(Query, property: Property)
    case relationship(Query, Query, token: Token)
    case and([Query])
}

extension Query: Encodable {

   private enum CodingKeys: CodingKey {
        case type
        case subtype
        case tokens
        case query
        case property
        case first
        case second
        case token
        case queries
    }

    private enum Subtype: String, Encodable {
        case named
        case withProperty = "with-property"
        case relationship
        case and
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("query", forKey: .type)

        switch self {
        case let .named(tokens):
            try container.encode(Subtype.named, forKey: .subtype)
            try container.encode(tokens, forKey: .tokens)

        case let .withProperty(query, property):
            try container.encode(Subtype.withProperty, forKey: .subtype)
            try container.encode(query, forKey: .query)
            try container.encode(property, forKey: .property)

        case let .relationship(first, second, token):
            try container.encode(Subtype.relationship, forKey: .subtype)
            try container.encode(first, forKey: .first)
            try container.encode(second, forKey: .second)
            try container.encode(token, forKey: .token)

        case let .and(queries):
            try container.encode(Subtype.and, forKey: .subtype)
            try container.encode(queries, forKey: .queries)
        }
    }
}

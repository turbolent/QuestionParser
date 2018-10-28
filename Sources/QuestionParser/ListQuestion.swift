
public enum ListQuestion: Equatable {
    case other(Query)
    case person(Property)
    case thing(Property)
}

extension ListQuestion: Encodable {

    private enum CodingKeys: CodingKey {
        case type
        case subtype
        case query
        case property
    }

    private enum Subtype: String, Encodable {
        case other
        case person
        case thing
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("list-question", forKey: .type)

        switch self {
        case let .other(query):
            try container.encode(Subtype.other, forKey: .subtype)
            try container.encode(query, forKey: .query)

        case let .person(property):
            try container.encode(Subtype.person, forKey: .subtype)
            try container.encode(property, forKey: .property)

        case let .thing(property):
            try container.encode(Subtype.thing, forKey: .subtype)
            try container.encode(property, forKey: .property)
        }
    }
}

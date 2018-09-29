
public indirect enum Query: Equatable {
    case and([Query])
    case relationship(Query, Query, token: Token)
    case named([Token])
    case withProperty(Query, property: Property)
}

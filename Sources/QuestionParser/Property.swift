
public indirect enum Property: Equatable {
    case and([Property])
    case or([Property])
    case named([Token])
    case withFilter(name: [Token], filter: Filter)
    case inverseWithFilter(name: [Token], filter: Filter)
    case adjectiveWithFilter(name: [Token], filter: Filter)
}


public indirect enum Filter: Equatable {
    case plain(Value)
    case withModifier(modifier: [Token], value: Value)
    case withComparativeModifier(modifier: [Token], value: Value)
    case and([Filter])
    case or([Filter])
}

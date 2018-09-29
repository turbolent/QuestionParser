
public indirect enum Value: Equatable {
    case named([Token])
    case number([Token])
    case number([Token], unit: [Token])
    case relationship(Value, Value)
    case or([Value])
    case and([Value])
}

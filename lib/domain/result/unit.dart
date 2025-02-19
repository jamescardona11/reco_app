final class Unit {
  const Unit._();

  factory Unit() => const Unit._();

  @override
  String toString() => 'Unit';

  @override
  bool operator ==(Object other) => other is Unit;

  @override
  int get hashCode => toString().hashCode;
}

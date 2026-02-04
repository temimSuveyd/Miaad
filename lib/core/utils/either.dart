abstract class Either<L, R> {
  const Either();
  
  bool isLeft();
  bool isRight();
  
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight);
}

class Left<L, R> extends Either<L, R> {
  final L value;
  
  const Left(this.value);
  
  @override
  bool isLeft() => true;
  
  @override
  bool isRight() => false;
  
  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onLeft(value);
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Left && runtimeType == other.runtimeType && value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'Left($value)';
}

class Right<L, R> extends Either<L, R> {
  final R value;
  
  const Right(this.value);
  
  @override
  bool isLeft() => false;
  
  @override
  bool isRight() => true;
  
  @override
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    return onRight(value);
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Right && runtimeType == other.runtimeType && value == other.value;
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'Right($value)';
}

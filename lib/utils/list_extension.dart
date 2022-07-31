

extension on List<int> {
  int get sum => this.fold(0, (a, b) => a + b);
}
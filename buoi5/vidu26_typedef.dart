typedef Intlist = List<int>;

typedef ListMapper<X> = Map<X, List<X>>;

void main() {
  Intlist l1 = [1, 2, 3, 4];
  print(l1);
  Intlist l2 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  Map<String, List<String>> m1 = {};
  ListMapper<String> m2 = {};
}

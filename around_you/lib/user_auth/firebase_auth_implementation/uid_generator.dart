class UserIdGenerator {
  static final UserIdGenerator _instance = UserIdGenerator._internal();
  int _counter = 0;

  factory UserIdGenerator() {
    return _instance;
  }

  UserIdGenerator._internal();

  int get nextId {
    _counter++;
    return _counter;
  }
}
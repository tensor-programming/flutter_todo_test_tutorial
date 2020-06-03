class Todo {
  String body;
  bool finished;

  Todo({
    this.body,
    this.finished,
  });

  @override
  String toString() {
    return 'Todo{body: $body, finished: $finished}';
  }

  @override
  int get hashCode => body.hashCode + finished.hashCode;

  @override
  bool operator ==(other) => body == other.body && finished == other.finished;
}

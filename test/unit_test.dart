import 'package:test/test.dart';

import 'package:test_todo/logic.dart';
import 'package:test_todo/model.dart';

void main() {
  TodoLogic todoLogic;
  group('Todo Logic', () {
    setUp(() {
      todoLogic = TodoLogic();
    });

    tearDown(() {
      todoLogic.dispose();
    });
    test('Check Todo List is empty', () {
      expect(todoLogic.list, <Todo>[]);
    });

    test('Add one todo by body', () {
      todoLogic.addTodo('Test todo');

      expect(todoLogic.list.length, 1);
      expect(todoLogic.list.first.body, 'Test todo');
    });

    test('Add todo by todo', () {
      todoLogic.addTodoItem(
        Todo(body: 'A body', finished: false),
      );

      expect(todoLogic.list.first, Todo(body: 'A body', finished: false));
    });

    test('Look at Todo logic stream controller', () {
      todoLogic.addTodo('test');
      todoLogic.addTodo('Another todo');

      expect(
        todoLogic.streamController.stream,
        emitsInOrder([
          [
            Todo(body: "test", finished: false),
            Todo(body: "Another todo", finished: false)
          ],
          [
            Todo(body: "test", finished: false),
            Todo(body: "Another todo", finished: false)
          ]
        ]),
      );
    });

    test('Remove todo by index', () {
      todoLogic.addTodo('test');
      todoLogic.addTodo('Another todo');

      todoLogic.removeTodoByIndex(0);

      expect(todoLogic.list.length, 1);
      expect(
          todoLogic.list.first,
          Todo(
            body: 'Another todo',
            finished: false,
          ));
    });

    test('Remove Finished Todos', () {
      todoLogic.addTodo('test');
      todoLogic.addTodo('Another todo');

      todoLogic.markItemFinished(1, true);

      todoLogic.removeFinishedTodos();

      expect(todoLogic.list.first, Todo(body: 'test', finished: false));
      expect(todoLogic.list.length, 1);
    });

    test('Clear Todos', () {
      todoLogic.addTodo('test');
      todoLogic.addTodo('Another todo');

      todoLogic.clearTodos();

      expect(todoLogic.list, <Todo>[]);
    });
  });
}

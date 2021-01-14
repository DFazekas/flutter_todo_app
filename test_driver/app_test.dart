// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Todo App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final emailField = find.byValueKey('email');
    final passwordField = find.byValueKey('password');
    final signInButton = find.byValueKey('signIn');
    final createAccountButton = find.byValueKey('createAccount');

    final signOutButton = find.byValueKey('signOut');

    final addField = find.byValueKey('addField');
    final addButton = find.byValueKey('addButton');

    FlutterDriver driver;

    /// Looks for a given value key, and awaits a specified
    /// timeout period, it'll throw an exception if it can't find the
    /// value key within the specified timeout.
    Future<bool> isPresent(SerializableFinder byValueKey,
        {Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver.waitFor(byValueKey, timeout: timeout);
        return true;
      } catch (e) {
        return false;
      }
    }

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('create account', () async {
      // If logged in, log out first and return
      // to the login page.
      if (await isPresent(signOutButton)) {
        await driver.tap(signOutButton);
      }

      // Enter email and password.
      await driver.tap(emailField);
      await driver.enterText("newEmail@hotmail.ca");
      await driver.tap(passwordField);
      await driver.enterText("pass123456");

      // Complete account creation.
      // Home screen has text "Your Todos".
      await driver.tap(createAccountButton);
      await driver.waitFor(find.text("Your Todos"));
    });

    test('login', () async {
      // to the login page.
      if (await isPresent(signOutButton)) {
        await driver.tap(signOutButton);
      }

      // Enter email and password.
      await driver.tap(emailField);
      await driver.enterText("newEmail@hotmail.ca");
      await driver.tap(passwordField);
      await driver.enterText("pass123456");

      // Complete account creation.
      // Home screen has text "Your Todos".
      await driver.tap(signInButton);
      await driver.waitFor(find.text("Your Todos"));
    });

    test('add a todo', () async {
      const String testText = "test todo";

      // You must first be logged in to create a new Todo.
      if (await isPresent(signOutButton)) {
        await driver.tap(addField);
        await driver.enterText(testText);
        await driver.tap(addButton);

        await driver.waitFor(find.text(testText),
            timeout: Duration(seconds: 3));
      }
    });
  });
}

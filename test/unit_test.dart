import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/services/auth.dart';

/// Mocks Firebase User class.
class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

/// Mocks Firebase Auth class so that it doesn't call
/// the actual database.
class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  // Firebase Auth class.
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  // Our Auth class.
  final Auth auth = Auth(auth: mockFirebaseAuth);
  setUp(() {});
  tearDown(() {});

  /// Test that auth.authStateChanges() emits and we get
  /// a User from it.
  test("emit occurs", () async {
    await expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  /// Test that createAccount() works.
  test("create account", () async {
    final String email = "test@test.com";
    final String password = "test1234";

    // Because this method only returns "Success" or throws an
    // error, we don't care what the answer is.
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((realInvocation) => null);
    expect(
        await auth.createAccount(email: email, password: password), "Success");
  });

  /// Test exception handling in createAccount().
  test("create account exception", () async {
    final String email = "test@test.com";
    final String password = "test1234";

    // When Firebase calls createUser, throw an error.
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: "You screwed up", code: null));
    expect(await auth.createAccount(email: email, password: password),
        "You screwed up");
  });

  /// Test that signIn() works.
  test("sign in", () async {
    final String email = "test@test.com";
    final String password = "test1234";

    // Because this method only returns "Success" or throws an
    // error, we don't care what the answer is.
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((realInvocation) => null);
    expect(await auth.signIn(email: email, password: password), "Success");
  });

  /// Test exception handling in signIn().
  test("sign in exception", () async {
    final String email = "test@test.com";
    final String password = "test1234";

    // When Firebase calls signIn, throw an error.
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((realInvocation) =>
            throw FirebaseAuthException(message: "You screwed up", code: null));
    expect(
        await auth.signIn(email: email, password: password), "You screwed up");
  });

  /// Test that signOut() works.
  test("sign out", () async {
    // Because this method only returns "Success" or throws an
    // error, we don't care what the answer is.
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => null);
    expect(await auth.signOut(), "Success");
  });

  /// Test exception handling in signOut().
  test("sign out exception", () async {
    // When Firebase calls signOut, throw an error.
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) =>
        throw FirebaseAuthException(message: "You screwed up", code: null));
    expect(await auth.signOut(), "You screwed up");
  });
}

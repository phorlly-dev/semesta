import 'package:cloud_firestore/cloud_firestore.dart';

typedef Wait<T> = Future<T>;
typedef Sync<T> = Stream<T>;

typedef AsWait = Wait<void>;
typedef AsList = List<String>;
typedef AsDef = AsWait Function();
typedef AsMap = Map<String, dynamic>;
typedef AsError = void Function(Object error, StackTrace stack);

typedef Doc<T> = DocumentSnapshot<T>;
typedef SyncDoc<T> = Sync<DocumentSnapshot<T>>;

typedef Def<R> = Wait<R> Function();
typedef Defo<T, R> = R Function(T value);
typedef Defox<P, S, R> = R Function(P primary, S secondary);

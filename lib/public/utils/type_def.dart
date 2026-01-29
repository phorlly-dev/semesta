import 'package:cloud_firestore/cloud_firestore.dart';

typedef Wait<T> = Future<T>;
typedef Sync<T> = Stream<T>;
typedef AsList = List<String>;
typedef AsMap = Map<String, dynamic>;
typedef Doc<T> = DocumentSnapshot<T>;
typedef SyncDoc<T> = Sync<DocumentSnapshot<T>>;

typedef Fn<R> = Wait<R> Function();
typedef FnP<T, R> = R Function(T value);
typedef FnP2<P, S, R> = R Function(P primary, S secondary);

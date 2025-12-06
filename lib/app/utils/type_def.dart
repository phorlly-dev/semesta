import 'package:cloud_firestore/cloud_firestore.dart';

typedef StringCallback<R> = R Function(R value);
typedef FutureCallback<R> = Future<R> Function();
typedef ErrorCallback<R> = R Function(Object error);
typedef BuilderCallback<T, R> = R Function(T data);
typedef PropsCallback<T, R> = R Function(T value);
typedef Doc<T> = DocumentSnapshot<T>;
typedef StreamDoc<T> = Stream<DocumentSnapshot<T>>;
typedef ConbineData<A, B, R> = R Function(A a, B b);
typedef AsMap = Map<String, dynamic>;
typedef AsList = List<String>;

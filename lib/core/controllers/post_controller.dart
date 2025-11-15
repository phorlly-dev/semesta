import 'package:flutter/material.dart';
import 'package:semesta/core/controllers/controller.dart';
import 'package:semesta/core/repositories/post_repository.dart';

class PostController extends IController {
  final PostRepository repository;

  PostController({required this.repository}) {
    debugPrint('[PostRepository] initialized ✅');
  }
}

import 'package:hive_ce/hive.dart';
import 'package:todo_me/core/errors/failurs.dart';

CacheFailure cacheFailure(HiveError e) {
  switch (e.message) {

    default:
      return CacheFailure('Local Database Error');
  }
}
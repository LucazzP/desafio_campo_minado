import 'package:flutter/foundation.dart';

extension ListEqual<A> on List<A> {
  bool equals<T, S>(List<T> otherList) {
    if ((this != null && otherList != null) &&
        (this.isNotEmpty && otherList.isNotEmpty) &&
        (this.first is List<S> && otherList.first is List<S>)) {
      List<S> _listReduced;
      List<S> _otherListReduced;
      _listReduced = List.castFrom<dynamic, List<S>>(this).reduce((a, b) {
        List<S> _list = List.from(a);
        _list.addAll(b);
        return _list;
      });
      _otherListReduced = List.castFrom<dynamic, List<S>>(otherList).reduce((a, b) {
        List<S> _list = List.from(a);
        _list.addAll(b);
        return _list;
      });
      return listEquals(_listReduced, _otherListReduced);
    }
    return listEquals(this, otherList);
  }
}
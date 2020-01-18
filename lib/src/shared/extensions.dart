import 'package:flutter/foundation.dart';

extension ListEqual<A> on List<A> {
  bool equals<T>(List<T> otherList) {
    if ((this != null && otherList != null) &&
        (this.isNotEmpty && otherList.isNotEmpty) &&
        (this.first is List && otherList.first is List)) {
      T _listReduced;
      T _otherListReduced;
      _listReduced = (this as List<T>).reduce((a, b) {
        T _list = a;
        (_list as List).addAll((b as List));
        return _list;
      });
      _otherListReduced = otherList.reduce((a, b) {
        T _list = a;
        (_list as List).addAll((b as List));
        return _list;
      });
      return listEquals((_listReduced as List), (_otherListReduced as List));
    }
    return listEquals(this, otherList);
  }
}
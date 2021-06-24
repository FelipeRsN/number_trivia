extension NullSafeBlock<T> on T? {
  void let(Function(T it) runnable, {Function()? ifNull}) {
    if (this != null) {
      runnable(this!);
    } else {
      if (ifNull != null) ifNull();
    }
  }
}



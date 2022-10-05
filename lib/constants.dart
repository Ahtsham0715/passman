

import 'package:flutter/material.dart';

double? responsiveHW(ctx, {ht, wd}) {
  return (ht != null)
      ? MediaQuery.of(ctx).size.height * ht / 100
      : (wd != null)
          ? MediaQuery.of(ctx).size.width * wd / 100
          : null;
}


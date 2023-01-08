import 'package:flutter/material.dart';
import 'package:passman/constants.dart';

Widget customTextField(hintTitle, isPassword, sIcon, controllerName,
    validationFunc, onSavedFunc, wSize, hSize, border,
    {pIcon, filled, fillColor, labeltext, onchanged}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isPassword,
      onChanged: onchanged,
      decoration: InputDecoration(
          filled: filled,
          fillColor: fillColor,
          labelText: hintTitle,
          // hintText: hintTitle,
          suffixIcon: sIcon,
          prefixIcon: Icon(
            pIcon,
          ),
          border: border,
          contentPadding: EdgeInsets.symmetric(
              horizontal: wSize * 2.5 / 100, vertical: hSize * 2 / 100)),
      controller: controllerName,
      validator: validationFunc,
      onSaved: onSavedFunc,
    ),
  );
}

Widget customDropDownFormField(
    fieldTitle, dropDownValue, List<String> listOfItems, onChangedFunc, ctx) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: responsiveHW(ctx, wd: 4)!.toDouble(),
        vertical: responsiveHW(ctx, wd: 2)!.toDouble()),
    child: DropdownButtonFormField(
        isExpanded: true,
        isDense: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          // labelText: fieldTitle,
          focusColor: Colors.teal,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
        validator: (value) => value == null ? 'Required*' : null,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.grey,
        ),
        // hint: Text(
        //   'Select $fieldTitle',
        // ),
        value: dropDownValue,
        items: listOfItems.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: onChangedFunc),
  );
}

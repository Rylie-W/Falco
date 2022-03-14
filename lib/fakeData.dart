import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FakeData {
  static final getData = [
    {
      'name': 'Banana',
      'category': 'Fruit',
      'boughttime': DateFormat('dd/MM/yyyy, HH:mm').parse('31/12/2000, 22:00'),
      'expiretime': DateFormat('dd/MM/yyyy, HH:mm').parse('31/12/2001, 22:00'),
      'quantitytype': 'box',
      'quantitynum': 1,
      'state': 'good',
      'consumestate': 0.89,
    },
    {
      'name': 'pork',
      'category': 'Meat',
      'boughttime': DateFormat('dd/MM/yyyy, HH:mm').parse('31/12/2002, 22:00'),
      'expiretime': DateFormat('dd/MM/yyyy, HH:mm').parse('31/12/2003, 22:00'),
      'quantitytype': 'box',
      'quantitynum': 1,
      'state': 'good',
      'consumestate': 0.5,
    },
  ];
}

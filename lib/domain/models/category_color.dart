import 'package:flutter/material.dart';

class CategoryColor {
  final String name;
  final String value;

  const CategoryColor({required this.name, required this.value});

  Color get flutterColor => categoryColorFromString(value);
}

const categoryColors = [
  CategoryColor(name: 'Slate', value: '#475569'),
  CategoryColor(name: 'Gray', value: '#4B5563'),
  CategoryColor(name: 'Zinc', value: '#52525B'),
  CategoryColor(name: 'Neutral', value: '#525252'),
  CategoryColor(name: 'Stone', value: '#57534E'),
  CategoryColor(name: 'Red', value: '#DC2626'),
  CategoryColor(name: 'Orange', value: '#EA580C'),
  CategoryColor(name: 'Amber', value: '#D97706'),
  CategoryColor(name: 'Yellow', value: '#CA8A04'),
  CategoryColor(name: 'Lime', value: '#65A30D'),
  CategoryColor(name: 'Green', value: '#16A34A'),
  CategoryColor(name: 'Emerald', value: '#059669'),
  CategoryColor(name: 'Teal', value: '#0D9488'),
  CategoryColor(name: 'Cyan', value: '#0891B2'),
  CategoryColor(name: 'Sky', value: '#0284C7'),
  CategoryColor(name: 'Blue', value: '#2563EB'),
  CategoryColor(name: 'Indigo', value: '#4F46E5'),
  CategoryColor(name: 'Violet', value: '#7C3AED'),
  CategoryColor(name: 'Purple', value: '#9333EA'),
  CategoryColor(name: 'Fuchsia', value: '#C026D3'),
  CategoryColor(name: 'Pink', value: '#DB2777'),
  CategoryColor(name: 'Rose', value: '#E11D48'),
];

Color categoryColorFromString(String value) {
  final hex = value.replaceFirst('#', '');
  return Color(int.parse('FF$hex', radix: 16));
}

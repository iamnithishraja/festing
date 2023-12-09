import 'dart:io';
import 'package:flutter/material.dart';

class Fest {
  Fest({
    required this.id,
    required this.collegeName,
    required this.festName,
    required this.collegeWebsite,
    required this.description,
    this.festWebsite,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.poster,
    required this.broture,
  });
  String id,collegeName,
      festName,
      description,
      collegeWebsite,
      location,
      startDate,
      endDate,
      broture,
      poster;
  String? festWebsite;
}

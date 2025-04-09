import 'package:flutter/material.dart';

class Nutritionist {
  final String id;
  final String name;
  final String title;
  final String bio;
  final String imageUrl;
  final bool isVerified;
  final Color accentColor;
  final String? city;
  final String? country;
  final String? email;
  final String? phone;
  final String? website;
  final Map<String, String>? socialMedia;
  final List<String>? specializations;
  final List<String>? languages;
  final String? educationBackground;
  final int? experienceYears;

  const Nutritionist({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.imageUrl,
    this.isVerified = false,
    this.accentColor = Colors.green,
    this.city,
    this.country,
    this.email,
    this.phone,
    this.website,
    this.socialMedia,
    this.specializations,
    this.languages,
    this.educationBackground,
    this.experienceYears,
  });

  String get location =>
      [city, country].where((element) => element != null).join(', ');

  Nutritionist copyWith({
    String? id,
    String? name,
    String? title,
    String? bio,
    String? imageUrl,
    bool? isVerified,
    Color? accentColor,
    String? city,
    String? country,
    String? email,
    String? phone,
    String? website,
    Map<String, String>? socialMedia,
    List<String>? specializations,
    List<String>? languages,
    String? educationBackground,
    int? experienceYears,
  }) {
    return Nutritionist(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      isVerified: isVerified ?? this.isVerified,
      accentColor: accentColor ?? this.accentColor,
      city: city ?? this.city,
      country: country ?? this.country,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      socialMedia: socialMedia ?? this.socialMedia,
      specializations: specializations ?? this.specializations,
      languages: languages ?? this.languages,
      educationBackground: educationBackground ?? this.educationBackground,
      experienceYears: experienceYears ?? this.experienceYears,
    );
  }
}

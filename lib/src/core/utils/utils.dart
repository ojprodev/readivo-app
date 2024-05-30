library utils;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  static bool validISBN(String isbn) {
    return (isbn.length == 10 || isbn.length == 13);
  }

  static DateTime todayDate() {
    DateTime now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  static double parseRatingsAverage(String rating) {
    return double.tryParse(
            double.tryParse(rating)?.toStringAsFixed(2) ?? '0.0') ??
        0.0;
  }

  static int parseTotalPages(dynamic value) {
    if (value == null) {
      return 0;
    } else if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    } else {
      return 0;
    }
  }

  static double? safeConvertToDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    throw ArgumentError('Value is neither int nor double: $value');
  }

  /// A function to predict a file name from a given file path with optional modifications.
  ///
  /// This function takes a file [path] as input and predicts the file name by extracting it from the path.
  /// It provides options to replace underscores with spaces, replace dashes with spaces, and remove domains' URIs from the file name.
  ///
  /// The [removeUnderscores] parameter, if set to true, replaces underscores with spaces in the file name. Default is false.
  ///
  /// The [removeDashes] parameter, if set to true, replaces dashes with spaces in the file name. Default is false.
  ///
  /// The [removeDomains] parameter, if set to true, removes domains' URIs from the file name. Default is false.
  ///
  /// Returns the predicted file name as a string.

  static String fileNamePrediction(String path,
      {bool? removeUnderscores = false,
      bool? removeDashes = false,
      bool? removeDomains = false}) {
    // Get the index of the last slash (/) in the path
    int lastSlashIndex = path.lastIndexOf('/');
    // Get the index of the last dot (.) in the path (for the file extension)
    int extensionIndex = path.lastIndexOf('.');

    // Get the file name by extracting the substring between the last slash and the last dot
    String fileName = path.substring(lastSlashIndex + 1, extensionIndex);

    // Replace underscores with spaces if the option is enabled
    if (removeUnderscores == true) {
      fileName = fileName.replaceAll('_', ' ');
    }

    // Remove domains' URIs from the file name if the option is enabled
    if (removeDomains == true) {
      // Regular expression to match domain URIs (e.g., example.com) in the file name
      RegExp regExp = RegExp(
        r'([a-zA-Z0-9-]+\.[a-zA-Z]{2,})(?=\s)',
        // Matches domain URIs followed by a space
        caseSensitive: false, // Case insensitive matching
      );
      // Find all matches of the regular expression in the file name
      Iterable<Match> matches = regExp.allMatches(fileName);

      // Loop through all matches and remove each domain URI from the file name
      for (Match match in matches) {
        // Extract the domain URI from the match
        String domain = match.group(1)!;
        // Remove the domain URI from the file name
        fileName = fileName.replaceAll(domain, '');
      }
    }

    // Replace dashes with spaces if the option is enabled
    if (removeDashes == true) {
      fileName = fileName.replaceAll('-', ' ');
    }

    return fileName; // Return the predicted file name
  }

  static List<String> cutArrayItems(List<String> inputList, int n) {
    inputList = inputList.map((element) => element.toString()).toList();
    if (inputList.length <= n) {
      return inputList; // Return the whole list if its length is less than or equal to n
    } else {
      return inputList.sublist(
          0, n); // Return the sublist of the first n elements
    }
  }

  static  ImageProvider determineImageProviderByUri(String uri) {
    Uri parsedUri = Uri.parse(uri);
    if (parsedUri.isScheme('file')) {
      return FileImage(File(parsedUri.path));
    } else {
      return NetworkImage(uri);
    }
  }
}

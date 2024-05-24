library utils;

import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
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
        String domain =
            match.group(1)!; // Extract the domain URI from the match
        fileName = fileName.replaceAll(
            domain, ''); // Remove the domain URI from the file name
      }
    }

    // Replace dashes with spaces if the option is enabled
    if (removeDashes == true) {
      fileName = fileName.replaceAll('-', ' ');
    }

    return fileName; // Return the predicted file name
  }
}

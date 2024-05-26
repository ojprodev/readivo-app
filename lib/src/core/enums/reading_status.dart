enum ReadingStatus {
  wantToRead,
  reading,
  paused,
  gaveUp,
  finished,
}

String getReadingStatusAsString(ReadingStatus status) {
  switch (status) {
    case ReadingStatus.reading:
      return 'Reading';
    case ReadingStatus.paused:
      return 'Paused';
    case ReadingStatus.gaveUp:
      return 'Gave up';
    case ReadingStatus.finished:
      return 'Finished';
    case ReadingStatus.wantToRead:
    default:
      return 'Want to Read';
  }
}

ReadingStatus getReadingStatusFromString(String status) {
  switch (status) {
    case 'Reading':
      return ReadingStatus.reading;
    case 'Paused':
      return ReadingStatus.paused;
    case 'Gave up':
      return ReadingStatus.gaveUp;
    case 'Finished':
      return ReadingStatus.finished;
    case 'Want to Read':
    default:
      return ReadingStatus.wantToRead;
  }
}

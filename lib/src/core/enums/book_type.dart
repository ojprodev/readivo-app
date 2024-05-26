enum BookType {
  paperBook,
  eBook,
  audioBook,
}

List<BookType> getBookTypes() {
  return [BookType.paperBook, BookType.eBook, BookType.audioBook];
}

BookType getBookType(String type) {
  switch (type) {
    case 'e-book':
      return BookType.eBook;
    case 'audio book':
      return BookType.audioBook;
    case 'paper book':
    default:
      return BookType.paperBook;
  }
}

String getBookTypeAsString(BookType type) {
  switch (type) {
    case BookType.eBook:
      return 'e-book';
    case BookType.audioBook:
      return 'audio book';
    case BookType.paperBook:
    default:
      return 'paper book';
  }
}

-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Апр 06 2023 г., 13:57
-- Версия сервера: 10.4.27-MariaDB
-- Версия PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `dbguzhavinbooks`
--

-- --------------------------------------------------------

--
-- Структура таблицы `authors`
--

CREATE TABLE `authors` (
  `author_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `authors`
--

INSERT INTO `authors` (`author_id`, `name`) VALUES
(5, 'John Doe'),
(6, 'Jane Smith'),
(7, 'David Williams'),
(8, 'Karen Johnson'),
(9, 'Emily Taylor'),
(10, 'John Doe'),
(11, 'John Doe'),
(12, 'Andrew Hunt'),
(13, 'David Thomas'),
(14, 'Andrew Hunt'),
(15, 'David Thomas'),
(16, 'Test Hunt'),
(17, 'Test Thomas'),
(18, 'New Author 1'),
(19, 'New Author 2');

-- --------------------------------------------------------

--
-- Структура таблицы `books`
--

CREATE TABLE `books` (
  `book_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `language_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `publish_date` date DEFAULT NULL,
  `num_pages` int(11) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `books`
--

INSERT INTO `books` (`book_id`, `title`, `description`, `language_id`, `category_id`, `publisher`, `publish_date`, `num_pages`, `image_url`) VALUES
(3, 'Mastering SQL', 'This book teaches you everything you need to know about SQL', 1, 1, 'Tech Press', '2022-01-01', 500, 'https://example.com/sql_book.jpg'),
(4, 'Python for Data Science', 'This book covers the fundamentals of Python programming for data science', 3, 2, 'Data Science Press', '2022-02-01', 400, 'https://example.com/python_ds_book.jpg'),
(5, 'JavaScript Frameworks', 'This book covers the most popular JavaScript frameworks for web development', 4, 3, 'Web Development Press', '2022-03-01', 450, 'https://example.com/js_frameworks_book.jpg'),
(6, 'Introduction to Networking', 'This book covers the basics of networking with a focus on Java programming', 5, 4, 'Networking Press', '2022-04-01', 350, 'https://example.com/networking_book.jpg'),
(7, 'SQL Fundamentals', 'This book covers the basics of SQL for database management and querying', 6, 5, 'Database Press', '2022-05-01', 250, 'https://example.com/sql_fundamentals_book.jpg'),
(8, 'Python Programming', 'A beginners guide to Python programming language', 7, 6, 'Python Books Inc.', '2022-01-01', 300, 'https://example.com/python_programming_book.jpg'),
(9, 'Clean Code', 'A Handbook of Agile Software Craftsmanship', 1, 2, 'Prentice Hall', '2008-08-01', 464, 'https://images-na.ssl-images-amazon.com/images/I/41jEbK-jG+L._SX377_BO1,204,203,200_.jpg'),
(10, 'The Pragmatic Programmer', 'From journeyman to master', 1, 1, 'Addison-Wesley Professional', '1999-10-20', 352, 'https://images-na.ssl-images-amazon.com/images/I/41as+WafrFL._SX258_BO1,204,203,200_.jpg'),
(11, 'The Art of Computer Programming', 'A comprehensive monograph written by Donald Knuth that covers many kinds of programming algorithms and their analysis', NULL, NULL, 'Addison-Wesley', '1968-07-01', 672, 'https://www.example.com/images/the-art-of-computer-programming.jpg'),
(12, 'The Art of Computer Programming', 'A comprehensive monograph written by Donald Knuth that covers many kinds of programming algorithms and their analysis', NULL, NULL, 'Addison-Wesley', '1968-07-01', 672, 'https://www.example.com/images/the-art-of-computer-programming.jpg'),
(18, 'The Art of Computer Programming', 'The Art of Computer Programming is a comprehensive monograph written by Donald Knuth that covers many kinds of programming algorithms and their analysis.', 1, 2, 'Addison-Wesley Professional', '1997-06-19', 784, 'https://images-na.ssl-images-amazon.com/images/I/51e60%2BQkrxL._SX379_BO1,204,203,200_.jpg'),
(25, 'New Title', 'New Description', 2, 3, 'New Publisher', '2022-05-01', 250, 'http://example.com/new-image.jpg'),
(26, 'The Pragmatic Programmer', 'From Journeyman to Master', 1, 1, 'Addison-Wesley Professional', '1999-10-20', 352, 'https://images-na.ssl-images-amazon.com/images/I/41BKx1AxQWL._SX258_BO1,204,203,200_.jpg');

-- --------------------------------------------------------

--
-- Структура таблицы `books_authors`
--

CREATE TABLE `books_authors` (
  `book_id` int(11) NOT NULL,
  `author_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `books_authors`
--

INSERT INTO `books_authors` (`book_id`, `author_id`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(18, 5),
(18, 6),
(18, 7),
(26, 14),
(26, 15);

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(1, 'Information Technology'),
(2, 'Programming'),
(3, 'Web Development'),
(4, 'Networking'),
(5, 'Database'),
(6, 'Programming'),
(7, 'Programming');

-- --------------------------------------------------------

--
-- Структура таблицы `languages`
--

CREATE TABLE `languages` (
  `language_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `languages`
--

INSERT INTO `languages` (`language_id`, `name`) VALUES
(1, 'English'),
(2, 'Russian'),
(3, 'Chinese'),
(4, 'German'),
(5, 'French'),
(6, 'Estonian'),
(7, 'Italian');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`author_id`);

--
-- Индексы таблицы `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`),
  ADD KEY `language_id` (`language_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Индексы таблицы `books_authors`
--
ALTER TABLE `books_authors`
  ADD PRIMARY KEY (`book_id`,`author_id`),
  ADD KEY `author_id` (`author_id`);

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Индексы таблицы `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`language_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `authors`
--
ALTER TABLE `authors`
  MODIFY `author_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT для таблицы `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `languages`
--
ALTER TABLE `languages`
  MODIFY `language_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`language_id`) REFERENCES `languages` (`language_id`),
  ADD CONSTRAINT `books_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Ограничения внешнего ключа таблицы `books_authors`
--
ALTER TABLE `books_authors`
  ADD CONSTRAINT `books_authors_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`),
  ADD CONSTRAINT `books_authors_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

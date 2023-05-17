const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Create MySQL connection
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  database: 'dbguzhavinbooks',
});

// Connect to MySQL
connection.connect((err) => {
  if (err) {
    console.log('Error connecting to MySQL:', err);
  } else {
    console.log('Connected to MySQL!');
  }
});

// Get all books
app.get('/books', (req, res) => {
  const sql = 'SELECT * FROM books';
  connection.query(sql, (err, results) => {
    if (err) {
      console.log('Error getting all books:', err);
      res.status(500).send('Internal server error');
    } else {
      res.status(200).json(results);
    }
  });
});

// Get books by category_id
app.get('/books/category/:category_id', (req, res) => {
  const { category_id } = req.params;
  const sql = 'SELECT * FROM books WHERE category_id = ?';
  connection.query(sql, category_id, (err, results) => {
    if (err) {
      console.log('Error getting books by category_id:', err);
      res.status(500).send('Internal server error');
    } else {
      res.status(200).json(results);
    }
  });
});

// Get books by author_id
app.get('/books/author/:author_id', (req, res) => {
  const { author_id } = req.params;
  const sql = 'SELECT * FROM books WHERE book_id IN (SELECT book_id FROM books_authors WHERE author_id = ?)';
  connection.query(sql, author_id, (err, results) => {
    if (err) {
      console.log('Error getting books by author_id:', err);
      res.status(500).send('Internal server error');
    } else {
      res.status(200).json(results);
    }
  });
});

// Add books with authors and many to many 
app.post('/books', function(req, res) {
    const book = {
      title: req.body.title,
      description: req.body.description,
      language_id: req.body.language_id,
      category_id: req.body.category_id,
      publisher: req.body.publisher,
      publish_date: req.body.publish_date,
      num_pages: req.body.num_pages,
      image_url: req.body.image_url
    };
  
    const authors = req.body.authors; // получаем массив авторов из тела запроса
  
    connection.beginTransaction(function(err) {
      if (err) {
        throw err;
      }
  
      connection.query('INSERT INTO books SET ?', book, function(err, result) {
        if (err) {
          connection.rollback(function() {
            throw err;
          });
        }
  
        const bookId = result.insertId; // получаем id добавленной книги
  
        const authorIds = []; // массив для хранения id добавленных авторов
  
        // проходимся по массиву авторов и добавляем их в таблицу authors
        authors.forEach(function(author) {
          const authorObj = { name: author.name };
          connection.query('INSERT INTO authors SET ?', authorObj, function(err, result) {
            if (err) {
              connection.rollback(function() {
                throw err;
              });
            }
  
            const authorId = result.insertId; // получаем id добавленного автора
            authorIds.push(authorId); // добавляем его в массив
            
            // если это последний автор, то создаем связи many-to-many в таблице books_authors
            if (authorIds.length === authors.length) {
              const values = [];
              authorIds.forEach(function(authorId) {
                values.push([bookId, authorId]);
              });
  
              connection.query('INSERT INTO books_authors (book_id, author_id) VALUES ?', [values], function(err, result) {
                if (err) {
                  connection.rollback(function() {
                    throw err;
                  });
                }
  
                connection.commit(function(err) {
                  if (err) {
                    connection.rollback(function() {
                      throw err;
                    });
                  }
  
                  console.log('Book added with authors');
                  res.send('Book added with authors');
                });
              });
            }
          });
        });
      });
    });
  });

//   {
//     "title": "The Pragmatic Programmer",
//     "description": "From Journeyman to Master",
//     "language_id": 1,
//     "category_id": 1,
//     "publisher": "Addison-Wesley Professional",
//     "publish_date": "1999-10-20",
//     "num_pages": 352,
//     "image_url": "https://images-na.ssl-images-amazon.com/images/I/41BKx1AxQWL._SX258_BO1,204,203,200_.jpg",
//     "authors": [
//       {
//         "name": "Andrew Hunt"
//       },
//       {
//         "name": "David Thomas"
//       }
//     ]
//   }
  

// DELETE request to delete book by id and its associated authors
app.delete('/books/:id', (req, res) => {
    const bookId = req.params.id;
  
    // Delete all book's associated authors from books_authors table
    const deleteAuthorsQuery = 'DELETE FROM books_authors WHERE book_id = ?';
    connection.query(deleteAuthorsQuery, bookId, (err, result) => {
      if (err) {
        res.status(500).send({ error: 'Error deleting authors from books_authors table.' });
      } else {
        // Delete the book from the books table
        const deleteBookQuery = 'DELETE FROM books WHERE book_id = ?';
        connection.query(deleteBookQuery, bookId, (err, result) => {
          if (err) {
            res.status(500).send({ error: 'Error deleting book from books table.' });
          } else {
            res.status(200).send({ message: 'Book and associated authors deleted successfully.' });
          }
        });
      }
    });
  });
  

// Edit book and authors
app.put('/books/:id', (req, res) => {
    const bookId = req.params.id;
    const { title, description, language_id, category_id, publisher, publish_date, num_pages, image_url, authors } = req.body;
  
    // Update book details
    const updateBookQuery = `UPDATE books SET title=?, description=?, language_id=?, category_id=?, publisher=?, publish_date=?, num_pages=?, image_url=? WHERE book_id=?`;
    connection.query(updateBookQuery, [title, description, language_id, category_id, publisher, publish_date, num_pages, image_url, bookId], (err, result) => {
      if (err) {
        console.log(err);
        res.status(500).send('Error updating book details');
      } else {
        // Update authors
        const authorIds = [];
        const insertAuthorQuery = `INSERT INTO authors (name) VALUES ?`;
        const insertBookAuthorQuery = `INSERT INTO books_authors (book_id, author_id) VALUES ?`;
        const updateAuthorQuery = `UPDATE authors SET name=? WHERE author_id=?`;
  
        // First, add new authors to authors table and get their IDs
        const newAuthors = authors.filter(author => !author.author_id);
        const newAuthorNames = newAuthors.map(author => [author.name]);
        connection.query(insertAuthorQuery, [newAuthorNames], (err, result) => {
          if (err) {
            console.log(err);
            res.status(500).send('Error adding new authors');
          } else {
            // Get IDs of newly added authors
            const newAuthorIds = result.insertId;
            newAuthors.forEach((author, index) => authorIds.push(newAuthorIds + index));
  
            // Update existing authors
            const existingAuthors = authors.filter(author => author.author_id);
            existingAuthors.forEach(author => {
              connection.query(updateAuthorQuery, [author.name, author.author_id], (err, result) => {
                if (err) {
                  console.log(err);
                  res.status(500).send('Error updating author details');
                } else {
                  authorIds.push(author.author_id);
                }
              });
            });
  
            // Create book-author relationships
            const bookAuthorPairs = authorIds.map(authorId => [bookId, authorId]);
            connection.query(insertBookAuthorQuery, [bookAuthorPairs], (err, result) => {
              if (err) {
                console.log(err);
                res.status(500).send('Error creating book-author relationships');
              } else {
                res.status(200).send('Book details updated successfully');
              }
            });
          }
        });
      }
    });
  });
  
//   PUT /books/:id
//   {
//       "title": "New Book Title",
//       "description": "New Book Description",
//       "language_id": 1,
//       "category_id": 2,
//       "publisher": "New Publisher",
//       "publish_date": "2022-01-01",
//       "num_pages": 300,
//       "image_url": "https://example.com/image.jpg",
//       "authors": [
//           {
//               "id": 1,
//               "name": "New Author 1"
//           },
//           {
//               "id": 2,
//               "name": "New Author 2"
//           }
//       ]
//   }
  

app.listen(port, () => {
console.log(`Server listening on port ${port}.`);
});
CREATE TABLE comments (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  username VARCHAR(255) NOT NULL,
  post_id INTEGER,

  FOREIGN KEY(post_id) REFERENCES post(id)
);

CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER,

  FOREIGN KEY(author_id) REFERENCES author(id)
);

CREATE TABLE authors (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL
);

INSERT INTO
  authors (id, username)
VALUES
  (1, "Harold"), (2, "George");

INSERT INTO
  posts (id, title, body, author_id)
VALUES
  (1, "Hello", "This is my first post, very excited", 1),
  (2, "Tennis?", "Anybody up for tennis?", 2),
  (3, "Boat on the loose", "Whose boat is this boat?", NULL),
  (4, "I'm a lonely post", "no comments here", NULL);

INSERT INTO
  comments (id, body, username, post_id)
VALUES
  (1, "Great job, rails lite is working!", "Harold", 1),
  (2, "Okay, great.", "throwaway_user", 1),
  (3, "I am not great, but I can play", "Dylan", 2),
  (4, "3 pm today?", "Dave", 2),
  (5, "really?", "Art", 3);
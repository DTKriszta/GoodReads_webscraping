---creating table

CREATE TABLE winners (
  author VARCHAR,
  avg_ratings NUMERIC(4, 2),
  followers INTEGER,
  format VARCHAR,
  genre VARCHAR,
  language VARCHAR,
  nbOfBooks INTEGER,
  numberOfPages INTEGER,
  ratings INTEGER,
  reviews INTEGER,
  title VARCHAR,
  url VARCHAR,
  votes INTEGER,
  votestotal INTEGER,
  year INTEGER
);


--uploading data to the table

COPY winners FROM '/home/biologist/bestsellers_winners.csv' WITH CSV HEADER DELIMITER',';


---correlation

SELECT (COVAR_POP(ratings, reviews) / (STDDEV_POP(ratings) * STDDEV_POP(reviews))) AS correlation_coefficient
FROM winners;

SELECT (COVAR_POP(ratings, votes) / (STDDEV_POP(ratings) * STDDEV_POP(votes))) AS correlation_coefficient
FROM winners;

SELECT (COVAR_POP(reviews, votes) / (STDDEV_POP(reviews) * STDDEV_POP(votes))) AS correlation_coefficient
FROM winners;

--how many bestseller books do the bestselling authors have?
 
SELECT author, COUNT(*) FROM winners
GROUP BY author
ORDER BY count DESC;

--how many books do bestselling authors have?

SELECT author, nbOfBooks FROM winners
GROUP BY author, nbOfBooks
ORDER BY nbOfBooks DESC;

--how many of the bestselling authors' books became bestsellers? (segment)

SELECT author, nbOfBooks, COUNT(*) AS bestsellers  FROM winners
GROUP BY author, nbOfBooks
ORDER BY nbOfBooks DESC;

--how many followers do bestselling authors have? (segment)

SELECT author, nbOfBooks, COUNT(*) AS bestsellers, COUNT(*) / CAST(nbOfBooks AS float) * 100 AS ofbooks, followers FROM winners
GROUP BY author, nbOfBooks, followers
ORDER BY nbOfBooks DESC;

SELECT title, COUNT(*) FROM winners
GROUP BY title
ORDER BY count DESC;


----visualization
SELECT genre, year, SUM(numberOfPages) AS nbOfPages, SUM(avg_ratings) AS avg_rating, SUM(followers) AS followers, SUM(nbOfBooks) AS nbOfBooks, SUM(reviews) AS reviews, SUM(votes) AS votes, SUM(votestotal) AS votestotal FROM winners
GROUP BY genre, year
ORDER BY genre, year;



---genre/votestotal  which genre did the most people vote for, which genre is the absolute most popular

SELECT genre, SUM(votestotal) AS votestotal FROM winners
GROUP BY genre
ORDER BY votestotal DESC;

---genre/year/votestotal  how the voting within the genres has developed over the years

SELECT genre, year, votestotal FROM winners
GROUP BY genre, year, votestotal
ORDER BY genre, year;

---genre/year/votestotal  which genre was the most popular in teh given year

SELECT genre, year, votestotal FROM winners
GROUP BY genre, year, votestotal
ORDER BY year, votestotal DESC;

--genre/year  which year did the most people vote for the winners of the given genre, and what does this mean in percentage terms, how many of the voters actually voted for them

SELECT genre, year, votes, CAST(votes AS float) / votestotal * 100 AS norm FROM winners
GROUP BY genre, year, votes, votestotal
ORDER BY year, votes DESC;

--genre  which genre winners did most people vote for on average, and what does this mean in percentage terms, how many of the voters actually voted for them
SELECT genre, SUM(votes)/12 AS avg_votes, SUM(CAST(votes AS float) / votestotal * 100)/12 AS avg_norm FROM winners
GROUP BY genre
ORDER BY genre DESC;


-------genre/ratingstotal/reviewstotal/votestotal which genre's winners have the highest value, are they related?

SELECT genre, SUM(ratings) AS ratingstotal, SUM(reviews) AS reviewstotal, SUM(votes) AS votestotal FROM winners
GROUP BY genre
ORDER BY ratingstotal DESC;

---over the years, are there any trends in these values, how do they change within genres

SELECT genre, year, SUM(ratings) AS ratingstotal, SUM(reviews) AS reviewstotal, SUM(votes) AS votestotal FROM winners
GROUP BY genre, year
ORDER BY genre, year;

---votes/avg_ratings is there a correlation between them? Does the one voted for by many people have a higher rating? 

SELECT CAST(votes AS float) / votestotal * 100 AS norm_votes, avg_ratings FROM winners
ORDER BY norm_votes DESC;


SELECT votes, avg_ratings FROM winners
ORDER BY votes DESC;

--which book many people voted for, how many people rated it, how many people wrote reviews, how related these numbers are for each book
SELECT votes, ratings, reviews FROM winners
ORDER BY votes DESC;

--are these parameters related at all?

SELECT SUM(votes) AS total_votes, SUM(ratings) AS total_ratings, SUM(reviews) AS total_reviews FROM winners
;

--what format is popular within different genres

SELECT genre, format, COUNT(format) AS nbOfFomrat FROM winners
GROUP BY genre, format
ORDER BY genre;

---for visualization in looker studio
SELECT genre, format, year, COUNT(format) AS nbOfFomrat, COUNT(*) AS nbOfBooks, AVG(numberOfPages) AS nbOfPages_avg FROM winners
GROUP BY genre, format, year
ORDER BY genre;

--which format has the most winners

SELECT format, COUNT(*) FROM winners
GROUP BY format
ORDER BY count DESC;

--how long the winning books are on average within different genres

SELECT genre, AVG(numberOfPages) AS nbOfPages_avg FROM winners
GROUP BY genre
ORDER BY nbOfPages_avg DESC;

--how long are the winning books on average per year

SELECT year, AVG(numberOfPages) AS nbOfPages_avg FROM winners
GROUP BY year
ORDER BY year DESC;

--which author has the most bestsellers, what percentage of his/her books is this and whether he/she has the most followers

SELECT author, nbOfBooks, COUNT(*) AS bestsellers, COUNT(*) / CAST(nbOfBooks AS float) * 100 AS ofbooks, followers FROM winners
GROUP BY author, nbOfBooks, followers
ORDER BY bestsellers DESC;

--which genre's writers have the most books and which are the most followed?

SELECT genre, SUM(nbOfBooks) AS sum_of_Booknb, SUM(followers) AS sum_of_followers FROM winners
GROUP BY genre
ORDER BY  sum_of_Booknb DESC;

--how many genres did the author write in? (only one, it doesn't matter)

SELECT author, COUNT(DISTINCT(genre)) FROM winners
GROUP BY author, genre
ORDER BY count DESC;

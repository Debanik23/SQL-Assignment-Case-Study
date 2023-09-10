/*
RSVP Movie Case Study
Submission by: Prashanth Balakrishna, Pranavu G, Debanik
*/

USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?

/*
Approach: Count the number of rows in each table and combine all the data with a Union operation.
*/
-- Type your code below:

SELECT 'movie'  AS 'table',
       Count(*) AS num_rows
FROM   movie
UNION
SELECT 'genre'  AS 'table',
       Count(*) AS num_rows
FROM   genre
UNION
SELECT 'director_mapping' AS 'table',
       Count(*)           AS num_rows
FROM   director_mapping
UNION
SELECT 'names'  AS 'table',
       Count(*) AS num_rows
FROM   names
UNION
SELECT 'ratings' AS 'table',
       Count(*)  AS num_rows
FROM   ratings
UNION
SELECT 'role_mapping' AS 'table',
       Count(*)       AS num_rows
FROM   role_mapping
ORDER  BY num_rows DESC; 


/*
Output
+------------------+----------+
| table            | num_rows |
+------------------+----------+
| names            |    25735 |
| role_mapping     |    15615 |
| genre            |    14662 |
| movie            |     7997 |
| ratings          |     7997 |
| director_mapping |     3867 |
+------------------+----------+
*/

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q2. Which columns in the movie table have null values?

/*
Approach: Use the difference between COUNT(*) and COUNT(<column>) to check if the column has NULL values. 
Tabulate the difference in a CTE and filter to get the columns with a NULL value
*/
-- Type your code below:

-- CTE with column names and difference between COUNT(*) and COUNT(<column>)
WITH null_summary
     AS (SELECT 'id' AS 'column_name',
                (Count(*) - Count(id)) AS 'count_diff'
         FROM   movie
         UNION
         SELECT 'title' AS 'column_name',
                (Count(*) - Count(title)) AS 'count_diff'
         FROM   movie
         UNION
         SELECT 'year' AS 'column_name',
                (Count(*) - Count(year)) AS 'count_diff'
         FROM   movie
         UNION
         SELECT 'date_published' AS 'column_name',
                (Count(*) - Count(date_published)) AS 'count_diff'
         FROM   movie
         UNION
         SELECT 'duration' AS 'column_name',
                (Count(*) - Count(duration)) AS 'count_diff'
         FROM   movie
         UNION
         SELECT 'country' AS 'column_name',
                (Count(*) - Count(country)) AS 'count_diff'
         FROM   movie
         UNION
         SELECT 'worlwide_gross_income' AS 'column_name',
                (Count(*) - Count(worlwide_gross_income)) AS 'count_diff'
         FROM   movie
         UNION
         SELECT 'languages' AS 'column_name',
                (Count(*) - Count(languages)) AS 'count_diff'
         FROM   movie
         UNION
         SELECT 'production_company' AS 'column_name',
                (Count(*) - Count(production_company)) AS 'count_diff'
         FROM   movie)
SELECT column_name AS 'columns_with_NULL_values'
FROM   null_summary
WHERE  count_diff > 0; 

/*
Output
+--------------------------+
| columns_with_NULL_values |
+--------------------------+
| country                  |
| worlwide_gross_income    |
| languages                |
| production_company       |
+--------------------------+
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
--------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/*
Approach: Extract year and month information from the date_published column in the movie table. Group by the required duration and 
count the number of movies.
*/

-- Type your code below:

-- Movies released each year
SELECT year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year; 

/*
Output:
+------+------------------+
| year | number_of_movies |
+------+------------------+
| 2017 |             3052 |
| 2018 |             2944 |
| 2019 |             2001 |
+------+------------------+
*/

-- Movies released month-wise
SELECT Month(date_published) AS month_num,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY count(id) DESC; 

/*
Output:
+-----------+------------------+
| month_num | number_of_movies |
+-----------+------------------+
|         3 |              824 |
|         9 |              809 |
|         1 |              804 |
|        10 |              801 |
|         4 |              680 |
|         8 |              678 |
|         2 |              640 |
|        11 |              625 |
|         5 |              625 |
|         6 |              580 |
|         7 |              493 |
|        12 |              438 |
+-----------+------------------+
*/

/*The highest number of movies is produced in the month of March.

So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/

----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q4. How many movies were produced in the USA or India in the year 2019??
/*
Approach: Filter the movie table by year and country, and count the number of movie.
Use LIKE because data in the country column can have more than one country. 
*/

-- Type your code below:

SELECT Count(*) AS num_movies_IND_or_US
FROM   movie
WHERE  year = 2019
       AND ( country LIKE '%India%'
              OR country LIKE '%USA%' ); 

/*
Output
+----------------------+
| num_movies_IND_or_US |
+----------------------+
|                 1059 |
+----------------------+
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.

Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q5. Find the unique list of the genres present in the data set?
/*
Approach: Use the DISTINCT keyword on the genre attribute in the genre table.
*/

-- Type your code below:

SELECT DISTINCT genre
FROM   genre; 

/*
Output:
+-----------+
| genre     |
+-----------+
| Drama     |
| Fantasy   |
| Thriller  |
| Comedy    |
| Horror    |
| Family    |
| Romance   |
| Adventure |
| Action    |
| Sci-Fi    |
| Crime     |
| Mystery   |
| Others    |
+-----------+
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q6.Which genre had the highest number of movies produced overall?

/*
Approach: Grouping the genre attribut in the genre table gves us the count of movie in each genre.
But to get the genre-wise movie count in the year 2019, we need to combine the genre and movie table, 
filter the data by the required year and then group by genre. 
*/

-- Type your code below:

-- movie count over all years
SELECT genre,
       Count(movie_id) AS movie_count
FROM   genre
GROUP  BY genre
ORDER  BY Count(movie_id) DESC; 

/*
Output for all years:
+-----------+-------------+
| genre     | movie_count |
+-----------+-------------+
| Drama     |        4285 |
| Comedy    |        2412 |
| Thriller  |        1484 |
| Action    |        1289 |
| Horror    |        1208 |
| Romance   |         906 |
| Crime     |         813 |
| Adventure |         591 |
| Mystery   |         555 |
| Sci-Fi    |         375 |
| Fantasy   |         342 |
| Family    |         302 |
| Others    |         100 |
+-----------+-------------+
*/

-- movie count over 2019
SELECT genre,
       Count(id) AS movie_count
FROM   movie AS m
       INNER JOIN genre AS g
               ON m.id = g.movie_id
WHERE  year = 2019
GROUP  BY genre
ORDER  BY Count(m.id) DESC; 

/*
Output for the year 2019:
+-----------+-------------+
| genre     | movie_count |
+-----------+-------------+
| Drama     |        1078 |
| Comedy    |         574 |
| Thriller  |         398 |
| Action    |         308 |
| Horror    |         307 |
| Crime     |         212 |
| Romance   |         187 |
| Mystery   |         136 |
| Adventure |         135 |
| Sci-Fi    |          83 |
| Fantasy   |          70 |
| Family    |          53 |
| Others    |          39 |
+-----------+-------------+
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q7. How many movies belong to only one genre?

/*
Approach: Create a CTE in which we group by movie_id and count the number of genres a movie_id is associated with, in the genre table.
The filter the CTE data using the genre count. The number of entries after filter gives the number of movies with only one genre.
*/

-- Type your code below:

WITH genre_summary
     AS (SELECT movie_id,
                Count(genre) AS num_genre
         FROM   genre
         GROUP  BY movie_id)
SELECT Count(*) AS movie_count_one_genre
FROM   genre_summary
WHERE  num_genre = 1; 

/* 
Output:
+-----------------------+
| movie_count_one_genre |
+-----------------------+
|                  3289 |
+-----------------------+
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/*
Approach: Get the genre and duration attributes togerther by joining the genre and movie table.
Group by genre and aggregate duration with the average function.
*/

-- Type your code below:

SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY Avg(duration) DESC; 

/*
Output:
+-----------+--------------+
| genre     | avg_duration |
+-----------+--------------+
| Action    |       112.88 |
| Romance   |       109.53 |
| Crime     |       107.05 |
| Drama     |       106.77 |
| Fantasy   |       105.14 |
| Comedy    |       102.62 |
| Adventure |       101.87 |
| Mystery   |       101.80 |
| Thriller  |       101.58 |
| Family    |       100.97 |
| Others    |       100.16 |
| Sci-Fi    |        97.94 |
| Horror    |        92.72 |
+-----------+--------------+
*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/*
Approach: Join the genre and movie table.
Group by genre to count the number of movie in each genre.
Use the rank function over the movie count to asssign ranks to each genre.
Put this all in a CTE and filter to get the entry for Thriller genre.
*/

-- Type your code below:

WITH genre_rank_summary
     AS (SELECT genre,
                Count(id) AS movie_count,
                Rank()
                  OVER(ORDER BY Count(id) DESC) AS genre_rank
         FROM   movie AS m
                INNER JOIN genre AS g
                        ON m.id = g.movie_id
         GROUP  BY genre)
SELECT *
FROM   genre_rank_summary
WHERE  genre = 'Thriller'; 

/*
Output:
+----------+-------------+------------+
| genre    | movie_count | genre_rank |
+----------+-------------+------------+
| Thriller |        1484 |          3 |
+----------+-------------+------------+
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

----------------------------------------------------------------------------------------------------------------------------------------------------
-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?

/*
Approach: Use the Min() and Max() aggregation function on the required columns of the ratings table.
*/

-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 

/*
Output:
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
| min_avg_rating | max_avg_rating | min_total_votes | max_total_votes | min_median_rating | max_median_rating |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
|            1.0 |           10.0 |             100 |          725138 |                 1 |                10 |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
*/
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q11. Which are the top 10 movies based on average rating?
/* 
Approach: Join the ratings and movie tables
Create a CTE with ranking based on average rating using the dense_rank() function
Filter the CTE to get movies with rank less than 10
*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH rank_summary
     AS (SELECT title,
                avg_rating,
                Dense_rank()
                  OVER (ORDER BY avg_rating DESC) AS movie_rank
         FROM   ratings AS r
                INNER JOIN movie AS m
                        ON m.id = r.movie_id)
SELECT *
FROM   rank_summary
WHERE  movie_rank <= 10; 


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* 
Approach: Group by median ratings and count the number of movies within each group
 */
-- Type your code below:
-- Order by is good to have
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY Count(movie_id) DESC; 

/*
Output:
+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|             7 |        2257 |
|             6 |        1975 |
|             8 |        1030 |
|             5 |         985 |
|             4 |         479 |
|             9 |         429 |
|            10 |         346 |
|             3 |         283 |
|             2 |         119 |
|             1 |          94 |
+---------------+-------------+
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/*
Approach: Join movie and ratings table and filter records for movies with average ratings > 8 and which have data about production company
Group by production company and aggregate movie count. Rank production companies by movie count. Store the result in CTE.
Filter CTE to get the rank 1 production company
*/
-- Type your code below:

WITH production_company_summary
     AS (SELECT production_company,
                Count(movie_id)  AS MOVIE_COUNT,
                Rank()
                  OVER(ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
         FROM   ratings AS R
                INNER JOIN movie AS M
                        ON M.id = R.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_summary
WHERE  prod_company_rank = 1; 

/*
Output:
+------------------------+-------------+-------------------+
| production_company     | movie_count | prod_company_rank |
+------------------------+-------------+-------------------+
| Dream Warrior Pictures |           3 |                 1 |
| National Theatre Live  |           3 |                 1 |
+------------------------+-------------+-------------------+
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/*
Approach: Join movie, genre and ratings table to gather all the required information.
to find:
1. Number of movies released in each genre 
2. During March 2017 
3. In the USA  (LIKE or REGEXP operator for pattern matching)
4. Movies had more than 1,000 votes 
Filter the data and group by genre to count the number of movies in each genre.
*/
-- Type your code below:
SELECT genre,
       Count(M.id) AS movie_count
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

/*
Output:
+-----------+-------------+
| genre     | movie_count |
+-----------+-------------+
| Drama     |          24 |
| Comedy    |           9 |
| Action    |           8 |
| Thriller  |           8 |
| Sci-Fi    |           7 |
| Crime     |           6 |
| Horror    |           6 |
| Mystery   |           4 |
| Romance   |           4 |
| Fantasy   |           3 |
| Adventure |           3 |
| Family    |           1 |
+-----------+-------------+
*/

-- Lets try to analyse with a unique problem statement.
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/*
Approach: Join the movie, genre and ratings tables to gather all the required fields.
Filter records for movies with an average rating > 8 and starting with 'The'
*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
ORDER  BY genre, avg_rating DESC; 

/*
Output:
+--------------------------------------+------------+----------+
| title                                | avg_rating | genre    |
+--------------------------------------+------------+----------+
| Theeran Adhigaaram Ondru             |        8.3 | Action   |
| The Irishman                         |        8.7 | Crime    |
| The Gambinos                         |        8.4 | Crime    |
| Theeran Adhigaaram Ondru             |        8.3 | Crime    |
| The Brighton Miracle                 |        9.5 | Drama    |
| The Colour of Darkness               |        9.1 | Drama    |
| The Blue Elephant 2                  |        8.8 | Drama    |
| The Irishman                         |        8.7 | Drama    |
| The Mystery of Godliness: The Sequel |        8.5 | Drama    |
| The Gambinos                         |        8.4 | Drama    |
| The King and I                       |        8.2 | Drama    |
| The Blue Elephant 2                  |        8.8 | Horror   |
| The Blue Elephant 2                  |        8.8 | Mystery  |
| The King and I                       |        8.2 | Romance  |
| Theeran Adhigaaram Ondru             |        8.3 | Thriller |
+--------------------------------------+------------+----------+
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

/*
Approach: Join the ratings and movie tables. 
Filter for movies with a median rating of 8 and published btween the given time period. 
Group by rating and count the number of movies. 
*/

-- Type your code below:

SELECT median_rating,
       Count(*) AS movie_count
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY median_rating; 

/*
Output:
+-------------+
| movie_count |
+-------------+
|         361 |
+-------------+
*/


-- Once again, try to solve the problem given below.
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.

/*
Approach: Join the movie and ratings table.
Filter for movies in the required language and add up the votes. Create two CTEs, one each for German and Italian.
Join the data.
*/

-- Type your code below:
WITH german_votes
AS
  (
             SELECT     sum(total_votes) AS german_votes
             FROM       movie            AS m
             INNER JOIN ratings          AS r
             ON         m.id = r.movie_id
             WHERE      languages LIKE '%german%'),
  italian_votes
AS
  (
             SELECT     sum(total_votes) AS italian_votes
             FROM       movie            AS m
             INNER JOIN ratings          AS r
             ON         m.id = r.movie_id
             WHERE      languages LIKE '%italian%')
  SELECT *
  FROM   german_votes
  JOIN   italian_votes;

/*
Output:
+--------------+---------------+
| german_votes | italian_votes |
+--------------+---------------+
|      4421525 |       2559540 |
+--------------+---------------+
*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*
Approach: Check for NULL using IS NULL, and create a flag with value 1.
Add the flag to get the number of NULL values in each column
The flag can be directly implemented within a SUM() function using CASE statement
*/
-- Type your code below:

SELECT 
		SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/*
Output:
+------------+--------------+---------------------+------------------------+
| name_nulls | height_nulls | date_of_birth_nulls | known_for_movies_nulls |
+------------+--------------+---------------------+------------------------+
|          0 |        17335 |               13431 |                  15226 |
+------------+--------------+---------------------+------------------------+
*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)

/*
Approach: Create CTE with query to get the top 3 genre
Join names, director_mapping, movie, genre and ratings table to gather all the required fields.
Filter data by average rating > 8, genre in the top 3 genre
Group by the director's name and count the number of movies
*/

-- Type your code below:

-- top movie CTE has movie ids of top movies
WITH genre_top3
AS
  (
             SELECT     g.genre,
                        count(g.movie_id) AS movie_count,
                        r.avg_rating
             FROM       movie AS m
				INNER JOIN genre AS g
				ON         m.id = g.movie_id
					INNER JOIN ratings AS r
					ON         m.id = r.movie_id
             WHERE      r.avg_rating > 8
             GROUP BY   genre
             ORDER BY   movie_count DESC
             LIMIT      3 )
  SELECT     n.name           AS director_name,
             count( m.id)     AS movie_count
  FROM  names  AS n
	INNER JOIN director_mapping AS d
	ON         n.id = d.name_id
		INNER JOIN movie AS m
		ON         d.movie_id = m.id
			INNER JOIN genre AS g
			ON         m.id = g.movie_id
				INNER JOIN ratings AS r
				ON         m.id = r.movie_id
  WHERE      r.avg_rating > 8
  AND        g.genre IN
             (
                    SELECT genre
                    FROM   genre_top3)
  GROUP BY   director_name
  ORDER BY   movie_count DESC
  LIMIT      3;

/*
Output:
+---------------+-------------+
| director_name | movie_count |
+---------------+-------------+
| James Mangold |           4 |
| Joe Russo     |           3 |
| Anthony Russo |           3 |
+---------------+-------------+
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/*
Approach: Join role_mapping, names, movie and ratings table. 
Filter data to get only actors and movie with median rating of more than 8
Count the movies grouped by actor
*/
-- Type your code below:

SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
	   ON M.id = RM.movie_id
		INNER JOIN ratings AS R USING (movie_id)
			INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
       AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 

/*
Output:
+-----------+--------------------+
| name      | Count(rm.movie_id) |
+-----------+--------------------+
| Mammootty |                  8 |
| Mohanlal  |                  5 |
+-----------+--------------------+
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/*
Approach: Join movie and ratings table. 
Group by production company and add up the number of votes. Get the rank based on the total number of votes and put the result in a CTE.
Filter the CTE to get the top 3 production companies
*/
-- Type your code below:

WITH prod_comp_ranking
     AS (SELECT production_company,
                Sum(total_votes) AS vote_count,
                Dense_rank()
                  OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         GROUP  BY production_company)
SELECT *
FROM   prod_comp_ranking
WHERE  prod_comp_rank <= 3; 

/*
Output:
+-----------------------+------------+----------------+
| production_company    | vote_count | prod_comp_rank |
+-----------------------+------------+----------------+
| Marvel Studios        |    2656967 |              1 |
| Twentieth Century Fox |    2411163 |              2 |
| Warner Bros.          |    2396057 |              3 |
+-----------------------+------------+----------------+
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* 
Approach: Join role_mapping, names, movie and ratings table. 
Filter for movies from India and only actors. 
For each actor, compute total votes, movie count, weighted average based on votes and ranking based on the weighted average
Filter for actor who have atleast 5 Indian movies
Get the top 5 actors
*/
-- Type your code below:


SELECT     name  AS actor_name,
           Sum(total_votes)  AS total_votes,
           Count(DISTINCT m.id) AS movie_count,
           Round(Sum(total_votes * avg_rating)/ Sum(total_votes),2)  AS actor_avg_rating,
           Dense_rank() over(ORDER BY sum(total_votes * avg_rating)/ sum(total_votes) DESC, SUM(total_votes) DESC) AS actor_rank
FROM       movie m
	INNER JOIN role_mapping rm
	ON         m.id = rm.movie_id
		INNER JOIN ratings r
		ON         m.id = r.movie_id
			INNER JOIN names n
			ON         rm.name_id = n.id
WHERE  country LIKE '%india%'
	   AND category = 'actor'
GROUP BY   name
HAVING     count(DISTINCT m.id) >= 5
LIMIT      5;

/*
Output:
+------------------+-------------+-------------+------------------+------------+
| actor_name       | total_votes | movie_count | actor_avg_rating | actor_rank |
+------------------+-------------+-------------+------------------+------------+
| Vijay Sethupathi |       23114 |           5 |             8.42 |          1 |
| Fahadh Faasil    |       13557 |           5 |             7.99 |          2 |
| Yogi Babu        |        8500 |          11 |             7.83 |          3 |
| Joju George      |        3926 |           5 |             7.58 |          4 |
| Ammy Virk        |        2504 |           6 |             7.55 |          5 |
+------------------+-------------+-------------+------------------+------------+
*/

-- Top actor is Vijay Sethupathi
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/*
Approach: Join role_mapping, names, movie and ratings table. 
Filter for movies from India, in Hindi and only actress. 
For each actress, compute total votes, movie count, weighted average based on votes and ranking based on the weighted average
Filter for actress who have atleast 3 Indian movies
Get the top 5 actress
*/
-- Type your code below:

SELECT name AS actress_name,
       Sum(total_votes) AS total_votes,
       Count(m.id) AS movie_count,
       Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS actress_avg_rating,
       Dense_rank()
         OVER(ORDER BY Sum(total_votes * avg_rating)/ Sum(total_votes) DESC, Sum(total_votes) DESC) AS actress_rank
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
       INNER JOIN role_mapping rm
               ON m.id = rm.movie_id
       INNER JOIN names n
               ON rm.name_id = n.id
WHERE  country LIKE '%india%'
       AND languages LIKE '%hindi%'
       AND category = 'actress'
GROUP  BY name
HAVING Count(m.id) >= 3
LIMIT 5; 

/*
Output:
+-----------------+-------------+-------------+--------------------+--------------+
| actress_name    | total_votes | movie_count | actress_avg_rating | actress_rank |
+-----------------+-------------+-------------+--------------------+--------------+
| Taapsee Pannu   |       18061 |           3 |               7.74 |            1 |
| Kriti Sanon     |       21967 |           3 |               7.05 |            2 |
| Divya Dutta     |        8579 |           3 |               6.88 |            3 |
| Shraddha Kapoor |       26779 |           3 |               6.63 |            4 |
| Kriti Kharbanda |        2549 |           3 |               4.80 |            5 |
+-----------------+-------------+-------------+--------------------+--------------+
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

-----------------------------------------------------------------------------------------------------------------------------------------------------
/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/

/*
Approach: Join genre, movie and ratings tables. 
Filter for movie in the thriller genre
Classify mvies based on average rating using CASE statement. 
*/

-- Type your code below:

SELECT title,
       avg_rating,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movie'
		 WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movie'
		 WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movie'
		 ELSE 'Flop movie'
       end AS category
FROM   movie m
       INNER JOIN genre g
               ON m.id = g.movie_id
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  genre = 'thriller'
ORDER  BY avg_rating DESC; 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/*
Approach: Use window frames to calculate the running total and moving averages of the movie duration 
*/
-- Type your code below:

SELECT genre,
       Round(avg_duration, 2) AS avg_duration,
       Round(SUM(avg_duration) over (PARTITION BY genre ORDER BY id), 2) AS running_total_duration,
       Round(Avg(avg_duration) over (PARTITION BY genre ORDER BY id ROWS BETWEEN unbounded preceding AND CURRENT ROW),2) AS moving_avg_duration
FROM   (SELECT g.genre,
               Avg(m.duration) AS avg_duration,
               m.id
        FROM   movie m
               INNER JOIN genre g
                 ON m.id = g.movie_id
        GROUP  BY g.genre, m.id) AS genre_avg_duration; 

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* 
Approach: Retrieve the top 3 genres, the movies within those gneres. 
Rank them according to worldwide gross income while partioning by year. 
Filter the top 5 ranks in each year
Note: We need to clean the data in the worlwide_gross_income column, by discarding the currency signs and converting INR to $. 
*/
-- Type your code below: 

-- Top 3 Genres based on most number of movies

WITH top_genre
AS
  (
           SELECT   genre
           FROM     genre
           GROUP BY genre
           ORDER BY count(movie_id) DESC
           LIMIT    3 )
  , top_movies
AS
  (
             SELECT     genre,
                        year,
                        title AS movie_name,
                        CASE
                                   WHEN substring_index(worlwide_gross_income,' ', 1) REGEXP '$' THEN cast(substring_index(worlwide_gross_income,' ', -1) AS UNSIGNED)
                                   WHEN substring_index(worlwide_gross_income,' ', 1) REGEXP 'inr' THEN round(cast(substring_index(worlwide_gross_income,' ', -1) AS UNSIGNED)/80)
                        end AS worlwide_gross_income
             FROM       movie m
             INNER JOIN genre g
             ON         m.id = g.movie_id
             WHERE      genre IN
                        (      SELECT *
                               FROM   top_genre ) ),
  movie_ranking
AS
  (
           SELECT   *,
                    dense_rank() over(partition BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
           FROM     top_movies )
  SELECT   *
  FROM     movie_ranking
  WHERE    movie_rank <=5
  ORDER BY year;
  
/*
Output:
+----------+------+--------------------------------+-----------------------+------------+
| genre    | year | movie_name                     | worlwide_gross_income | movie_rank |
+----------+------+--------------------------------+-----------------------+------------+
| Thriller | 2017 | The Fate of the Furious        |            1236005118 |          1 |
| Comedy   | 2017 | Despicable Me 3                |            1034799409 |          2 |
| Comedy   | 2017 | Jumanji: Welcome to the Jungle |             962102237 |          3 |
| Drama    | 2017 | Zhan lang II                   |             870325439 |          4 |
| Thriller | 2017 | Zhan lang II                   |             870325439 |          4 |
| Comedy   | 2017 | Guardians of the Galaxy Vol. 2 |             863756051 |          5 |
| Thriller | 2018 | The Villain                    |            1300000000 |          1 |
| Drama    | 2018 | Bohemian Rhapsody              |             903655259 |          2 |
| Thriller | 2018 | Venom                          |             856085151 |          3 |
| Thriller | 2018 | Mission: Impossible - Fallout  |             791115104 |          4 |
| Comedy   | 2018 | Deadpool 2                     |             785046920 |          5 |
| Drama    | 2019 | Avengers: Endgame              |            2797800564 |          1 |
| Drama    | 2019 | The Lion King                  |            1655156910 |          2 |
| Comedy   | 2019 | Toy Story 4                    |            1073168585 |          3 |
| Drama    | 2019 | Joker                          |             995064593 |          4 |
| Thriller | 2019 | Joker                          |             995064593 |          4 |
| Thriller | 2019 | Ne Zha zhi mo tong jiang shi   |             700547754 |          5 |
+----------+------+--------------------------------+-----------------------+------------+
*/


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* 
Approach: Multilingual movies are identified by looking for ',' separating the two or more languages in the languages column
Filter for multilingual movies, having median rating greater than 8 and with data about production company
Count the movies and rank the production companies by movie count
*/
-- Type your code below:
WITH prod_ranking
AS
  (
             SELECT     production_company,
                        count(m.id) AS movie_count,
                        dense_rank() over(ORDER BY count(m.id) DESC) AS prod_comp_rank
             FROM       movie m
				INNER JOIN ratings r
				ON         m.id = r.movie_id
             WHERE POSITION(',' IN languages)>0
             AND        median_rating >= 8
             AND        production_company IS NOT NULL
             GROUP BY   production_company)
  SELECT *
  FROM   prod_ranking
  WHERE  prod_comp_rank <= 2;

/*
Output:
+-----------------------+-------------+----------------+
| production_company    | movie_count | prod_comp_rank |
+-----------------------+-------------+----------------+
| Star Cinema           |           7 |              1 |
| Twentieth Century Fox |           4 |              2 |
+-----------------------+-------------+----------------+
*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* 
Approach: Join role_mapping, names, movie, genre and ratings table. 
Filter records for only actress, movies in drama genre with a average rating of more than 8
Compute total votes, movies count, weighted avarage and rank by superhit movie count. 
Filter for top 3 actress. 
*/
-- Type your code below:

SELECT   name                                                       AS actress_name,
         Sum(total_votes)                                           AS total_votes,
         Count(DISTINCT m.id)                                       AS movie_count,
         Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS actress_avg_rating,
         Dense_rank() over (ORDER BY count(DISTINCT m.id) DESC)     AS actress_rank
FROM     movie m
	INNER JOIN     role_mapping rm
	ON       m.id = rm.movie_id
		INNER JOIN     names n
		ON       rm.name_id = n.id
			INNER JOIN     ratings r
			ON       m.id = r.movie_id
				INNER JOIN     genre g
				ON       m.id = g.movie_id
WHERE    rm.category = 'Actress'
AND      avg_rating > 8
AND      g.genre = 'Drama'
GROUP BY name
ORDER BY actress_rank
LIMIT    3;

/*
Output:
+---------------------+-------------+-------------+--------------------+--------------+
| actress_name        | total_votes | movie_count | actress_avg_rating | actress_rank |
+---------------------+-------------+-------------+--------------------+--------------+
| Amanda Lawrence     |         656 |           2 |               8.94 |            1 |
| Denise Gough        |         656 |           2 |               8.94 |            1 |
| Parvathy Thiruvothu |        4974 |           2 |               8.25 |            1 |
+---------------------+-------------+-------------+--------------------+--------------+
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------
/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations
*/

/*
Approach: Join movie, names, director_mapping and ratings table to gather all the required fields. 
Use lead function to get the publishing date of the next movie, and compute the inter-movie duration
*/
-- Type you code below:

WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping AS d
			INNER JOIN names AS n
			ON         n.id = d.name_id
				INNER JOIN movie AS m
				ON         m.id = d.movie_id
					INNER JOIN ratings AS r
					ON         r.movie_id = m.id ), 
top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;

/*
Output:
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| director_id | director_name     | number_of_movies | avg_inter_movie_days | avg_rating | total_votes | min_rating | max_rating | total_duration |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| nm2096009   | Andrew Jones      |                5 |               190.75 |       3.02 |        1989 |        2.7 |        3.2 |            432 |
| nm1777967   | A.L. Vijay        |                5 |               176.75 |       5.42 |        1754 |        3.7 |        6.9 |            613 |
| nm0814469   | Sion Sono         |                4 |               331.00 |       6.03 |        2972 |        5.4 |        6.4 |            502 |
| nm0831321   | Chris Stokes      |                4 |               198.33 |       4.33 |        3664 |        4.0 |        4.6 |            352 |
| nm0515005   | Sam Liu           |                4 |               260.33 |       6.23 |       28557 |        5.8 |        6.7 |            312 |
| nm0001752   | Steven Soderbergh |                4 |               254.33 |       6.48 |      171684 |        6.2 |        7.0 |            401 |
| nm0425364   | Jesse V. Johnson  |                4 |               299.00 |       5.45 |       14778 |        4.2 |        6.5 |            383 |
| nm2691863   | Justin Price      |                4 |               315.00 |       4.50 |        5343 |        3.0 |        5.8 |            346 |
| nm6356309   | Özgür Bakar       |                4 |               112.00 |       3.75 |        1092 |        3.1 |        4.9 |            374 |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
*/
-----------------------------------------------------------------------------------------------------------------------------------------------------

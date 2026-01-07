USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) AS total_rows_in_director_mapping
FROM director_mapping;
   
Select count(*) as total_rows_in_movie
From movie;

SELECT COuNT(*) AS total_rows_in_genre
From genre;

Select count(*) as total_rows_in_role_mapping
From role_mapping;

Select count(*) as total_rows_in_names
From names;

Select count(*) as total_rows_in_ratings
From ratings;




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 'id' AS movie_id, COUNT(*) AS null_count
FROM movie
WHERE id IS NULL
UNION ALL
SELECT 'title', COUNT(*) 
FROM movie WHERE title IS NULL
UNION ALL
SELECT 'year', COUNT(*) FROM movie 
WHERE year IS NULL
UNION ALL
SELECT 'date_published', 
COUNT(*) FROM movie 
WHERE date_published IS NULL
UNION ALL
SELECT 'duration', COUNT(*) 
FROM movie 
WHERE duration IS NULL
UNION ALL
SELECT 'country', COUNT(*) 
FROM movie 
WHERE country IS NULL
UNION ALL
SELECT 'worlwide_gross_income', COUNT(*) 
FROM movie 
WHERE worlwide_gross_income IS NULL
UNION ALL
SELECT 'languages', COUNT(*) 
FROM movie 
WHERE languages IS NULL
UNION ALL
SELECT 'production_company', COUNT(*) 
FROM movie 
WHERE production_company IS NULL;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)



/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year, COUNT(*) AS number_of_movies 
FROM movie 
GROUP BY year 
ORDER BY year;

SELECT MONTH(date_published) AS month_num, COUNT(id) AS number_Of_movies 
FROM movie 
GROUP BY MONTH(date_published) 
ORDER BY month_num ;




/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(id) AS num_of_movies 
FROM movie 
WHERE( country LIKE '%USA%' 
      OR country LIKE '%India%')
   AND YEAR(date_published) = 2019;


-- 1059 movies were produced in USA or India in the year 2019.




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre 
FROM genre;
 
-- We have total 13 unique genere.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre, COUNT(id) AS total_movies
FROM movie m
JOIN genre g 
    ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY total_movies DESC



-- Drama has the highest no. of movies with 4285 movies





/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:



SELECT COUNT(*) AS movies_with_one_genre
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(DISTINCT genre) = 1
) AS one_genre_movies;

-- There are 3289 movies with only single genre




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, ROUND(AVG(m.duration), 0) AS avg_duration
FROM movie m
JOIN genre g 
    ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC;

-- Highest duration is 113 for Action and the minimun duration is 93 for Horror 
-- For Drama the average duration is 107



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT genre, total_movies, genre_rank
FROM (SELECT genre, COUNT(m.id) AS total_movies,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
    FROM movie m
    JOIN genre g 
        ON m.id = g.movie_id
    GROUP BY g.genre) AS ranked_genres
WHERE genre = 'Thriller';


-- Genre Thriller is ranked 3rd with total 1484 movies



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Minimum 
SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MIN(median_rating) AS min_median_rating
FROM ratings;

-- Maximums
SELECT 
    MAX(avg_rating) AS max_avg_rating,
    MAX(total_votes) AS max_total_votes,
    MAX(median_rating) AS max_median_rating
FROM ratings;

-- Minimum 
-- Avg_rating 1 
-- Min_total_votes 100
-- Min_median_rating 1
-----------------------
-- Maximums
-- Max_avg_rating 10
-- Max_total_votes 725138
-- Max_median_rating - 10


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

SELECT title, avg_rating, 
    RANK() OVER( 
ORDER BY avg_rating DESC ) movie_rank 
FROM ratings a 
   JOIN
      movie b 
      on a.movie_id = b.id 
ORDER BY
   3 LIMIT 10






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT median_rating, COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;

-- Median rating rank 1 is 94 and 10 is 346

 

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, count(m.id) AS movie_count,
   RANK() OVER(
ORDER BY
   count(m.id) DESC) prod_company_rank 
From ratings r 
inner join movie m
on r.movie_id=m.id 
Where r.avg_rating > 8
Group by m.production_company 
Limit 5;








-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT
   genre,
   COUNT(g.movie_id) AS movie_count 
FROM
   genre g 
   INNER JOIN
      movie m 
      ON g.movie_id = m.id 
   INNER JOIN
      ratings r 
      ON m.id = r.movie_id
WHERE
   year = 2017 
   AND MONTH(date_published) = 3 
   AND LOWER(country) LIKE '%USA%' 
   AND total_votes > 1000 
GROUP BY
   genre 
ORDER BY
   movie_count DESC;


-- Drama has the higest votings at 24 and family has the lowest with 1


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT DISTINCT
   title, avg_rating , genre
FROM
   genre g 
   INNER JOIN
      movie m 
      ON g.movie_id = m.id 
   INNER JOIN
      ratings r 
      ON m.id = r.movie_id
WHERE
    title like 'The%' AND avg_rating>8
ORDER BY genre, avg_rating asc;

-- Moivw the Brighton Miracle has the highest rating at 9.5





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(DISTINCT id) AS num_movies
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
AND r.median_rating = 8;

-- The total count for number of movies that have a median_rating = to 8 is 361


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, SUM(r.total_votes) AS total_votes
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
WHERE m.country LIKE '%German%' 
   OR m.country LIKE '%Ital%'
GROUP BY m.country;

-------

SELECT  sum(total_votes) 
FROM movie m 
JOIN
  ratings r 
  ON m.id = r.movie_id 
WHERE country LIKE '%Germany%' ;

-- 2026223 is the sum of total votes for German movies.

SELECT sum(total_votes) 
FROM movie m 
JOIN
  ratings r 
  ON m.id = r.movie_id 
WHERE country LIKE '%Ital%' ;

-- 703024 is the sum of total votes for Italy.

-- Thus German movies get more votes than Italian movies.

-- Answer is Yes


/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 'id' AS id_nulls, COUNT(*) 
FROM names
WHERE id IS NULL
UNION ALL
SELECT 'name' AS name_nulls, COUNT(*) 
FROM names 
WHERE name IS NULL
UNION ALL
SELECT 'height' AS height_nulls, COUNT(*) 
FROM names 
WHERE height IS NULL
UNION ALL
SELECT 'date_of_birth' AS date_of_birth_nulls, COUNT(*) 
FROM names 
WHERE date_of_birth IS NULL
UNION ALL
SELECT 'known_for_movies' AS known_for_movies_nulls, COUNT(*) 
FROM names 
WHERE known_for_movies IS NULL;




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_genres AS (
    SELECT 
        g.genre,
        COUNT(*) AS movie_count
    FROM genre g
    JOIN ratings r 
        ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY movie_count DESC
    LIMIT 3
),
director_counts AS (
    SELECT 
        n.name AS director_name,
        g.genre,
        COUNT(*) AS movie_count
    FROM ratings r
    JOIN genre g 
        ON r.movie_id = g.movie_id
    JOIN director_mapping d 
        ON g.movie_id = d.movie_id
    JOIN names n 
        ON d.name_id = n.id
    WHERE r.avg_rating > 8
      AND g.genre IN (SELECT genre FROM top_genres)
    GROUP BY n.name, g.genre
)
SELECT 
    director_name, 
    SUM(movie_count) AS movie_count
FROM director_counts
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;


-- James Mangold 4 , Joe Russo 3 , Anthony Russo 3.ALTER



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT  n.name AS actor_name, COUNT(*) AS movie_count
FROM ratings r
JOIN role_mapping rm 
    ON r.movie_id = rm.movie_id
JOIN names n 
    ON rm.name_id = n.id
WHERE r.median_rating >= 8
  AND rm.category = 'actor'
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;



-- Top 2 actors Mammootty 8 ,  Mohanlal 5.ALTER



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company , sum(total_votes) as Vote_count ,rank () over (order by sum(total_votes) desc) as prod_comp_rank
from movie m 
join ratings r
on m.id=r.movie_id
Where m.production_company is not null 
Group by m.production_company
Order by Vote_count desc
Limit 3 ;

-- Top 3 production companies are Marvel Studios, Twentieth Century Fox  ad Warner bros. 



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actor_movie_stats AS (
SELECT 
    n.name AS actor_name, 
    SUM(r.total_votes) AS total_votes, 
    COUNT(DISTINCT m.id) AS movie_count, 
    SUM(r.avg_rating * r.total_votes) * 1.0 / SUM(r.total_votes) AS actor_avg_rating
FROM movie m  
JOIN ratings r 
     ON m.id = r.movie_id
JOIN role_mapping rm 
     ON m.id = rm.movie_id
JOIN names n 
     ON rm.name_id = n.id
WHERE m.country LIKE '%India%' 
  AND rm.category = 'actor'
GROUP BY n.name
HAVING COUNT(DISTINCT m.id) >= 5
ORDER BY actor_avg_rating DESC, total_votes DESC
LIMIT 10
)
SELECT 
    actor_name,
    total_votes,
    movie_count,
    ROUND(actor_avg_rating, 2) AS actor_avg_rating,
    RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM actor_movie_stats
ORDER BY actor_rank
LIMIT 10;



-- The 1st actore in the list is Vijay Sethupathi and the 10th is Dulquer Salmaan



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_movie_stats AS (
    SELECT n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT m.id) AS movie_count,
        SUM(r.avg_rating * r.total_votes) * 1.0 / SUM(r.total_votes) AS actress_avg_rating
FROM movie m  
JOIN ratings r 
     ON m.id = r.movie_id
JOIN role_mapping rm 
     ON m.id = rm.movie_id
JOIN names n 
     ON rm.name_id = n.id
WHERE m.country LIKE '%India%' 
  AND m.languages LIKE '%Hindi%'
  AND rm.category = 'actress'
GROUP BY n.name
HAVING COUNT(DISTINCT m.id) >= 3
ORDER BY actress_avg_rating DESC, total_votes DESC
LIMIT 5
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    ROUND(actress_avg_rating, 2) AS actress_avg_rating,
    RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM actress_movie_stats
ORDER BY actress_rank
LIMIT 10;
 
 -- 1st Actress in the list is Taapsee Pannu with an average rating of 7.74 and the 5th in the list is Kriti Karbanda with an average rating of 4.80
 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:

WITH category_map AS (
    SELECT 9 AS min_rating, 10 AS max_rating, 'Superhit' AS movie_category
    UNION ALL
    SELECT 7, 8, 'Hit'
    UNION ALL
    SELECT 5, 6.99, 'One-time-watch'
    UNION ALL
    SELECT 0, 4.99, 'Flop'
)
SELECT 
    m.title AS movie_name,
    c.movie_category
FROM movie m
JOIN ratings r 
    ON m.id = r.movie_id
JOIN genre g
    ON m.id = g.movie_id
JOIN category_map c
    ON r.avg_rating BETWEEN c.min_rating AND c.max_rating
WHERE g.genre LIKE '%Thriller%'
  AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC;



 -- Forushande is a HIT movie 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_summary AS 
(
   SELECT genre, Round (AVG(duration),2) as avg_duration
   FROM genre g 
   Left join movie m 
   On g.movie_id = m.id
   Group by genre
   )
   Select * , sum(avg_duration) over(
   Order by genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
   AVG(avg_duration) OVER (
ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration 
FROM
   genre_summary;








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

SELECT genre, COUNT(id) AS total_movies
FROM movie m
JOIN genre g 
    ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY total_movies DESC
Limit 3 ;


-- Top 3 genre are Drama , Compedy and Thriller 

WITH top_genres AS (
SELECT 
    genre,
    COUNT(m.id) AS movie_count,
	RANK () OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM genre g
LEFT JOIN
    movie AS m 
	ON g.movie_id = m.id
GROUP BY genre
)
,
top_grossing AS (
SELECT g.genre, year, m.title as movie_name, worlwide_gross_income,
    RANK() OVER (PARTITION BY g.genre, year
		ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
FROM movie m
	INNER JOIN
genre g
	ON g.movie_id = m.id
WHERE g.genre IN (SELECT DISTINCT genre FROM top_genres WHERE genre_rank<=3)
)
SELECT * 
FROM top_grossing
WHERE movie_rank<=5;





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH multilingual_hits AS ( 
SELECT m.production_company, COUNT(m.id) AS movie_count
FROM m.movies
JOIN ratings r 
ON m.id = movie_id 
WHERE m.languages LIKE '%,%'   -- multilingual condition
    AND r.median_rating >= 8     -- hit condition
    AND m.production_company IS NOT NULL
    GROUP BY m.production_company
)
ranked_prod AS (
    SELECT 
        production_company,
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM multilingual_hits
)
SELECT 
    production_company,
    movie_count,
    prod_comp_rank
FROM ranked_prod
WHERE prod_comp_rank <= 2;




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:


WITH superhit_actresses AS (
    SELECT 
        n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(DISTINCT m.id) AS movie_count,
        SUM(r.avg_rating * r.total_votes) * 1.0 / SUM(r.total_votes) AS actress_avg_rating
    FROM movie m 
    JOIN ratings r 
        ON m.id = r.movie_id    
    JOIN genre g  
        ON m.id = g.movie_id
    JOIN role_mapping rm
        ON m.id = rm.movie_id
    JOIN names n
        ON rm.name_id = n.id
    WHERE g.genre = 'Drama'
      AND r.avg_rating > 8        -- Superhit condition (movie-level filter)
      AND rm.category = 'actress'
    GROUP BY n.name
)

SELECT 
    actress_name, 
    total_votes, 
    movie_count, 
    ROUND(actress_avg_rating, 4) AS actress_avg_rating,
    RANK() OVER (
        ORDER BY actress_avg_rating DESC, total_votes DESC, actress_name ASC
    ) AS actress_rank
FROM superhit_actresses
WHERE movie_count > 0
ORDER BY actress_rank
LIMIT 3;

    

-- The top 3 actress based on super no. of super hit movies are Sangeetha Bhat, Adriana Matoshi, Fatmire Sahiti




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

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_movies AS (
    SELECT 
        d.name_id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.date_published,
        r.avg_rating,
        r.total_votes,
        r.median_rating,
        m.duration
    FROM director_mapping d
    JOIN names n 
        ON d.name_id = n.id
    JOIN movie m 
        ON d.movie_id = m.id
    JOIN ratings r 
        ON m.id = r.movie_id
),
ranked_movies AS (
    SELECT 
        director_id,
        director_name,
        movie_id,
        date_published,
        duration,
        avg_rating,
        total_votes,
        ROW_NUMBER() OVER (
            PARTITION BY director_id 
            ORDER BY date_published
        ) AS rn
    FROM director_movies
),
inter_movie_gaps AS (
    SELECT 
        curr.director_id,
        curr.director_name,
        DATEDIFF(curr.date_published, prev.date_published) AS gap_days
    FROM ranked_movies curr
    JOIN ranked_movies prev
        ON curr.director_id = prev.director_id
       AND curr.rn = prev.rn + 1
)
SELECT 
    dm.director_id,
    dm.director_name,
    COUNT(DISTINCT dm.movie_id) AS number_of_movies,
    ROUND(AVG(img.gap_days),0) AS avg_inter_movie_days,
    ROUND(AVG(dm.avg_rating),2) AS avg_rating,
    SUM(dm.total_votes) AS total_votes,
    MIN(dm.avg_rating) AS min_rating,
    MAX(dm.avg_rating) AS max_rating,
    SUM(dm.duration) AS total_duration
FROM director_movies dm
LEFT JOIN inter_movie_gaps img
    ON dm.director_id = img.director_id
GROUP BY dm.director_id, dm.director_name
ORDER BY number_of_movies DESC
LIMIT 9;


-- Script ended 


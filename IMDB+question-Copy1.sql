USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(1) movie_count FROM movie; -- 7997
SELECT COUNT(1) genre_count FROM genre; -- 14662
SELECT COUNT(1) director_mapping_count FROM director_mapping; -- 3867
SELECT COUNT(1) role_mapping_count FROM role_mapping; -- 15615
SELECT COUNT(1) names_count FROM names; -- 25735
SELECT COUNT(1) ratings_count FROM ratings; -- 7997


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT COUNT(1) AS total_null_count FROM movie WHERE title IS NULL; -- 0
SELECT COUNT(1) AS total_null_count FROM movie WHERE year IS NULL; -- 0
SELECT COUNT(1) AS total_null_count FROM movie WHERE date_published IS NULL; -- 0
SELECT COUNT(1) AS total_null_count FROM movie WHERE duration IS NULL; -- 0
SELECT COUNT(1) AS total_null_count FROM movie WHERE country IS NULL; -- 20
SELECT COUNT(1) AS total_null_count FROM movie WHERE worlwide_gross_income IS NULL; -- 3724
SELECT COUNT(1) AS total_null_count FROM movie WHERE languages IS NULL; -- 194
SELECT COUNT(1) AS total_null_count FROM movie WHERE production_company IS NULL; -- 528

(OR)

SELECT 
        SUM(title IS NULL) AS null_title_count,
        SUM(year IS NULL) AS null_year_count,
        SUM(date_published IS NULL) AS null_date_published_count,
        SUM(duration IS NULL) AS null_duration_count,
        SUM(country IS NULL) AS null_country_count,
        SUM(worlwide_gross_income IS NULL) AS null_worlwide_gross_income_count,
        SUM(languages IS NULL) AS null_languages_count,
        SUM(production_company IS NULL) AS null_production_company_count
FROM movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+ */

SELECT 
        year AS Year,
        COUNT(id) AS number_of_movies
        
FROM 
        movie
GROUP BY 
        year 
ORDER BY 
        year;  

2017 --> 3052
2018 --> 2944
2019 --> 2001

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT  MONTH(date_published) AS 'month_num' ,
		COUNT(id) number_of_movies
FROM	imdb.movie
GROUP BY MONTH(date_published)
ORDER BY month_num;

O/P
-----
1	804
2	640
3	824
4	680
5	625
6	580
7	493
8	678
9	809
10	801
11	625
12	438

Trend
------

SELECT  MONTH(date_published) AS 'month_num' ,
		COUNT(id) number_of_movies
FROM	imdb.movie
GROUP BY MONTH(date_published)
ORDER BY number_of_movies DESC;

3	824
9	809
1	804
10	801
4	680
8	678
2	640
11	625
5	625
6	580
7	493
12	438


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 	COUNT(id) total_movies -- 1059
FROM	imdb.movie
WHERE	(country like '%USA%' OR country like '%India%')
AND		year = 2019;

(OR)

SELECT 	COUNT(id) total_movies
FROM	imdb.movie
WHERE	country regexp '(USA|India)'
AND		year = 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 	genre 
FROM 	imdb.genre
GROUP BY genre
ORDER BY genre;

(OR)

SELECT 	DISTINCT genre 
FROM 	imdb.genre
ORDER BY genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 	genre
FROM 	genre
GROUP BY genre
ORDER BY COUNT(1) DESC
LIMIT 1;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT	COUNT(a.movie_id) -- 3289
FROM	(
			SELECT	movie_id
			FROM	genre
			GROUP BY movie_id
			HAVING COUNT( DISTINCT genre) = 1
		) a;


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

SELECT		g.genre, ROUND(AVG(m.duration), 2) avg_duration
FROM		genre g INNER JOIN movie m
ON			g.movie_id = m.id
GROUP BY	g.genre;

O/P
---
Action	112.8829
Adventure	101.8714
Comedy	102.6227
Crime	107.0517
Drama	106.7746
Family	100.9669
Fantasy	105.1404
Horror	92.7243
Mystery	101.8000
Others	100.1600
Romance	109.5342
Sci-Fi	97.9413
Thriller	101.5761

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



WITH genre_movie_rank AS
(
	SELECT		a.genre, a.movie_count, RANK() OVER(ORDER BY movie_count DESC) genre_rank
	FROM		(
					SELECT		genre, COUNT(1) movie_count
					FROM		genre
					GROUP BY	genre
				) a
)
SELECT	*
FROM	genre_movie_rank
WHERE	genre = 'Thriller';

O/P
----
Genre		movie_count		genre_rank
-----		-----------		----------
Thriller			1484			3

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

SELECT		MIN(avg_rating) min_avg_rating,
			MAX(avg_rating) max_avg_rating,
            MIN(total_votes) min_total_votes,
			MAX(total_votes) max_total_votes,
            MIN(median_rating) min_median_rating,
			MAX(median_rating) max_median_rating
FROM		ratings;

O/P
----    
/*
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|			10.0	|	       100		  |	   725138    		 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

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
-- It's ok if RANK() or DENSE_RANK() is used too


WITH movie_rank_query AS
(
	SELECT	a.*
	FROM	(
				SELECT		movie_id, avg_rating, RANK() OVER(ORDER BY avg_rating DESC) movie_rank
				FROM		ratings
			) a
	WHERE	movie_rank <= 10
)
SELECT	m.title, 
		mr.avg_rating, 
        mr.movie_rank
FROM	movie_rank_query mr INNER JOIN movie m
ON		mr.movie_id = m.id;

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

SELECT	median_rating,
		COUNT(movie_id) movie_count
FROM	ratings
GROUP BY median_rating
ORDER BY movie_count DESC;


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

SELECT	a.*
FROM	(
			SELECT	production_company, 
					COUNT(movie_id) AS movie_count,
					RANK() OVER(ORDER BY COUNT(movie_id) DESC) prod_company_rank
			FROM	ratings r INNER JOIN movie m
					ON r.movie_id = m.id
			WHERE	production_company IS NOT NULL
			AND		r.avg_rating > 8 
			GROUP BY production_company
		) a
WHERE	a.prod_company_rank = 1;



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

-- change here

SELECT	g.genre, 
		COUNT(m.id) movie_count
FROM	ratings r INNER JOIN movie m
ON		(r.total_votes > 1000 	AND 
		r.movie_id = m.id)
		INNER JOIN genre g
ON		g.movie_id = m.id
WHERE	m.country like '%USA%'
AND		m.year = 2017
AND		MONTH(m.date_published) = 3
GROUP BY genre
ORDER BY movie_count DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. 
Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
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

SELECT	m.title,
		r.avg_rating,
        g.genre
FROM	movie m INNER JOIN ratings r
ON		r.movie_id = m.id
		INNER JOIN genre g
ON		g.movie_id = m.id
WHERE	r.avg_rating > 8
AND		m.title LIKE 'The%'
ORDER BY r.avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT	COUNT(m.id) total_movies
FROM	ratings r INNER JOIN movie m
ON		r.movie_id = m.id
WHERE	r.median_rating = 8
AND		m.date_published >= '2018-04-01'
AND		m.date_published <= '2019-04-01';


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT	(CASE WHEN a.german_votes > a.Italian_votes THEN 'Yes' ELSE 'No' END ) flag
FROM(
		SELECT	SUM(CASE WHEN m.languages LIKE '%German%' THEN r.total_votes ELSE 0 END) german_votes,
				SUM(CASE WHEN m.languages LIKE '%Italian%' THEN r.total_votes ELSE 0 END)Italian_votes
		FROM	ratings r INNER JOIN movie m
		ON		r.movie_id = m.id
		WHERE	m.languages REGEXP '(German|Italian)'
	) a;

(OR)

SELECT 
        m.languages,
        SUM(r.total_votes) AS total_votes
FROM 
        movie m
        INNER JOIN
        ratings r
        ON
        m.id = r.movie_id
WHERE 
        m.languages LIKE '%German%'
        OR
        m.languages LIKE '%Italian%'       
GROUP BY 
        m.languages;                


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


SELECT COUNT(1) name_nulls FROM names WHERE name IS NULL;
SELECT COUNT(1) height_nulls FROM names WHERE height IS NULL;
SELECT COUNT(1) date_of_birth_nulls FROM names WHERE date_of_birth IS NULL;
SELECT COUNT(1) known_for_movies_nulls FROM names WHERE known_for_movies IS NULL;

(OR)

SELECT 
        SUM(name IS NULL) AS name_nulls,
        SUM(height IS NULL) AS height_nulls,
        SUM(date_of_birth IS NULL) AS date_of_birth_nulls,
        SUM(known_for_movies IS NULL) AS known_for_movies_nulls
FROM 
        names;



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

WITH genre_ranks AS
(
	SELECT	gr.movie_id,
			gr.total_movies,
			DENSE_RANK()OVER(ORDER BY total_movies DESC) genres_rank
	FROM	(
				SELECT	g.genre,
						g.movie_id,
						COUNT(g.movie_id) OVER(PARTITION BY g.genre) total_movies
				FROM	ratings r INNER JOIN genre g
				ON		r.movie_id = g.movie_id
				WHERE	r.avg_rating > 8
			) gr
)
SELECT	n.name director_name, COUNT(dm.movie_id) movie_count
FROM	genre_ranks gr INNER JOIN director_mapping dm
ON		gr.movie_id = dm.movie_id
		INNER JOIN names n
ON		dm.name_id = n.id
WHERE	gr.genres_rank <= 3
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;



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


SELECT	n.name actor_name, COUNT(r.movie_id) movie_count
FROM	ratings r INNER JOIN role_mapping rm
ON		r.movie_id = rm.movie_id
		INNER JOIN names n
ON		rm.name_id = n.id
WHERE	r.median_rating >= 8
AND		rm.category = 'actor'
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 2;


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


SELECT	tph.production_company,
		tph.vote_count,
        tph.prod_comp_rank
FROM
(
	SELECT	pcv.production_company,
			pcv.vote_count,
			RANK()OVER(ORDER BY pcv.vote_count DESC) prod_comp_rank
	FROM	(
				SELECT	m.production_company, SUM(r.total_votes) vote_count
				FROM	ratings r INNER JOIN movie m
				ON		r.movie_id = m.id
				GROUP BY m.production_company
			) pcv
) tph -- top_prod_houses
WHERE	tph.prod_comp_rank <= 3;


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

SELECT	acr.actor_name
,		acr.total_votes
,		movie_count
,		actor_avg_rating
,		RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) actor_rank
FROM	(
			SELECT		n.name actor_name
			,			SUM(r.total_votes) total_votes
			,			COUNT(m.id) movie_count
			,			ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actor_avg_rating,
			FROM		ratings r INNER JOIN role_mapping rm
			ON			r.movie_id = rm.movie_id
						INNER JOIN names n
			ON			rm.name_id = n.id
						INNER JOIN movie m
			ON			r.movie_id = m.id
			WHERE		m.country like '%India%'
			AND			rm.category = 'actor'
			GROUP BY 	n.name
			HAVING		COUNT(m.id) >= 5
		) acr -- actor ratings
ORDER BY actor_rank;




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

SELECT	acr.actor_name
,		acr.total_votes
,		movie_count
,		actor_avg_rating
,		RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) actor_rank
FROM	(
			SELECT		n.name actor_name
			,			SUM(r.total_votes) total_votes
			,			COUNT(m.id) movie_count
			,			ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actor_avg_rating,
			FROM		ratings r INNER JOIN role_mapping rm
			ON			r.movie_id = rm.movie_id
						INNER JOIN names n
			ON			rm.name_id = n.id
						INNER JOIN movie m
			ON			r.movie_id = m.id
			WHERE		m.country like '%India%'
			AND			rm.category = 'actor'
			GROUP BY 	n.name
			HAVING		COUNT(m.id) >= 5
		) acr -- actor ratings
ORDER BY actor_rank;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


SELECT	acr.actor_name
,		acr.total_votes
,		movie_count
,		actor_avg_rating
,		RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) actor_rank
FROM	(
			SELECT		n.name actor_name
			,			SUM(r.total_votes) total_votes
			,			COUNT(m.id) movie_count
			,			ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS actor_avg_rating
			FROM		ratings r INNER JOIN role_mapping rm
			ON			r.movie_id = rm.movie_id
						INNER JOIN names n
			ON			rm.name_id = n.id
						INNER JOIN movie m
			ON			r.movie_id = m.id
			WHERE		m.country like '%India%'
			AND			rm.category = 'actress'
			GROUP BY 	n.name
			HAVING		COUNT(m.id) >= 5
		) acr -- actor ratings
ORDER BY actor_rank;

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:



SELECT	m.title,
		(CASE 	WHEN r.avg_rating > 8 THEN 'Superhit movies'
				WHEN r.avg_rating > 7 AND r.avg_rating <= 8 THEN 'Hit movies'
				WHEN r.avg_rating >= 5 AND r.avg_rating <= 7 THEN 'One-time-watch movies'
				ELSE 'Flop movies'
		END) thriller_category
FROM	ratings r INNER JOIN movie m
ON		r.movie_id = m.id
		INNER JOIN genre g
ON		g.movie_id = m.id
WHERE	r.genre = 'thriller';




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



SELECT	g.genre, 
		AVG(duration) OVER(PARTITION BY g.genre) avg_duration,
		SUM(duration) OVER(PARTITION BY g.genre ROWS UNBOUNDED PREEEDING) running_total_duration,
		AVG(duration) OVER(PARTITION BY g.genre ROWS UNBOUNDED PREEEDING) moving_avg_duration
FROM	genre g INNER JOIN movie m
ON		g.movie_id = m.movie_id
ORDER BY g.genre;


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

WITH top_3_genres AS
(
	SELECT	genre
	FROM	genres
	GROUP BY genre
	ORDER BY COUNT(1) DESC
	LIMIT 3
)
SELECT	hgm.genre,
		hgm.year,
		hgm.movie_name,
		hgm.worldwide_gross_income,
		hgm.movie_rank
FROM	(
			SELECT	g.genre,
					m.year,
					m.title movie_name,
					m.worldwide_gross_income,
					RANK()OVER(PARTITION BY m.year ORDER BY m.worldwide_gross_income DESC) movie_rank
			FROM	genres g INNER JOIN movie m
			ON		g.movie_id = m.movie_id
					INNER JOIN top_3_genres t3g
			ON		t3g.genre = g.genre
		)hgm --highest-grossing movies 
WHERE	hgm.movie_rank <= 5
ORDER BY hgm.year, hgm.movie_rank;


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


WITH production_company_ranks AS
(
	SELECT		pcr.production_company,
				pcr.movie_count,
				ROW_NUMBER()OVER(ORDER BY pcr.movie_count DESC) prod_comp_rank
	FROM	(
				SELECT		m.production_company
				,			COUNT(m.id) movie_count
				FROM		movie m INNER JOIN ratings r
				ON			r.movie_id = m.id
				WHERE		POSITION(',' IN m.languages)>0
				AND			r.median_rating >= 8
				GROUP BY 	m.production_company
			) pcr -- production company ranks
)
SELECT	production_company,
		movie_count,
		prod_comp_rank
FROM	production_company_ranks
WHERE	prod_comp_rank <= 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_3_actress AS
(
	SELECT	t3a.actress_name,
			t3a.total_votes,
			t3a.movie_count
			t3a.actress_avg_rating,
			ROW_NUMBER()OVER(ORDER BY t3a.movie_count DESC) actress_rank
	FROM	(
				SELECT	n.name actress_name,
						SUM() total_votes,
						COUNT(1) movie_count
						AVG(r.avg_rating) actress_avg_rating
				FROM	ratings r INNER JOIN role_mapping rm
				ON		r.movie_id = rm.movie_id
						INNER JOIN names n
				ON		rm.name_id = n.id
						INNER JOIN genre g
				ON		g.movie_id = r.movie_id
				WHERE	r.avg_rating > 8
				AND		g.genre = 'drama'
				AND		rm.category = 'acress'
				GROUP BY n.name
			) t3a -- top 3 actress
)
SELECT	actress_name,
		total_votes,
		movie_count,
		actress_avg_rating,
		actress_rank
FROM	top_3_actress
WHERE	actress_rank <= 3;



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








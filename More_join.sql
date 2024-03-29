-- List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962;

-- Give year of 'Citizen Kane'.

SELECT yr FROM movie
  WHERE title = 'Citizen Kane';

/*
List all of the Star Trek movies, include the id, title and yr 
(all of these movies include the words Star Trek in the title). Order results by year.
*/

SELECT id, title , yr FROM movie
  WHERE title LIKE '%Star%Trek%'
  ORDER BY yr;

-- What id number does the actor 'Glenn Close' have?

SELECT id FROM actor
  WHERE name = 'Glenn Close';

-- What is the id of the film 'Casablanca'

SELECT id FROM movie
  WHERE title = 'Casablanca';

/*
Obtain the cast list for 'Casablanca'.
what is a cast list?
Use movieid=11768, (or whatever value you got from the previous question)
*/

SELECT name FROM actor JOIN casting
  ON actor.id = casting.actorid
  WHERE casting.movieid = (
    SELECT id FROM movie
      WHERE title = 'Casablanca'
  );

-- Obtain the cast list for the film 'Alien'

SELECT name FROM actor JOIN casting
  ON actor.id = casting.actorid
  WHERE casting.movieid = (
    SELECT id FROM movie
      WHERE title = 'Alien'
  );

-- List the films in which 'Harrison Ford' has appeared

SELECT title FROM movie JOIN casting
  ON movie.id = casting.movieid
  WHERE casting.actorid = (
    SELECT id FROM actor
      WHERE name = 'Harrison Ford'
  );

/*
List the films where 'Harrison Ford' has appeared - but not in the starring role. 
[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
*/

SELECT title FROM movie JOIN casting
  ON movie.id = casting.movieid
  WHERE casting.ord <> 1
  AND casting.actorid = (
    SELECT id FROM actor
      WHERE name = 'Harrison Ford'
  );

-- List the films together with the leading star for all 1962 films.

SELECT DISTINCT movie.title, actor.name
  FROM movie
  INNER JOIN casting ON movie.id = casting.movieid
  INNER JOIN actor   ON actor.id = casting.actorid
  WHERE movie.yr = 1962
  AND casting.ord = 1;

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.

SELECT title, name
  FROM movie JOIN casting ON (movieid = movie.id AND ord =1)
             JOIN actor   ON (actorid = actor.id)
  WHERE movie.id IN (SELECT movieid FROM casting
    WHERE actorid IN (
      SELECT id FROM actor
      WHERE name = 'Julie Andrews'
    ));


-- Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.

SELECT name FROM actor INNER JOIN casting
  ON actor.id = casting.actorid
  GROUP BY name
  HAVING SUM(CASE WHEN ord = 1 THEN 1 ELSE 0 END) >= 30;

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

SELECT DISTINCT title, COUNT(actorid) AS actors FROM movie
  INNER JOIN casting
  ON movie.id = casting.movieid
  WHERE yr = 1978
  GROUP BY title
  ORDER BY actors DESC, title;

-- List all the people who have worked with 'Art Garfunkel'.

SELECT name FROM actor
  INNER JOIN casting ON actor.id = casting.actorid
  INNER JOIN movie   ON movie.id = casting.movieid
  WHERE casting.movieid = ANY(
    SELECT casting.movieid
    FROM actor
    INNER JOIN casting ON actor.id = casting.actorid
    INNER JOIN movie   ON casting.movieid = movie.id
    WHERE actor.name = 'Art Garfunkel'
  )
  AND actor.name <> 'Art Garfunkel';

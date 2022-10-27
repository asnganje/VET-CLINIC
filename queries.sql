/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name like '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT * FROM animals WHERE neutered AND escape_attempts < 3; 

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT name, date_of_birth  FROM animals WHERE name='Agumon' or name='Pikachu';

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg >10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name not like 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 and 17.3; 

/*  Transactions  */

/* Stage 1 */
BEGIN;
UPDATE animals SET species='unspecified';
ROLLBACK;

/* Stage 2 */
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' where species = 'unspecified';
COMMIT;
/* Stage 3 DELETE */ 
BEGIN;
DELETE * FROM animals;
ROLLBACK;

/* Stage 4 */ 
BEGIN;
DELETE FROM animals WHERE date_of_birth >= '2022-01-01';
SAVEPOINT firstpoint;
UPDATE animals SET weight_kg = weight_kg*-1;
ROLLBACK TO firstpoint;

/* Stage 5 */ 
UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg<0;
COMMIT;

/* Queries */
-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals; 

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) FROM animals
GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG( escape_attempts ) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

--Using JOIN queries to answer the following questions

--What animals belong to Melody Pond?
SELECT full_name AS Owner, name AS Animal FROM animals A
JOIN owners O ON O.id = A.owners_id WHERE O.full_name = 'Melody Pond';

--List of all animals that are pokemon (their type is Pokemon).
SELECT A.name AS Pokemons FROM animals A  
JOIN species S ON  A.species_id = S.id WHERE S.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.

SELECT full_name AS Owner, name AS Animal FROM animals A  
RIGHT JOIN owners O ON O.id = A.owners_id ORDER BY owner, A.name;

-- How many animals are there per species?
SELECT S.name AS Specie, COUNT(*) AS Count FROM animals A  
JOIN species S ON A.species_id = S.id GROUP BY A.species_id, S.name;


--List all Digimon owned by Jennifer Orwell.
SELECT O.full_name AS Owner, S.name AS Specie, A.name AS Animal FROM animals A  
JOIN owners O ON O.id = A.owners_id JOIN species S ON A.species_id = S.id  
WHERE S.name = 'Digimon' AND O.full_name = 'Jennifer Orwell';

--List all animals owned by Dean Winchester that haven't tried to escape.
SELECT full_name AS Owner, A.escape_attempts FROM animals A  
JOIN owners O ON O.id = A.owners_id 
WHERE O.full_name = 'Dean Winchester' AND A.escape_attempts=0;

-- Who owns the most animals?
SELECT O.full_name AS Owner, COUNT(*) AS Count FROM animals A  
JOIN owners O ON O.id = A.owners_id GROUP BY O.full_name
ORDER BY Count DESC LIMIT 1;
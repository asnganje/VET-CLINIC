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
UPDATE animals SET species='pokemon' WHERE name NOT LIKE '%mon';
COMMIT;

/* Stage 3 DELETE */ 
BEGIN;
DELETE FROM animals;
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
SELECT COUNT( name ) FROM animals;
SELECT COUNT( * ) FROM animals WHERE escape_attempts = 0;
SELECT AVG( weight_kg ) FROM animals;
SELECT neutered, AVG( escape_attempts ) FROM animals GROUP BY neutered ORDER BY AVG DESC LIMIT 1;
SELECT species, MIN( weight_kg ), MAX( weight_kg ) FROM animals GROUP BY species;
SELECT species, AVG( escape_attempts ) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;
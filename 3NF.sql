-- Table drops to keep data clean.
DROP TABLE IF EXISTS ability_mapping;
DROP TABLE IF EXISTS abilities;
DROP TABLE IF EXISTS third_NF;
DROP TABLE IF EXISTS against_types;

-- Creates table to house all transitive relationships regarding types
-- Uses a composite primary key of type1 and type2 to determine the effectiveness of a
-- pokemon against a certain type.
CREATE TABLE against_types (
    type1 varchar(50) NOT NULL REFERENCES types,
    type2 varchar(50) REFERENCES types,
    against_bug REAL,
    against_dark REAL,
    against_dragon REAL,
    against_electric REAL,
    against_fairy REAL,
    against_fight REAL,
    against_fire REAL,
    against_flying REAL,
    against_ghost REAL,
    against_grass REAL,
    against_ground REAL,
    against_ice REAL,
    against_normal REAL,
    against_poison REAL,
    against_psychic REAL,
    against_rock REAL,
    against_steel REAL,
    against_water REAL,
    PRIMARY KEY (type1, type2)
);

-- Table in 3NF with transtive relations removed from the table.
CREATE TABLE third_NF (
    pokedex_number INT PRIMARY KEY,
    attack INT,
    base_total INT,
    capture_rate INT,
    classfication varchar(50),
    defense INT,
    experience_growth INT,
    height_m REAL,
    hp INT,
    name varchar(50),
    percentage_male REAL,
    sp_attack INT,
    sp_defense INT,
    speed INT,
    type1 varchar(50) NOT NULL REFERENCES types,
    type2 varchar(50) REFERENCES types,
    weight_kg REAL,
    generation INT,
    is_legendary INT
);

-- Following the rules of 2NF, Abilities table houses unique pokemon ability values.
-- This is to remove any duplicates in the table
CREATE TABLE abilities (
    ability varchar(50) NOT NULL PRIMARY KEY
);

-- Following the rules of 2NF, Ability mapping serves as the linking table between
-- pokemon_3NF and abilities.
CREATE TABLE ability_mapping (
    pokedex_number INT NOT NULL REFERENCES third_NF (pokedex_number),
    ability varchar(50) NOT NULL REFERENCES abilities (ability),
    PRIMARY KEY (pokedex_number, ability)
);

-- Inserts non-duplicate ability values into the abilities table
INSERT INTO abilities (ability)
SELECT DISTINCT n1.abilities
FROM first_NF n1;

-- Inserts all information regarding effectiveness on other types. This is sorted
-- and grouped by type1 and type2 combined. This follows the arguments required
-- for the composite key.
INSERT INTO against_types
SELECT type1, type2,
    MAX(against_bug) AS against_bug,
    MAX(against_dark) AS against_dark,
    MAX(against_dragon) AS against_dragon,
    MAX(against_electric) AS against_electric,
    MAX(against_fairy) AS against_fairy,
    MAX(against_fight) AS against_fight,
    MAX(against_fire) AS against_fire,
    MAX(against_flying) AS against_flying,
    MAX(against_ghost) AS against_ghost,
    MAX(against_grass) AS against_grass,
    MAX(against_ground) AS against_ground,
    MAX(against_ice) AS against_ice,
    MAX(against_normal) AS against_normal,
    MAX(against_poison) AS against_poison,
   
-- Inserts non-duplicate ability values into the abilities table
INSERT INTO abilities (ability)
SELECT DISTINCT n1.abilities
FROM first_NF n1;

-- Inserts all information regarding effectiveness on other types. 
INSERT INTO against_types
SELECT 
    type1,
    type2,
    MAX(against_bug),
    MAX(against_dark),
    MAX(against_dragon),
    MAX(against_electric),
    MAX(against_fairy),
    MAX(against_fight),
    MAX(against_fire),
    MAX(against_flying),
    MAX(against_ghost),
    MAX(against_grass),
    MAX(against_ground),
    MAX(against_ice),
    MAX(against_normal),
    MAX(against_poison),
    MAX(against_psychic),
    MAX(against_rock),
    MAX(against_steel),
    MAX(against_water)
FROM second_NF
GROUP BY type1, type2;

-- Inserts values that are non-transitive into third_NF
INSERT INTO third_NF
SELECT pokedex_number,
    attack,
    base_total,
    capture_rate,
    classfication,
    defense,
    experience_growth,
    height_m,
    hp,
    name,
    percentage_male,
    sp_attack,
    sp_defense,
    speed,
    type1,
    type2,
    weight_kg,
    generation,
    is_legendary
FROM second_NF;

-- Inserts atomic ability values into the mapping, alongside the pokedex_number of the pokemon that uses the ability
INSERT INTO ability_mapping (pokedex_number, ability)
SELECT n1.pokedex_number, n1.ability
FROM  first_NF n1;

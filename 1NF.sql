CREATE TABLE IF NOT EXISTS split_abilities AS 
SELECT  trim(value) AS split_value, *
FROM imported_pokemon_data,
		   json_each('["' || REPLACE(abilities,  ',' ,  '","') ||   '"]')
WHERE split_value <>  ' ';

UPDATE split_abilities
	  SET split_value = REPLACE(REPLACE(REPLACE(REPLACE(split_value, '[', ''), ']', ''), '''', ''), ' ', '');

  
  CREATE TABLE  IF NOT EXISTS first_NF AS
  SELECT split_value AS
  abilities, 
  against_bug, 
  against_dark, 
  against_dragon, 
  against_electric, 
  against_fairy, 
  against_fight, 
  against_fire, 
  against_flying, 
  against_ghost, 
  against_grass, 
  against_ground,
  against_ice,
  against_normal, 
  against_poison, 
  against_psychic, 
  against_rock, 
  against_steel, 
  against_water,
  attack, 
  base_egg_steps,
  base_happiness, 
  base_total,
  capture_rate,
  classfication, 
  defense,
  experience_growth, 
  height_m, 
  hp, 
  name, 
  percentage_male, 
  pokedex_number,
  sp_attack, 
  sp_defense, 
  speed, 
  type1,
  type2, 
  weight_kg,
  generation, 
  is_legendary
  FROM split_abilities;
  
  
  DROP TABLE split_abilities;
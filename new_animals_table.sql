CREATE TABLE age_upon_outcome (
    id integer PRIMARY KEY AUTOINCREMENT,
    ages varchar(100) NOT NULL
);

CREATE TABLE animal_types (
    id integer PRIMARY KEY AUTOINCREMENT,
    animal_type varchar(100) NOT NULL
);

CREATE TABLE breeds (
    id integer PRIMARY KEY AUTOINCREMENT,
    breed varchar(100) NOT NULL
);

CREATE TABLE colors (
    id integer PRIMARY KEY AUTOINCREMENT,
    color varchar(100)
);

CREATE TABLE subtypes (
    id integer PRIMARY KEY AUTOINCREMENT,
    subtype varchar(100) NOT NULL
);

CREATE TABLE types (
    id integer PRIMARY KEY AUTOINCREMENT,
    type varchar(100) NOT NULL
);

CREATE TABLE years (
    id integer PRIMARY KEY AUTOINCREMENT,
    year integer NOT NULL
);

CREATE TABLE outcome (
    id integer PRIMARY KEY AUTOINCREMENT,
    outcome_subtype_id integer,
    outcome_type_id integer,
    outcome_month integer,
    outcome_year_id integer,
    FOREIGN KEY (outcome_subtype_id) REFERENCES subtypes(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (outcome_type_id) REFERENCES types(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (outcome_year_id) REFERENCES years(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE animals_table (
    id integer PRIMARY KEY AUTOINCREMENT,
    age_upon_outcome_id integer,
    animal_id text,
    animal_type_id integer,
    name text,
    breed_id integer,
    date_of_birth text,
    outcome_id integer,
    FOREIGN KEY (age_upon_outcome_id) REFERENCES age_upon_outcome(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (animal_type_id) REFERENCES animal_types(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (breed_id) REFERENCES breeds(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (outcome_id) REFERENCES outcome(id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE colors_animal (
    animal_id integer,
    color_id integer,
    FOREIGN KEY (animal_id) REFERENCES animals_table(id),
    FOREIGN KEY (color_id) REFERENCES colors(id)
);



INSERT INTO age_upon_outcome (ages)
SELECT DISTINCT age_upon_outcome
FROM animals
ORDER BY age_upon_outcome;

INSERT INTO animal_types (animal_type)
SELECT DISTINCT animal_type
FROM animals
ORDER BY animal_type;

INSERT INTO breeds (breed)
SELECT DISTINCT breed
FROM animals
ORDER BY breed;

INSERT INTO subtypes (subtype)
SELECT DISTINCT outcome_subtype
FROM animals
WHERE outcome_subtype NOT NULL
ORDER BY outcome_subtype;

INSERT INTO types (type)
SELECT DISTINCT outcome_type
FROM animals
WHERE outcome_type NOT NULL
ORDER BY outcome_type;

INSERT INTO years (year)
SELECT DISTINCT outcome_year
FROM animals
ORDER BY outcome_year;

INSERT OR IGNORE INTO colors (color)
SELECT DISTINCT color1
FROM animals
WHERE color1 NOT NULL
UNION
SELECT DISTINCT color2
FROM animals
WHERE color2 NOT NULL;

INSERT OR IGNORE INTO colors_animal (color_id, animal_id)
SELECT DISTINCT color1 , animals."index"
FROM animals
WHERE color1 NOT NULL
UNION
SELECT DISTINCT color2, animals."index"
FROM animals
WHERE color2 NOT NULL
ORDER BY "index";

SELECT *
FROM colors_animal
JOIN animals_table ON colors_animal.animal_id = animals_table.id
JOIN colors ON colors_animal.color_id = colors.id;

INSERT INTO outcome (id, outcome_subtype_id, outcome_type_id, outcome_month, outcome_year_id)
SELECT animals."index", subtypes.id, types.id, animals.outcome_month, years.id
FROM animals
LEFT JOIN subtypes ON animals.outcome_subtype = subtypes.subtype
LEFT JOIN types ON animals.outcome_type = types.type
LEFT JOIN years ON animals.outcome_year = years.year;

INSERT INTO animals_table (id, age_upon_outcome_id, animal_id, animal_type_id, name, breed_id, date_of_birth, outcome_id)
SELECT animals."index", age_upon_outcome.id, animals.animal_id, animal_types.id, animals.name, breeds.id, animals.date_of_birth, outcome.id
FROM animals
LEFT JOIN age_upon_outcome ON animals.age_upon_outcome = age_upon_outcome.ages
LEFT JOIN animal_types ON animals.animal_type = animal_types.animal_type
LEFT JOIN breeds ON animals.breed = breeds.breed
LEFT JOIN outcome ON animals."index" = outcome.id;

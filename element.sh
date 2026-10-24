#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  BASE_QUERY="SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
              FROM elements e
              JOIN properties p USING(atomic_number)
              JOIN types t USING(type_id)"

  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "$BASE_QUERY WHERE e.atomic_number = $1")
  else
    ELEMENT=$($PSQL "$BASE_QUERY WHERE e.symbol = '$1' OR e.name = '$1'")
  fi

  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while IFS="|" read NUM NAME SYMBOL TYPE MASS MELT BOIL
    do
      echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi

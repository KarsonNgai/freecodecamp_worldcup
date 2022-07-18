
#! /bin/bash
 
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
 
# Do not change code above this line. Use the PSQL variable above to query your database.
 
echo $($PSQL "TRUNCATE teams, games")
 
 
echo '========'
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then 
    #table teams
    check_w=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
    if [[ -z $check_w ]]
    then
      ADD_w=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')") 
    fi
    
    check_o=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $check_o ]]
    then
      ADD_o=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')") 
    fi
 
    get_w=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    get_o=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    ADD=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $get_w, $get_o, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done
 
echo '================'


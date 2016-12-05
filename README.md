csc341-project
==============

For Oracle 12c Database configured and  made for CSC341.

Using
-----

use the Makefile to populate the database with all the test data
you can then run the ./sql/gym-questions.sql to answer the defined business questions

    make
    sqlplus team00/team00@127.0.0.1/Team < ./sql/gym-questions.sql > results.txt

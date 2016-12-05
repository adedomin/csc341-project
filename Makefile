SQL=sqlplus
CRED=team00/team00@127.0.0.1/Team

all: drop create build_compact_insert testdata

drop:
	$(SQL) $(CRED) < ./sql/gym-drop-all.sql

create:
	$(SQL) $(CRED) < ./sql/gym-create.sql

testdata:
	$(SQL) $(CRED) < ./sql/gym-inserts.sql

# for submission
build_compact_insert:
	cat ./sql/gym-mock-data/gym-person.sql > ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-person-discrim.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-employee.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-customer.sql >> ./sql/gym-inserts.sql

	cat ./sql/gym-mock-data/gym-trainer.sql >> ./sql/gym-inserts.sql

	cat ./sql/gym-mock-data/gym-class.sql >> ./sql/gym-inserts.sql

	cat ./sql/gym-mock-data/gym-fees.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-customer-fees.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-equipment.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-machine-equip.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-weight-equip.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-maintenance.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-sessions.sql >> ./sql/gym-inserts.sql
	cat ./sql/gym-mock-data/gym-extra.sql >> ./sql/gym-inserts.sql

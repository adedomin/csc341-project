SQL=sqlplus
CRED=team00/team00@127.0.0.1/Team

all: drop create testdata

drop:
	$(SQL) $(CRED) < ./sql/gym-drop-all.sql

create:
	$(SQL) $(CRED) < ./sql/gym-create.sql

testdata:
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-person.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-person-discrim.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-employee.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-customer.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-trainer.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-class.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-fees.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-customer-fees.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-equipment.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-machine-equip.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-weight-equip.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-maintenance.sql
	$(SQL) $(CRED) < ./sql/gym-mock-data/gym-sessions.sql

## Setup OpenJensen database

To create and load data, run files in /var/lib/postgresql
which is the $HOME for user 'postgres'.

Run these commands as as user *postgres*.

### Create database and user *jensen*

```
# su - postgres
$ psql -f pg_openjensen_create_database.sql
$ psql -l
```

### Create tables and insert initial data

```
psql -d openjensen -U jensen -f pg_openjensen_create_all_tables.sql
psql -d openjensen -U jensen -f pg_openjensen_insert_all_data.sql
```

Use *psql* to list created tables:

```
psql -d openjensen -U jensen
\d
```

Look at details or view content:

```
\d[tablename]
select * from <tablename> ;
```

Quit *psql*:

```
\q
```

### Drop all tables and data with it

```
psql -d openjensen -U jensen -f pg_openjensen_drop_all.sql
```

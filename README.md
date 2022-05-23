# samba-4_13_13-block

Current status of this block.  I use it in one fleet and works pretty well for my purposes.

The block assumes that the shared directory to share is named "/data".

Env variables:
    * SAMBA_USER
    * SAMBA_PASSWORD

Server configuration:

The block copies all the files from a shared/persistent directory named /samba_shared/conf to the postgresql configuration directory.
If you want to override any of the defaults, put the entire configuration file in the shared directory.  To automate this,
have your own container copy the configuration file to the shared directory and have postgresql DEPEND on that
container in the dockercompose.yml file.  For example:

```
  mycontainer: # copies config files to /activemq_conf
    volumes:
      - 'resin-data:/postgresql_conf'

  samba:
    image: bh.cr/g_john_rodley1/samba-4_13_13-block
    volumes:
      - 'resin-data:/data'
    depends-on:
      - mycontainer  # don't start samba until mycontainer has copied the right files into /postgresql_conf
```

The configuration file of most interest are smb.conf.  The repo contains
a sample.

postgresql.conf:

* data_directory - if you leave the default data directory which points to containerized storage then your database will disappear on every deployment.

pg_hba.conf:

You will likely want to add lines allowing both your local network and other containers to access
the database.  See the sample.  Example:
```
host    all             all             192.168.21.237/32            md5
host    all             all             172.0.0.0/8            md5
```

Database initialization and migration:

If a file named "init_db.sh" exists in the shared directory /postgresql_shared/bin it will be
executed on startup AND THEN DELETED so that it will only run once.

This block includes the migrate tool from https://github.com/golang-migrate.

The migration tool will be run in the directory /postgresql_shared/migrations to get
the database up to the latest migration.

Environment variables:

* POSTGRESQL_DBNAME   set this to the name of the database we need to run migrations against
* POSTGRESQL_HOST   set this to the name of the container that's running postgres, typically "database"
* POSTGRESQL_PASSWORD   set this to the password for the postgres user

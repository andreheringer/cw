# Database Reliability Engineer Test - Solution

This repository contains a solution for the Database Reliability Engineer test.
It sets up two PostgreSQL containers (`pg_master` and `pg_replica`) using **Docker Compose**
and configures **logical replication** from `pg_master` to `pg_replica`.

Some container parameters, mainly environment variables, are explicitly let as raw text in the .env file.
These parameters are typically not even commited to version control I did it here for demonstration purposes.
In a production environment, it's recommended to use a secret management solution to securely handle sensitive configurations.

## Setup Instructions
### 1. Prerequisites
Ensure you have the following installed on your system:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Python](https://www.python.org/downloads/)
- **(Optional)** `psycopg2`, if you want to run the test scripts:
  ```sh
  pip install psycopg2
  ```

### 2. Clone the Repository
```sh
 git clone <repository_url>
 cd <repository_directory>
```

### 3. Build the Docker Image
Before starting the containers, build the required Docker image using the `Dockerfile` in the repository:
```sh
docker build -t cw_dbre:latest .
```
This will create an image named `cw_dbre:latest`, which is used by Docker Compose.

### 4. Start the Containers
Run the following command to spin up the PostgreSQL instances:
```sh
docker compose up -d
```
This will create two PostgreSQL containers:
- `pg_master`: Acts as the primary database (publisher)
- `pg_replica`: Acts as the replica (subscriber)

### 5. Verify Database Setup
To connect to `pg_master`, run:
```sh
docker exec -it pg_master psql -U postgres -d testDB
```
To connect to `pg_replica`, run:
```sh
docker exec -it pg_replica psql -U postgres -d testDB
```

### 6. Inserting Sample Data
If you would like to insert sample data into the database, you can run the `main.py` script:
```sh
python main.py
```
It will insert 5 sample rows into the orders table of the master database, replication will then replicate them into the replica database.


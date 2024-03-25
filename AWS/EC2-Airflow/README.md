### Run Airflow on AWS EC2

Here we will show how to setup and run Airflow on a AWS EC2.

1. Go to AWS and search EC2 -> Click on `Launch an instance`
   - Name the instance, for example `ec-airflow`
   - Choose `Ubuntu` image
   - Under `Instance type` choose `t2.small` as we need minimum 2GB Memory for PosgtreSQL
   - `Create new key pair` and finish with clicking on `Launch instance` button.
2. After the instance is ready go to `instances` select the instance and click on the `Connect`. This will open the the  Bash.
3. In the Bash do next:
   - `sudo apt update`
   - `sudo apt install python3-pip` -> After you get a message: Select all and click OK.
   - `sudo apt install sqlite3` -> we need to install it as when we use airflow for the first time we need sqlite3.
   - `sudo apt install python3.10-venv`
   - `python3 -m venv venv`
   - `source venv/bin/activate`
   - `sudo apt-get install libpq-dev`
   - `pip install "apache-airflow[postgres]==2.5.0" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.5.0/constraints-3.7.txt"`
   - `airflow db init`
   - `sudo apt-get install postgresql postgresql-contrib`
   - `sudo -i -u postgres`
   - `psql`
   - `CREATE DATABASE airflow;`
   - `CREATE USER airflow WITH PASSWORD 'airflow';`
   - `GRANT ALL PRIVILEGES ON DATABASE airflow TO airflow;`
   - `exit` -> exit psql
   - `cd airflow`
   - `sed -i 's#sqlite:////home/ubuntu/airflow/airflow.db#postgresql+psycopg2://airflow:airflow@localhost/airflow#g' airflow.cfg` -> this will configure Airflow to connect to PostgreSQL
   - `sed -i 's#SequentialExecutor#LocalExecutor#g' airflow.cfg` -> this will change executor so we can run multiple tasks at the same time.
   - `airflow db init`
   - `airflow users create -u airflow -f airflow -l airflow -r Admin -e airflow@gmail.com` -> this will create Airflow user.
   - Set any password but we'll set it as `airflow`.
4. Before we can run Airflow we need to open port `8080`
   - Go to `Instances` -> Click on your instance -> Under `Security` click on `Security groups` -> `Edit Inbound rules` -> `Add rule` -> `Custom TCP` set port to `8080` -> select Source `Anywhere-IPv4` -> `Save rules`
5. Go back to the Bash:
   - `airflow webserver &` -> & will run server in the background
   - `airflow scheduler`
6. Go to the EC2 Dashboard -> click on your instance -> Copy `Public IPv4 DNS` -> open new tab -> past it and `:8080`

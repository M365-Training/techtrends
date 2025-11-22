# TechTreds Web Application

This is a Flask application that lists the latest articles within the cloud-native ecosystem.

## Remarks from the Author

I installed Rancher Desktop by SUSE and used my own Kubernetes cluster (k3s) on Ubuntu.

The actual documentation for the steps has been added to the `README.md`-files in the respective folders.

## Run 

To run this application there are 2 steps required:

1. Initialize the database by using the `python init_db.py` command. This will create or overwrite the `database.db` file that is used by the web application.
2.  Run the TechTrends application by using the `python app.py` command. The application is running on port `3111` and you can access it by querying the `http://127.0.0.1:3111/` endpoint.

### Complete initial setup including venv and a quick test

```bash
# Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate

# Install python requirements
pip install -r requirements.txt

# Setup database (sqlite-file database.db)
python init_db.py

# Run and test application
python app.py
curl http://192.168.178.150:3111

# Deaktivate current environment
# deactivate
```
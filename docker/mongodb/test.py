from pymongo import MongoClient

try:
    # Connect to MongoDB server
    client = MongoClient('mongodb://localhost:27017/')

    # List the databases
    databases = client.list_database_names()

    # Print the list of databases
    print("Connected to MongoDB server. Available databases:")
    for db in databases:
        print(f"- {db}")

except Exception as e:
    print(f"An error occurred: {e}")

import os

print("Hello from generate.py!")

print("POSTGRES_USER:", os.getenv("POSTGRES_USER"))
print("POSTGRES_PASSWORD:", os.getenv("POSTGRES_PASSWORD"))
print("SUPERSET_ADMIN:", os.getenv("SUPERSET_ADMIN"))
print("SUPERSET_PASSWORD:", os.getenv("SUPERSET_PASSWORD"))
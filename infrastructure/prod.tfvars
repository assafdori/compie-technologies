environment = "prod"

instance_type = "t2.large"  # Production requires more resources... usually.
instance_count = 4           # ...and more instances.

dynamodb_table_name = "prod-dynamodb-table"

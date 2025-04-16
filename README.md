https://docs.aws.amazon.com/dms/latest/sbs/chap-rdsoracle2postgresql.steps.html

https://github.com/githubard/aws_oracle_to_postgresrds_migration

For on-premise oracle database to aws rds postgresql migration , AWS Direct Connect OR VPN connection is necessary.
    
To simulate on-premise oracle database , the oracle database 19c is installed on EC2 server RHEL 8 server.
    
To allow access from local PC , the EC2 instance is publicly accessible with security group with inbound rule 
allowing ssh port 22 & oracle port 1521 to MY IP address ( local pc public IP ).

Target rds postgresql database instance is created in aws with public access. 

In local PC , install and use AWS SCT (Schema Conversion Tool ) to connect to source oracle and target rds postgres to 
create sql script for creating database structures ( tables,views,functions,stored procs,etc) in postgres.

Use AWS DMS replication instance to migrate data from oracle to postgres.

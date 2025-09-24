#!/bin/bash
# Install Python 3
yum update -y
yum install -y python3

# Copy the Python script into a specific directory
# The `cat <<EOF` block reads the content of app.py and writes it to a file on the EC2 instance
cat <<EOF > /home/ubuntu/app.py
${file("/workspaces/terraform-zero-to-hero/Test/app.py")}
EOF

chown ubuntu:ubuntu /home/ubuntu/app.py
chmod 777 /home/ubuntu/app.py
# Run the Python script
python3 /home/ubuntu/app.py

# Ensure correct permissions

# chown ec2-user:ec2-user /home/ec2-user/output.txt
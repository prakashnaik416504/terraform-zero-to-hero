provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "aws_login"
  monitoring    = true

  # Inject the shell script into user_data
  user_data = file("/workspaces/terraform-zero-to-hero/Test/install.sh")
}


# Create an SNS Topic
resource "aws_sns_topic" "email_notifications_topic" {
  name = "my-email-notifications-topic" # Choose a descriptive name for your topic
}

# Subscribe an email address to the SNS Topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.email_notifications_topic.arn
  protocol  = "email"
  endpoint  = var.sns_endpoint_email # Replace with the email address to receive notifications
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "ec2-cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 # 1 minutes
  statistic           = "Average"
  threshold           = 80 # Trigger when CPU utilization exceeds 80%
  alarm_description   = "This alarm monitors EC2 CPU utilization."

  dimensions = {
    InstanceId = aws_instance.ec2_instance.id
  }

  alarm_actions = [aws_sns_topic.email_notifications_topic.arn]
  ok_actions    = [aws_sns_topic.email_notifications_topic.arn]
}


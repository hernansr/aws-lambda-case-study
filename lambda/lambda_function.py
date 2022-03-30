import boto3

# Create AWS clients
ec2session = boto3.client('ec2')
cw = boto3.client('cloudwatch')

# Retrives instance id from cloudwatch event
def get_instance_id(event):
    try:
        return event['detail']['instance-id']
    except KeyError as err:
        return False

def lambda_handler(event, context):

    session = boto3.session.Session()
    ec2session = session.client('ec2')
    instanceid = get_instance_id(event)

    # Create Metric "CPU Utilization Greater than 95% for 15+ Minutes"
    cw.put_metric_alarm(
    AlarmName="%s High CPU Utilization Warning" % (instanceid),
    AlarmDescription='CPU Utilization Greater than 90% for 15+ Minutes',
    ActionsEnabled=True,
    AlarmActions=['arn:aws:sns:us-east-1:(account):topic'],
    OKActions=['arn:aws:sns:us-east-1:(account):topic'],
    MetricName='CPUUtilization',
    Namespace='AWS/EC2',
    Statistic='Average',
    Dimensions=[
        {
            'Name': 'InstanceId',
            'Value': instanceid
        },
    ],
    Period=1500,
    EvaluationPeriods=5,
    DatapointsToAlarm=3,
    Threshold=90.0,
    ComparisonOperator='GreaterThanOrEqualToThreshold'
)
import json
import boto3
import logging

#import paramiko

#Simple Logger 
logger = logging.getLogger()
logger.setLevel(logging.INFO)



def lambda_handler(event, context):

    #define EC2 connection
    ec2 = boto3.resource('ec2', region_name='ca-central-1')
    
    #instance_id = 'i-0e2d1fe22db80b4fb'
    instance_id = 'i-0e2d1fe22db80b4fb'
    instance_id = 'i-0e2d1fe22db80b4fb'
    instance = ec2.Instance(instance_id)

    if instance.state['Name']=='stopped':
        instance.start()
    
    #k = paramiko.RSAKey.from_private_key_file("lambda_id_rsa")    
    #ssh = paramiko.SSHClient()
    #ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    #host = event['IP']
    #print("Connecting to " + host)
    #ssh.connect(hostname = host, username = "ubuntu", pkey=k)
    
    commands = [
        "cd /home/ubuntu/github/OpenDRR/model-factory"
        "git pull https://github.com/OpenDRR/model-factory.git"
        "cd /home/ubuntu/github/OpenDRR/OpenDRR/model-factory/scripts/"
        "python3 DSRA_outputs2postgres_lfs.py --dsraModelDir=https://github.com/OpenDRR/openquake-models/tree/master/deterministic/outputs --columnsINI=DSRA_outputs2postgres.ini"
        ]
    
    boto3.client('ssm', region_name='ca-central-1').send_command(
        InstanceIds=[instance_id],
        DocumentName='AWS-RunShellScript',
        Parameters={'commands': commands},
        Comment='Test Command'
        )

    return instance.state['Name']
    
    
    
        #return {
    #    'statusCode': 200,
    #    'body': json.dumps('Hello from Lambda!')
    #}
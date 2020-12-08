import json
import boto3
from datetime import datetime
import time

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    print('Event {}'.format(json.dumps(event)))

    s3_raw = event['stageVariables']['raw_bucket']
    s3_trans = event['stageVariables']['trans_bucket']
    timestamp = int(time.mktime(datetime.now().timetuple()))
    payload = json.loads(event['body'])['ecpp_data']
    
    nhi = payload['nhi']
    sessionid = payload['sessionId']
    
    raw_name = '{0}_{1}_{2}.json'.format(nhi, sessionid, timestamp)
    trans_name = '{0}_{1}.json'.format(nhi, sessionid)
    
    s3.put_object(Bucket=s3_raw, Body = json.dumps(payload), Key=raw_name)
    s3.put_object(Bucket=s3_trans, Body = json.dumps(payload), Key=trans_name)
 
    return {
        'statusCode': 200,
        'body': 'Record created successfully'
    }

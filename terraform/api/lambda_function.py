import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

TABLE_NAME = os.environ.get('TABLE_NAME', 'VisitorCount')
TOPIC_ARN = os.environ.get('TOPIC_ARN')
MY_IP = os.environ.get('MY_IP')

def lambda_handler(event, context):
    table = dynamodb.Table(TABLE_NAME)

    caller_ip = event.get('requestContext', {}).get('http', {}).get('sourceIp', 'Unknown')

    try:
        response = table.update_item(
            Key={'id': 'views'},
            UpdateExpression='ADD visits :inc',
            ExpressionAttributeValues={':inc': 1},
            ReturnValues='UPDATED_NEW'
        )
        current_views = int(response['Attributes']['visits'])
    except Exception as e:
        print(f"Error updating DynamoDB: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Could not update visitor count'})
        }
        
    if caller_ip != MY_IP:
        try:
            sns.publish(
                TopicArn=TOPIC_ARN,
                Subject='New Visitor Alert',
                Message=f"New visitor from IP: {caller_ip}. Total visits: {current_views}"
            )
        except Exception as e:
            print(f"Error publishing to SNS: {e}")
            
    return {
        'statusCode': 200,
        'body': json.dumps({'visits': current_views})
    }
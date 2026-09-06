import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    for record in event.get('Records', []):
        filename = record['s3']['object']['key']
        logger.info(f"Image received: {filename}")
    
    return {
        'statusCode': 200,
        'body': 'Success'
    }
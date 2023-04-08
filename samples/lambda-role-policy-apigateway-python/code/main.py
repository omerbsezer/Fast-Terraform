def lambda_handler(event, context):
   content = """
   <html>
   <h1> Hello Website running on Lambda! Deployed via Terraform </h1>
   </html>
   """
   response ={
     "statusCode": 200,
     "body": content,
     "headers": {"Content-Type": "text/html",}, 
   }
   return response
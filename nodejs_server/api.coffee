# /*
#  *  NimbusBase  role_allocate api 
#  *  
# **/
 
 
AWS = require('aws-sdk') 


# set  region
# AWS.config.update({region: 'us-west-2'});
db = new AWS.DynamoDB({region: 'us-west-2'})

addRole = (app_name,email,role)->
  params ={  
    "TableName":  "NimbusAppControl",
    "Item" : {
      "email":{"S": email},
      "app": {"S":app_name},
      "role":{"S":role}
      }
  }
  db.putItem(params,(err, data)-> 
    if (err)
      console.log(err)
    else
      console.log(JSON.stringify(data))
  )


# addRole("nimbusTest2","waiter@nimbus.com","reader")




getRole = (app_name,email)->
  params ={ 
    "AttributesToGet": [
       "email", "app","role"
    ],
    "Limit": 100,
    "ReturnConsumedCapacity": "TOTAL",
    "ScanFilter":{
          "email" :{  
              "AttributeValueList": [{"S": email}],
              "ComparisonOperator": "EQ"
          },
          "app":{  
              "AttributeValueList": [{"S": app_name}],
              "ComparisonOperator": "EQ"
          }
    }, 
    "TableName": "NimbusAppControl"
  }
  db.scan(params,(err, data)-> 
    if (err)
      console.log(err)
    else
      console.log(JSON.stringify(data))
  )

#getRole("nimbusTest21","waiter@nimbus.com")

  
# # IAM   
# iam = new AWS.IAM();
  
# getRole = (name)->
#   params = { 
#     RoleName: name
#   }
#   iam.getRole(params,(err, data)-> 
#     if (err)
#       console.log(err)
#     else
#       # console.log(JSON.stringify(data))
#       role_arn = data.Role.Arn
#       role_name= data.Role.RoleName
#       console.log(role_name + ":" + role_arn)
#   )






###################################
http = require('http')
url = require('url')


# http.createServer((request,response)->
#   request.setEncoding("utf8")
#   pathname = url.parse(request.url).pathname
#   query =  url.parse(request.url).query
#   console.log('Request for ' + pathname + ' received.' + query)

#   switch pathname
#     when "/a"  
#       response.writeHead(200, {'Content-Type': 'text/plain'}) 
#       response.end('Hello a\n') 
#     when "/b" 
#       response.writeHead(200, {'Content-Type': 'text/plain'}) 
#       response.end('Hello b\n') 
#     else
#       response.writeHead(200, {'Content-Type': 'text/plain'}) 
#       response.end('Hello bye\n') 

# ).listen(8000)


 


























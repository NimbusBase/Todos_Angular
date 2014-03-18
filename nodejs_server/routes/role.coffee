
# /*
#  * GET users listing.
#  */

AWS = require('aws-sdk')

exports.db = new AWS.DynamoDB({region: 'us-west-2'})
exports.iam = new AWS.IAM()

exports.addUser = (req, res)->
  # /adduser?app=appname&email=waiter@nimbusbase.com&role=admin
  app_name = req.query.app
  email = req.query.email
  role = req.query.role

  res.contentType('json');


  params ={  
    "TableName":  "NimbusAppControl",
    "Item" : {
      "email":{"S": email},
      "app": {"S":app_name},
      "role":{"S":role}
      }
  } 

  exports.db.putItem(params,(err, data)-> 
    if (err)
      console.log(err)
      res.send(JSON.stringify({status:"error", action:"addUser", info:err}))
    else
      console.log(JSON.stringify(data))
      res.send(JSON.stringify({ status:"success",action:"addUser"}))
  )
  
  # res.send("add user  here3：" + req.query.username)

exports.deleteUser = (req, res)->
  # /adduser?app=appname&email=waiter@nimbusbase.com&role=admin
  app_name = req.query.app
  email = req.query.email  
  res.contentType('json'); 

  param =  {
        "TableName": "NimbusAppControl",
        "Key": {
            "email" : { 
                  "S": email
              }, 
              "app" : { 
                  "S": app_name
              }, 
        },
        "Expected": {
            "email": {
                "Value": {
                    "S": email
                },
                "Exists": true
            },
            "app": {
                "Value": {
                    "S": app_name
                },
                "Exists": true
            }
        },
        "ReturnValues": "ALL_OLD"
    }
    exports.db.deleteItem(param, (err, data)-> 
      if (err)
        console.log(err)
        res.send(JSON.stringify({status:"error", action:"delete",info:err}))
      else
        console.log(JSON.stringify(data))
        res.send(JSON.stringify({ status:"success",action:"delete" }))
    )
  
  # res.send("add user  here3：" + req.query.username)

exports.getRole = (req, res)->
  # /getRole?app=appname&email=waiter@nimbusbase.com
  app_name = req.query.app
  email = req.query.email

  res.contentType('json');
  
  res.header('Access-Control-Allow-Origin', req.headers.origin)
  res.header('Access-Control-Allow-Methods', req.headers['access-control-request-method'])
  res.header('Access-Control-Allow-Headers', req.headers['access-control-request-headers'])
  res.header('Access-Control-Max-Age', 60 * 60 * 24 * 365)

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

  exports.db.scan(params,(err, data)-> 
    if (err)
      console.log(err)
      res.send(JSON.stringify({status:"error", info:err}))
    else
      console.log(JSON.stringify(data))
      if data.Count > 0
        x = data.Items[0] 
        r = x.role.S  
      else
        r = "reader"  
      params = { 
        RoleName: r
      }

      exports.iam.getRole(params,(err, data)-> 
        if (err)
          res.send(JSON.stringify({status:"error", info:err}))
        else
          # console.log(JSON.stringify(data))
          role_arn = data.Role.Arn
          role_name= data.Role.RoleName
          res.send(JSON.stringify({status:"success", "arn":role_arn,"name":role_name}))
      )
  ) 




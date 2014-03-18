# /*
#  *  NimbusBase  role_control service
#  *  
# **/
 
 
AWS = require('aws-sdk')
uuid = require('node-uuid')
child_process = require('child_process')
exec = child_process.exec

exec_call = (err, stdout, stderr) ->
	if(err)
		console.log("got error  in child_process:" + err)
	else
		console.log(stdout) if stdout?
		console.log(stderr) if stderr?
 
  

# set  region
# AWS.config.update({region: 'us-west-2'});
db = new AWS.DynamoDB({region: 'us-west-2'})
 




# IAM   
iam = new AWS.IAM();


# login  AssumeRolePolicyDocument
policy_login =  """
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Federated": "www.amazon.com"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",

        "Condition": {
          "StringEquals": {
            "www.amazon.com:app_id": "amzn1.application.e133066ca0db4161ba51a41464636bb1"
          }
        }
      },
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Federated": "accounts.google.com"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "accounts.google.com:aud": "195693500289.apps.googleusercontent.com"
          }
        }
      },
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Federated": "graph.facebook.com"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "graph.facebook.com:app_id": "1453289431565183"
          }
        }
      }
    ]
  }
"""






 

createAdminRole = ()-> 
  params = {
    Path: "/",
    RoleName: "admin"
    AssumeRolePolicyDocument: policy_login
  }
   
  iam.createRole(params,(err, data)-> 
    if (err)
      console.log(err)
    else
      console.log(JSON.stringify(data))
      adminRole()
  )



#admin  policy
adminRole = ()->
  policy_admin = """
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  """


  params = { 
    RoleName: "admin",
    PolicyName:"admin",
    PolicyDocument: policy_admin
  };  
  iam.putRolePolicy(params,(err, data)-> 
    if (err)
      console.log(err)
    else
      console.log(JSON.stringify(data))
  )



createReaderRole = ()-> 
  params = {
    Path: "/",
    RoleName: "reader"
    AssumeRolePolicyDocument: policy_login
  }
   
  iam.createRole(params,(err, data)-> 
    if (err)
      console.log(err)
    else
      console.log(JSON.stringify(data))
      readerRole()
  )

# # read only  policy
readerRole=()->
  policy_reader = """
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  """

  params = { 
    RoleName: "reader",
    PolicyName:"reader",
    PolicyDocument: policy_reader
  }
  iam.putRolePolicy(params,(err, data)-> 
    if (err)
      console.log(err)
    else
      console.log(JSON.stringify(data))
  )




createWriterRole = ()-> 
  params = {
    Path: "/",
    RoleName: "writer"
    AssumeRolePolicyDocument: policy_login
  }
   
  iam.createRole(params,(err, data)-> 
    if (err)
      console.log(err)
    else
      console.log(JSON.stringify(data))
      writerRole()
  )

#wirte only  oneself  policy 
# writer  policy 
writerRole = ()->
  policy_writer = """
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:BatchGetItem",
          "dynamodb:ListTables",
          "dynamodb:UpdateTable"
        ],
        "Effect": "Allow",
        "Resource": "*"
      },
      {
        "Action": [
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ],
        "Effect": "Allow",
        "Resource": "*",
        "Condition": {
          "ForAllValues:StringEquals": {
            "dynamodb:LeadingKeys": [
              "${www.amazon.com:user_id}",
              "${graph.facebook.com:id}",
              "${accounts.google.com:sub}"
            ]
          }
        }
      }
    ]
  }
  """


  params = { 
    RoleName: "writer",
    PolicyName:"writer",
    PolicyDocument: policy_writer
  }
  iam.putRolePolicy(params,(err, data)-> 
    if (err)
      console.log(err)
    else
      console.log(JSON.stringify(data))
  )

  
 
 
# listRole()
createAdminRole()
createReaderRole()
createWriterRole()






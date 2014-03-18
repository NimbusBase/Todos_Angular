// Generated by CoffeeScript 1.6.3
var AWS, addRole, db, getRole, http, url;

AWS = require('aws-sdk');

db = new AWS.DynamoDB({
  region: 'us-west-2'
});

addRole = function(app_name, email, role) {
  var params;
  params = {
    "TableName": "NimbusAppControl",
    "Item": {
      "email": {
        "S": email
      },
      "app": {
        "S": app_name
      },
      "role": {
        "S": role
      }
    }
  };
  return db.putItem(params, function(err, data) {
    if (err) {
      return console.log(err);
    } else {
      return console.log(JSON.stringify(data));
    }
  });
};

getRole = function(app_name, email) {
  var params;
  params = {
    "AttributesToGet": ["email", "app", "role"],
    "Limit": 100,
    "ReturnConsumedCapacity": "TOTAL",
    "ScanFilter": {
      "email": {
        "AttributeValueList": [
          {
            "S": email
          }
        ],
        "ComparisonOperator": "EQ"
      },
      "app": {
        "AttributeValueList": [
          {
            "S": app_name
          }
        ],
        "ComparisonOperator": "EQ"
      }
    },
    "TableName": "NimbusAppControl"
  };
  return db.scan(params, function(err, data) {
    if (err) {
      return console.log(err);
    } else {
      return console.log(JSON.stringify(data));
    }
  });
};

http = require('http');

url = require('url');
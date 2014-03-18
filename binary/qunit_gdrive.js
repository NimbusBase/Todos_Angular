// Generated by CoffeeScript 1.6.3
module("GDrive Binary Test");

test("Auto Login(8s)", function() {
  stop();
  return setTimeout(function() {
    if (!Nimbus.Auth.authorized()) {
      return Nimbus.Auth.authorize("GDrive");
    } else {
      deepEqual(Nimbus.Auth.authorized(), true, "have  been  login");
      return start();
    }
  }, 8000);
});

test("Upload binary file(10s)", function() {
  stop();
  setTimeout(function() {
    var finput;
    finput = document.getElementById("file_upload");
    window.f1 = finput.files[0];
    return Nimbus.Binary.upload_file(window.f1, function(file) {
      return window.f2 = file;
    });
  }, 4000);
  return setTimeout(function() {
    deepEqual(window.f2.name, f1.name, "have  been  added");
    return start();
  }, 10000);
});

test("test add share user (10s)", function() {
  stop();
  window.qunit_get_user = function() {
    var params;
    params = {
      path: "/drive/v2/files/" + window.f2.file_id + "/permissions",
      method: "GET",
      callback: function(data) {
        return window.permissionList = JSON.stringify(data);
      }
    };
    return gapi.client.request(params);
  };
  setTimeout(function() {
    return Nimbus.Share.add_share_user_real("release@nimbusbase.com", function(data) {
      return window.qunit_get_user();
    }, window.f2.file_id);
  }, 4000);
  return setTimeout(function() {
    notEqual(window.permissionList.indexOf("nimbusbase.com"), -1, "release@nimbusbase.com   get permission");
    return start();
  }, 10000);
});

test("delete this binary file(10s)", function() {
  stop();
  setTimeout(function() {
    Nimbus.Binary.delete_file(window.f2);
    return binary.find(window.f2.id).destroy();
  }, 5000);
  setTimeout(function() {
    return Nimbus.Binary.read_file(window.f2, function(data) {
      return window.trashed = data.labels.trashed;
    });
  }, 9000);
  return setTimeout(function() {
    deepEqual(window.trashed, true, "have  been  delete");
    Nimbus.Auth.logout();
    return start();
  }, 12000);
});
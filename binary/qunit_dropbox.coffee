
module( "Dropbox Binary Test" )
#test if you can create an file 
test("Auto Login(8s)",()->
        stop()
        setTimeout(()->
                if(!Nimbus.Auth.authorized())
                        localStorage.clear()
                        Nimbus.Auth.authorize("Dropbox")
                else
                        deepEqual(Nimbus.Auth.authorized(),true,"have  been  login")
                        start()
        ,8000)  
)
 

test("Upload binary file(10s)",()->
        stop() 

        setTimeout(()-> 
                finput = document.getElementById("file_upload")  
                window.f1 = finput.files[0];  
                Nimbus.Binary.upload_file(window.f1
                        ,(file)->
                            window.f2 = file
                ) 
        ,4000) 
        setTimeout(()->
                Nimbus.Client.Dropbox.getMetadataList("/" + window.f1.name, 
                (data)->
                    deepEqual(1,1,"have  been  added") 
                    start()
                ,(err)->
                    deepEqual(0,1,"have  been  added")
                    start()
                )
        ,10000) 
)

 
test("delete this binary file(10s)",()->
        stop()  
        setTimeout(()->
                Nimbus.Binary.delete_file(window.f2)
                binary.find(window.f2.id).destroy()  
        ,5000)
        
        setTimeout(()-> 
                Nimbus.Client.Dropbox.getMetadataList("/" + window.f1.name, 
                (data)->
                    deepEqual(0,1,"have  been  deleted") 
                    start()
                ,(err)->
                    deepEqual(1,1,"have  been  deleted")
                    start()
                )
        ,10000) 
)

 
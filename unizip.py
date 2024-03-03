from zipfile import ZipFile

# running a loop to get the file
postFileName = 1
while(postFileName == 1):
    #filename = "D:\\DSA Course\\(" + str(postFileName) + ").zip"
    filename = "(" + str(postFileName) + ").zip"
    
    print(filename)
    unzipFilename = "D:\DSA Course"
    with ZipFile(filename, "r") as zObject:
        zObject.extractall()

    postFileName+= 1
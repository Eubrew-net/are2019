import os

myBrewer="166"
myCampaign="~/CODE/campaigns/are2019"
myAVGs=["SLOAVG", "DTOAVG", "RSOAVG", "APOAVG", "HGOAVG", "H2OAVG", "OPAVG"]

# download, unzip, and svn add all files
for myFile in myAVGs:

    # get
    myCmd="curl -u ibero:nesia 'http://www.eubrewnet.org/eubrewnet/data/get/Files?brewerid="+\
            myBrewer+"&type="+myFile+"&date=2019-05-17' > tempEBNdata.zip"
    os.system(myCmd)

    # unzip
    myCmd="unzip tempEBNdata.zip -d "+myCampaign+"/bdata"+myBrewer
    os.system(myCmd)

    # svn add
    myCmd="svn add "+myCampaign+"/bdata"+myBrewer+"/*"
    os.system(myCmd)

# now do the svn commit
myCmd="svn commit -m 'Added AVG files for Brewer "+myBrewer+\
      "' --username brewersync --password redbrewer "+myCampaign
os.system(myCmd)

# and update
myCmd="svn update "+myCampaign
os.system(myCmd)

# finally, delete the temp file
myCmd="rm tempEBNdata.zip"
os.system(myCmd)

import os

myBrewers=["005","033","070","075","117","150","151","185","186","201","202","228"]

myCampaign="~/CODE/rbcce.aemet.es/campaigns/are2019"

myAVGs=["SLOAVG", "DTOAVG", "RSOAVG", "APOAVG", "HGOAVG", "H2OAVG", "OPAVG", "FIOAVG"]

# download, unzip, and svn add all files
for myBrewer in myBrewers: 
  for myFile in myAVGs:
    # get
    myCmd="curl -# -u ibero:nesia 'http://www.eubrewnet.org/eubrewnet/data/get/Files?brewerid="+\
            myBrewer+"&type="+myFile+"&date=2019-05-17' > tempEBNdata.zip"
    os.system(myCmd)

    # unzip
    myCmd="unzip -o tempEBNdata.zip -d "+myCampaign+"/bdata"+myBrewer
    os.system(myCmd)

    # svn add
    myCmd="svn add --force "+myCampaign+"/bdata"+myBrewer+\
          "/"+myFile+"."+myBrewer
    os.system(myCmd)

  # now do the svn commit
  myCmd="svn commit -m 'Added AVG files for Brewer "+myBrewer+\
      "' --username brewersync --password redbrewer "+\
      myCampaign+"/bdata"+myBrewer
  os.system(myCmd)

# and update
myCmd="svn update "+myCampaign
os.system(myCmd)

# finally, delete the temp file
myCmd="rm tempEBNdata.zip"
os.system(myCmd)

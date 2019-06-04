import os

myBrewers=["005","033","070","075","117","150","151","185","186","201","202","228"]

myCampaign="~/CODE/rbcce.aemet.es/campaigns/are2019"

myAVGs=["SLOAVG", "DTOAVG", "RSOAVG", "APOAVG", "HGOAVG", "H2OAVG", "OPAVG", "FIOAVG"]

# get users and passwords
with open('ebn2svn_user.txt', 'r') as myFile:
    myString=myFile.read()

    ebnUser=myString.split(",")[0].strip()
    ebnPass=myString.split(",")[1].strip()
    svnUser=myString.split(",")[2].strip()
    svnPass=myString.split(",")[3].strip()

# download, unzip, and svn add all files
for myBrewer in myBrewers: 
  for myFile in myAVGs:
    # get
    myCmd="curl -# -u "+ebnUser+":"+ebnPass+\
            " 'http://www.eubrewnet.org/eubrewnet/data/get/Files?brewerid="+\
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
      "' --username "+svnUser+" --password "+svnPass+" "+\
      myCampaign+"/bdata"+myBrewer
  os.system(myCmd)

# and update
myCmd="svn update "+myCampaign
os.system(myCmd)

# finally, delete the temp file
myCmd="rm tempEBNdata.zip"
os.system(myCmd)

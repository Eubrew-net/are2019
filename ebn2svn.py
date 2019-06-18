#!/usr/bin/python


# ------------------------------------------------------------------------
# ebn2sv: download data from Eubrewnet and commit it to an SVN repo
#
# 20190517 JLS
# 20190624 JLS: now reads usernames and passwords from ebn2_user.txt: must
#+              contain a single line with ebnUser,ebnPass,svnUser,svnPass
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
from __future__ import print_function
import argparse
import datetime
import os
import zipfile
import sys

try:
    import pycurl
    pycurlAvail=True
except:
    pycurlAvail=False

try:
    import pysvn
    pysvnAvail=True
except:
    pysvnAvail=False



# ------------------------------------------------------------------------
def getEBN(args):
    """
    Download B files from Eubrewnet using Bentor's data/get/Files function

    Will either use pycurl or the curl command available in the system

    20190517 JLS
    """

    #myURL='http://www.eubrewnet.org/eubrewnet/data/get/AllFiles?'
    myURL='http://www.eubrewnet.org/eubrewnet/data/get/Files?type=B&'
    myURL+='brewerid='+str(args.myBrewer_str)
    myURL+='&date='+args.iniDate
    myURL+='&enddate='+args.endDate


    if args.pycurl: # pycurl was successfully imported
        print("Getting data with pycurl and "+myURL)
        try: 
            with open(args.tempFile, 'wb') as myFile:
                curlHandle = pycurl.Curl()

                curlHandle.setopt(curlHandle.WRITEDATA, myFile)

                # lib curl options. for a complete list (inc proxy settings)
                # see https://curl.haxx.se/libcurl/c/curl_easy_setopt.html
                curlHandle.setopt(curlHandle.URL, myURL)
                curlHandle.setopt(curlHandle.USERNAME, args.ebnUser)
                curlHandle.setopt(curlHandle.PASSWORD, args.ebnPass)

                curlHandle.perform()

                curlHandle.close()

        except Exception as err: # something went wrong
            return err

    else: # pycurl was not imported, use system's curl with the most basic call method: os.system
        myCurl="curl -u "+args.ebnUser+":"+args.ebnPass+" '"+myURL+"' >"+args.tempFile
        print("Getting data with "+myCurl)
        try:
            os.system(myCurl)
        except Exception as err:
            return err


# ------------------------------------------------------------------------
def unzipData(args):
    """
    Unzip the data downloaded from EBN. If unzip fails, it's likely that
    we downloaded an error message, so read it

    20190516 JLS
    """

    myDir=args.myBrewer_svnDir

    print("Copying files to "+myDir)

    if not os.path.isdir(myDir):
        return "Dir "+myDir+" does not exist!"

    try:
        with zipfile.ZipFile(args.tempFile, 'r') as zipHandle:
            zipHandle.extractall(myDir)

    except:
        with open(args.tempFile, 'r') as myFile:
            return myFile.read()


# ------------------------------------------------------------------------
def copyBfiles(args):
    myDay=str(datetime.datetime.now().timetuple().tm_yday)
    myYear=str(datetime.datetime.now().timetuple().tm_year)[2:]

    myBfile="B"+myDay+myYear+"."+args.myBrewer_str
    myBfileWithDir=os.path.join(args.myBrewer_svnDir,myBfile)

    myBfilesDir=os.path.join(args.svnDir,"bfiles")

    # this next line will only work in linux and macos
    myCp="cp "+myBfileWithDir+" "+myBfilesDir 

    print("Copying B file with "+myCp)

    os.system(myCp)

    myAdd="svn add "+myBfilesDir+"/"+myBfile
    commitMsg="ebn2svn added B file to bfiles for Brewer "+args.myBrewer_str
    myCommit="svn commit -m '"+commitMsg+\
             "' --username "+args.svnUser+" --password "+args.svnPass+" "+\
             myBfilesDir+"/"+myBfile
    myUpdate="svn update "+args.svnDir

    print("Adding file with "+myAdd)
    os.system(myAdd)

    print("Committing file with "+myCommit)
    os.system(myCommit)

    print("Updating repository with "+myUpdate)
    os.system(myUpdate)


# ------------------------------------------------------------------------
def _svn_login(realm, username, may_save):
    # i'm not completely sure how this works... for more information, see
    # https://tools.ietf.org/doc/python-svn/pysvn_prog_guide.html 
    return True, args.svnUser, args.svnPass, False

def commitSVN(args):
    """
    Commit the downloaded data using pysvn or the svn command available in the system

    20190517 JLS
    """

    commitMsg="ebn2svn added B files for Brewer "+args.myBrewer_str

    if args.pysvn: # pysvn was successfully imported
        print("Adding and committing files with pysvn, please wait")

        svnHandle=pysvn.Client()
        svnHandle.callback_get_login=_svn_login # i'm not completely sure how this works...
    
        try:
            svnHandle.add(args.myBrewer_svnDir, force=True)
            svnHandle.checkin(args.myBrewer_svnDir,commitMsg)
        except Exception as err:
            return err

        # update the whole repo after the commit (to avoid problems with the logs, at least)
        svnHandle.update(args.svnDir)

    else: # no pysvn, call the svn command available in the system
        myAdd="svn add --force "+args.myBrewer_svnDir
        myCommit="svn commit -m '"+commitMsg+\
                "' --username "+args.svnUser+" --password "+args.svnPass+" "+\
                args.myBrewer_svnDir
        myUpdate="svn update "+args.svnDir

        print("Adding files with "+myAdd)
        try:
            os.system(myAdd)
        except Exception as err:
            return err

        print("Committing files with "+myCommit)
        try:
            os.system(myCommit)
        except Exception as err:
            return err

        print("Updating repository with "+myUpdate)
        try:
            os.system(myUpdate)
        except Exception as err:
            return err


# ------------------------------------------------------------------------
def main(args):
    """
    Main driver of all functions above

    20190516 JLS
    """

    # expand home dir
    args.svnDir=os.path.expanduser(args.svnDir)

    # loop over the requested brewers
    for myBrewer in args.brewerId:
        # vars for this brewer
        args.myBrewer_str='{:03d}'.format(myBrewer) # quite nice that you can directly add to args!
        args.myBrewer_svnDir=os.path.join(args.svnDir,"bdata"+args.myBrewer_str)
        
        print("=== Working on Brewer #"+args.myBrewer_str)

        # 1) download a zip file with the data
        error=None
        error=getEBN(args)

        if error: # this will not catch errors messages issued by EBN
            print("Error! "+str(error))
            sys.exit(1)

        # 2) unzip the data
        error=None
        error=unzipData(args)
    
        if error: # this will show the messages issued by EBN
            print("Error! "+str(error))
            sys.exit(1)
        else:
            os.remove(args.tempFile)

        # 3) copy b files from bdataXXX to bfiles
        # this was coded in a hurry at are2019, is crappy, 
        #+and will only work in linux and mac (i hope!)
        copyBfiles(args)

        # 4) commit to svn
        error=None
        error=commitSVN(args)

        if error:
            print("Error! "+str(error))
            sys.exit(1)

    # all done!
    print("=== All done!")


# ------------------------------------------------------------------------
if __name__ == "__main__":

    # default dates for date options
    today=datetime.datetime.now()
    today_str=today.strftime("%Y-%m-%d")
    twoWeeksAgo=today-datetime.timedelta(14,0,0)
    twoWeeksAgo_str=twoWeeksAgo.strftime("%Y-%m-%d")

    # parse args from the command line
    parser = argparse.ArgumentParser()

    parser.add_argument("-b", "--brewer", dest="brewerId",\
            help="Brewer ID(s)", nargs='+', type=int, required=True)

    #parser.add_argument("-u", "--user", dest="ebnUser",\
    #        help="Eubrewnet's user name, uses the 'ibero' account by default",\
    #        default="ibero", type=str)

    #parser.add_argument("-p", "--password", dest="ebnPass",\
    #        help="Eubrewnet's password, uses the 'ibero' account by default",\
    #        required=True, type=str)

    parser.add_argument("-s", "--startDate", dest="iniDate",\
            help="Start date in YYYY-MM-DD format, two weeks ago from today by default",\
            default=twoWeeksAgo_str, type=str)

    parser.add_argument("-e", "--endDate", dest="endDate",\
            help="End date in YYYY-MM-DD, today by default",\
            default=today_str, type=str)

    parser.add_argument("-c", "--campaign", dest="svnDir",\
            help="SVN campaign dir, '~/CODE/campaigns/are2019' by default",\
            default="~/CODE/campaigns/are2019", type=str)

    parser.add_argument("-t", "--tempFile", dest="tempFile",\
            help="Temp file with data downloaded from EBN, './tempEBNdownload.zip' by default",
            default="tempEBNdownload.zip", type=str)

    args = parser.parse_args()

    # add vars for import checks
    args.pycurl=pycurlAvail
    args.pysvn=pysvnAvail

    # read users and password from a file
    try:
        with open('ebn2svn_user.txt', 'r') as myFile:
            myString=myFile.read()

        args.ebnUser=myString.split(",")[0].strip()
        args.ebnPass=myString.split(",")[1].strip()
        args.svnUser=myString.split(",")[2].strip()
        args.svnPass=myString.split(",")[3].strip()
    except:
        print("Failed loading usernames and passwords from file 'ebn2svn_user.txt' with format 'EBN_user,EBN_pass,SVN_user,SVN_pass'")
        sys.exit(1)


    # call the driver
    main(args)




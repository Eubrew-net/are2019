#!/usr/bin/python


# ------------------------------------------------------------------------
# ebn2sv: download data from Eubrewnet and commit it to an SVN repo
#
# 20190516 JLS
# ------------------------------------------------------------------------


import pycurl
import argparse
import datetime
import os
import zipfile
import pysvn


# ------------------------------------------------------------------------
def getEBN(args):
    """
    Download B files from Eubrewnet using Bentor's data/get/Files function

    20190516 JLS
    """

    #myURL='http://www.eubrewnet.org/eubrewnet/data/get/AllFiles?'
    myURL='http://www.eubrewnet.org/eubrewnet/data/get/Files?type=B&'
    myURL+='brewerid='+str(args.myBrewer_str)
    myURL+='&date='+args.iniDate
    myURL+='&enddate='+args.endDate

    print "Getting data with "+myURL

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


# ------------------------------------------------------------------------
def unzipData(args):
    """
    Unzip the data downloaded from EBN. If unzip fails, it's likely that
    we downloaded an error message, so read it

    20190516 JLS
    """

    myDir=args.myBrewer_svnDir

    print "Copying files to "+myDir

    if not os.path.isdir(myDir):
        return "Dir "+myDir+" does not exist!"

    try:
        with zipfile.ZipFile(args.tempFile, 'r') as zipHandle:
            zipHandle.extractall(myDir)

    except BadZipFile:
        with open(args.tempFile, 'r') as myFile:
            return myFile.read()


# ------------------------------------------------------------------------
def _svn_login(realm, username, may_save):
    # i'm not completely sure how this works...
    svnUser="brewersync"
    svnPass="redbrewer"
    return True, svnUser, svnPass, False

def commitSVN(args):
    """
    Commit the downloaded data using pysvn, see

    https://tools.ietf.org/doc/python-svn/pysvn_prog_guide.html
    
    I don't completely understand how everything works :-S

    20190516 JLS
    """

    print "Committing files, please wait"

    commitMsg="ebn2svn added B files for Brewer "+args.myBrewer_str

    svnHandle=pysvn.Client()
    svnHandle.callback_get_login=_svn_login # i'm not completely sure how this works...
    
    try:
        svnHandle.add(args.myBrewer_svnDir, force=True)
        svnHandle.checkin(args.myBrewer_svnDir,commitMsg)
    except Exception as err:
        return err

    # update the whole repo after the commit (to avoid problems with the logs, at least)
    svnHandle.update(args.svnDir)


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
        
        print "=== Working on Brewer #"+args.myBrewer_str

        # 1) download a zip file with the data
        error=None
        error=getEBN(args)

        if error: # this will not catch errors messages issued by EBN
            print "Error! "+error
            quit() # this should be an error exit

        # 2) unzip the data
        error=None
        error=unzipData(args)
    
        if error: # this will show the messages issued by EBN
            print "Error! "+error
            quit()
        else:
            os.remove(args.tempFile)

        # 3) commit to svn
        error=None
        error=commitSVN(args)

        if error:
            print "Error! "+error
            quit()

    # all done!
    print "=== All done!"


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

    parser.add_argument("-u", "--user", dest="ebnUser",\
            help="Eubrewnet's user name, uses the 'ibero' account by default",\
            default="ibero", type=str)

    parser.add_argument("-p", "--password", dest="ebnPass",\
            help="Eubrewnet's password, uses the 'ibero' account by default",\
            default="nesia", type=str)

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

    # call the driver
    main(args)




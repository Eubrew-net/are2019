#!/usr/bin/python


# ------------------------------------------------------------------------
# ebn2plot: download and plot data from Eubrewnet
# 
# 20190523 JLS
# 20190616 JLS: now reads usernames and passwords from ebn2_user.txt: must
#+              contain a single line with ebnUser,ebnPass,...
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
from __future__ import print_function
import argparse
import datetime
import os
import sys
import matplotlib.pyplot as plt

try:
    from StringIO import StringIO
    import pycurl
    pycurlAvail=True
except:
    import subprocess
    pycurlAvail=False

# ------------------------------------------------------------------------
def getEBN(args):
    """
    Download data from Eubrewnet using the data/{process/get}/{O3L1/...} 
    functions

    Will either use pycurl or the system's curl command

    20190523 JLS
    """

    err=None

    # generate the url
    myURL="http://www.eubrewnet.org/eubrewnet/data/"+\
          args.urlFunc+"/"+args.urlArg
    myURL+="?brewerid="+str(args.myBrewer_str)
    myURL+="&date="+args.iniDate
    myURL+="&enddate="+args.endDate
    myURL+="&format=jsonO"

    # download the data
    if args.pycurl: # pycurl was successfully imported
        print("Getting data with pycurl from "+myURL)
        try: 
            myBuffer=StringIO()
            curlHandle = pycurl.Curl()

            curlHandle.setopt(curlHandle.WRITEDATA, myBuffer)

            # lib curl options. for a complete list (inc proxy settings)
            # see https://curl.haxx.se/libcurl/c/curl_easy_setopt.html
            curlHandle.setopt(curlHandle.URL, myURL)
            curlHandle.setopt(curlHandle.USERNAME, args.ebnUser)
            curlHandle.setopt(curlHandle.PASSWORD, args.ebnPass)

            curlHandle.perform()

            curlHandle.close()

            args.myDownload=myBuffer.getvalue()

        except Exception as err: # something went wrong
            err=str(err)

    else: # pycurl was not imported, use system's curl
        myCurl='curl -s -u '+args.ebnUser+':'+args.ebnPass+\
               ' "'+myURL+'"'

        print("Getting data with "+myCurl)
        try:
            args.myDownload=subprocess.check_output(myCurl,shell=True)
        except Exception as err:
            err=str(err)

    return (args, err)

# ------------------------------------------------------------------------
def parseEBN(args):
    """
    Parse the data. This is very easy thanks to Bentor's '&format=jsonO'!

    20190523 JLS
    """

    err=None

    print("Parsing")

    try: 
        args.ebnData=eval(args.myDownload)

        args.ebnData['date']=\
           [datetime.datetime.strptime(i,'%Y%m%dT%H%M%SZ') \
           for i in args.ebnData['gmt']]

    except Exception as err:
        err=str(err)

    return (args, err)


# ------------------------------------------------------------------------
def plotEBN(args):
    """
    Plot the data

    20190524 JLS
    """

    err=None

    # check if plot vars are present in the downloaded data
    availableVars=args.ebnData.keys()
    availableVars_str=", ".join(availableVars)

    if not args.plotX in availableVars:
        err=args.plotX+" not found in "+availableVars_str  
        return err

    if not args.plotY in availableVars:
        err=args.plotY+" not found in "+availableVars_str  
        return err

    print("Plotting")
    # plot
    try: 
        plt.plot(args.ebnData[args.plotX], args.ebnData[args.plotY], \
            label="B#"+args.myBrewer_str)

    except Exception as err:
        return str(err)

    

# ------------------------------------------------------------------------
def main(args):
    """
    Main driver for all the functions above

    20190524 JLS
    """

    # set the figure size
    plt.figure(figsize=(9,4))

    # loop over the requested brewers
    for myBrewer in args.brewerId:
        # vars for this brewer
        args.myBrewer_str='{:03d}'.format(myBrewer)
        
        print("=== Working on Brewer #"+args.myBrewer_str)

        error=None

        # 1) download the data to a temporary file
        (args, error)=getEBN(args)

        if error: # this will not catch errors messages issued by EBN
            print("Error! "+error)
            sys.exit(1)

        # 2) parse the data 
        (args, error)=parseEBN(args)


        if error:
            print("Error! "+error)
            sys.exit(1)

        # 3) plot the data
        error=plotEBN(args)

        if error:
            print("Error! "+error)
            sys.exit(1)

    # format and show the plot
    plt.title("EUBREWNET's "+args.urlFunc+"/"+args.urlArg+" data",\
              loc='center')
    plt.ylabel(args.plotY)
    plt.xlabel(args.plotX)
    #if args.plotX=="date":
    #    plt.xticks(rotation=10, ha="right")
    plt.legend()
    plt.grid(True)
    plt.show()
    
    # good bye!
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

    parser.description="Plot data downloaded from EUBREWNET. "+\
        "Try 'ebn2plot.py -b 157 -a O3L1_5 -y o3'"

    parser.add_argument("-b", "--brewer", dest="brewerId",\
            help="Brewer ID(s)", nargs='+', type=int, required=True)

    parser.add_argument("-f", "--function", dest="urlFunc",\
            help="Either 'get' (default) or 'process'", type=str, default='get')

    parser.add_argument("-a", "--argument", dest="urlArg",\
            help="Any of 'O3L1', 'O3L1_5', ...", type=str, required=True)

    parser.add_argument("-y", "--plotY", dest="plotY",\
            help="Variable to plot in the Y axis", type=str, required=True)

    parser.add_argument("-x", "--plotX", dest="plotX",\
            help="Variable to plot in the X axis, 'date' by default", type=str,\
            default='date')

    #parser.add_argument("-u", "--user", dest="ebnUser",\
    #        help="Eubrewnet's user name, uses the 'ibero' account by default",\
    #        required=True, type=str)

    #parser.add_argument("-p", "--password", dest="ebnPass",\
    #        help="Eubrewnet's password, uses the 'ibero' account by default",\
    #        required=True, type=str)

    parser.add_argument("-s", "--startDate", dest="iniDate",\
            help="Start date in YYYY-MM-DD format, two weeks ago from today by default",\
            default=twoWeeksAgo_str, type=str)

    parser.add_argument("-e", "--endDate", dest="endDate",\
            help="End date in YYYY-MM-DD, today by default",\
            default=today_str, type=str)

    args = parser.parse_args()

    # add var for import check
    args.pycurl=pycurlAvail

    # read users and password from a file
    try:
        with open('ebn2svn_user.txt', 'r') as myFile:
            myString=myFile.read()

        args.ebnUser=myString.split(",")[0].strip()
        args.ebnPass=myString.split(",")[1].strip()
    except:
        print("Failed loading usernames and passwords from file 'ebn2svn_user.txt' with format 'EBN_user,EBN_pass'")
        sys.exit(1)


    # call the driver
    main(args)




#!/usr/bin/env python
import SOAPpy, getpass, datetime, array, base64, random, time, os, sys, re
from SOAPpy import Types
from optparse import OptionParser

rserver = 'jira01roc'
soap = SOAPpy.WSDL.Proxy('http://'+rserver+':8080/rpc/soap/jirasoapservice-v2?wsdl')
jirauser = 'sdeal'
passwd = 'Jannina1010'
auth = soap.login(jirauser, passwd)

def generateIssueList(option, opt, value, parser):
        path = parser.rargs[0]
        f = open(path + '/issues.txt','w')
        f.write("##### BUILD_ID : " + parser.rargs[1] + '\n')
        query = 'status = "Pending Deployment" AND fixVersion in (' + parser.rargs[2] + ')'
        issues = soap.getIssuesFromJqlSearch(auth,query,99)
        for issue in issues:
            f.write(issue['key'] + '\n')
        f.close()

def promotePending(option, opt, value, parser):
        pattern = '^#'
        path = parser.rargs[0]
        f = open(path + '/issues.txt','r')
        for issue in f:
                issue = issue.strip('\n');
                if re.search(pattern,issue):
                    pass
                else:
                    print 'Progressing Jira issue *',issue,'*'
                    try:
			result = soap.progressWorkflowAction(auth, issue, '7',\
                            [{'id': 'resolution', 'values': ['1']},\
                            {'id': 'assignee', 'values': ['sdeal']}])
                    except:
                        print "Error:",sys.exc_info()[0]

parser = OptionParser(usage="%prog [-g,-p]", version="%prog 1.0")
parser.add_option("-g","--generate-list",action="callback", callback=generateIssueList, help="Generate the list of JIRA issues pending deployment.")
parser.add_option("-p","--process-list",action="callback", callback=promotePending, help="Process the list of JIRA issues pending deployment.")

(options,args) = parser.parse_args()

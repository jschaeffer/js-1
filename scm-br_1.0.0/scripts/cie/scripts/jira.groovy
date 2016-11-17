#!/usr/bin/groovy

@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.5.1')
@GrabExclude("org.codehaus.groovy:groovy")

import groovyx.net.http.RESTClient
import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.ContentType.*
import org.apache.http.HttpRequestInterceptor
import org.apache.http.protocol.HttpContext
import org.apache.http.HttpRequest

//import groovy.util.slurpersupport.GPathResult
//import static groovyx.net.http.ContentType.URLENC

def jiraServer = '10.13.18.94'
//def jiraServer = 'dev.accesscanoe.com'
//def jiraServer = '10.13.18.93'
def query = 'status = "Closed"'
def jiraUser = 'pzimmerman'
def jiraPassword = 'myP@55w0rd'
def jiraResponse
jiraURI = "http://10.13.18.94:8080/JIRA/"
//jiraURI = "https://dev.accesscanoe.com/JIRA/"
println "Jira URL = $jiraURI"

RESTClient jira = new RESTClient(jiraURI)

//HTTPBuilder jira = new HTTPBuilder(jiraURI)

//def searchQuery = 'project = "SCM" AND status = "Open"'
def searchQueryWP = 'project = "WEBPORTAL" AND status = "Closed"'
def searchQuerySD = 'project = "SYSDATA" AND status = "Resolved"'
def searchQueryDAI = 'project = "VODDAI" AND status = "Resolved"'
def searchQueryCS = 'status = "Pending Deployment"'
def resultMap = [:]
def issuesMap = [:]
def issueName
def getIssueURL = "rest/api/latest/issue/VODAI-1132.json"
def fullUrl = jiraURI + "/" + getIssueURL
println "Full URL = $fullUrl"
File htmlOut
BufferedWriter bw
FileWriter fw
String issueBrowseURI = "http://$jiraServer:8080/JIRA/browse"
def status

try {

    def json
    
    jira.auth.basic (jiraUser, jiraPassword)
    jira.handler.failure = { resp ->
        println "Unexpected failure ${resp.statusLine} ${resp.status}"
        status = resp.status
        if( status.toInteger() == 404 ) {
            println "Ticket was not found"
        }
    }

    //jiraResponse = jira.get( path : "/rest/api/latest/search", query : [ jql : searchQueryDAI, startAt : '0', maxResults : '15', os_authType : 'basic'])
    //jiraResponse = jira.get( path : "/rest/api/latest/search", query : [ os_authType : 'basic'])
    //jiraResponse = jira.get( path : getIssueURL, query : [ os_authType : 'basic'], headers : [ 'Content-Type' : 'application/json' ] )
    jiraResponse = jira.get( path : getIssueURL, query : [ os_authType : 'basic'] ) { resp, data ->
        json = data
        status = resp.status
    }
    //assert status == 200

    resultMap = json
    def fieldsMap = resultMap.get("fields")
    def state = fieldsMap.get("status").get("value").name
    //def statusValuesMap = statusMap.get("value")
    //println "Resolution = $resolutionMap"
    println "status = $state"
/*
    if (resolution.equals("Resolved")) {
        issueName = issue.get("key")
        println issueName
    }
*/
}
catch (Exception ex) {
    ex.printStackTrace()
}

package canoe.alm.utils

@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.5.1')
@GrabExclude("org.codehaus.groovy:groovy") 

import canoe.alm.scm.*
import canoe.alm.utils.Log4j
import canoe.alm.utils.OsCommands
import java.lang.String

import groovyx.net.http.RESTClient
import groovyx.net.http.HTTPBuilder
import static groovyx.net.http.ContentType.*
import org.apache.http.HttpRequestInterceptor
import org.apache.http.protocol.HttpContext
import org.apache.http.HttpRequest

class JiraUtils {

    def config
    def logger
    def jiraUser
    def jiraPasswd
    def jiraURL
    def jiraIssueURI
    def jiraResponse
    def jiraCliDir
    def jiraCliScript
    def resultMap = [:]
    def status
    def json
    RESTClient jira

    def init() {

        logger = Log4j.getLogger(this.class)
        if(System.getenv("SCM_CONFIG") && new File(System.getenv("SCM_CONFIG")).exists()) {
            logger.debug("SCM_CONFIG variable defined. Getting config info now...")
            config = new ConfigSlurper().parse(new File(System.getenv("SCM_CONFIG")).toURL())
        }
        else {
            logger.fatal("SCM_CONFIG variable not defined. Cannot get config info...")
        }

        jiraUser = config.jira.user
        jiraPasswd = config.jira.password
        jiraURL = config.jira.baseURL 
        jiraIssueURI = config.jira.issueURI //e.g., "rest/api/latest/issue"
        jiraCliDir = config.jira.cliScriptDir
        jiraCliScript = config.jira.cliScriptName
    }

    static void main( String[] args ) {
        JiraUtils jiraUtils = new JiraUtils()
        //logger.debug("In main of JiraUtils.groovy")
    }

    def setBuildFixedIn(def jiraTickets, def snapshot, def project) {

        init()
        
        def snapshotId = project + "_" + snapshot
        def setBuildCmd = "./" + jiraCliScript + " --action setFieldValue --field \"Build ID\" --values \"${snapshotId}\""
        def osCmds = new OsCommands()
        def fieldsMap = [:]
        def ticketStatus
        def updateCmd
        jira = new RESTClient(jiraURL)
        jira.auth.basic (jiraUser, jiraPasswd)
        jira.handler.failure = { resp ->
            println "Unexpected failure ${resp.statusLine} ${resp.status}"
            status = resp.status
            if (status.toInteger() == 404 ) {
                logger.warn( "JIRA TICKET NOT FOUND! The Jira ticket was referenced in the git commit logs, but was not found inside Jira!" )
            }
            else if (status.toInteger() != 200 ) {
                logger.warn( "Cannot access Jira. Please check the Jira server and ensure it is functioning properly." )
            }
        }
        
        logger.debug("Updating all tix with snapshot: " + snapshot)
        jiraTickets.each() { key, value ->
            logger.info("Attempting to get status of ticket: ${value}")
            jiraResponse = jira.get( path : jiraIssueURI + value +".json", query : [ os_authType : 'basic'] ) { resp, data ->
                json = data
                status = resp.status
            }
            if(status.toInteger() == 200) { // the ticket is valid in Jira, let's get the status
                
                resultMap = json
                fieldsMap = resultMap.get("fields")
                ticketStatus = fieldsMap.get("status").get("value").name
                println "ticketStatus = $ticketStatus"
                if( ticketStatus.equals("Resolved") ) {
                    //we can update the ticket with the build (snapshot)
                    logger.info("Ticket: ${value} is resolved! We can update it!")
                    updateCmd = setBuildCmd + " --issue \"${value}\""
                    logger.debug("cli command = $updateCmd")
                    osCmds.shellCommand( setBuildCmd + " --issue  \"${value}\"", jiraCliDir )
                }
                else {
                    logger.warn("Ticket: ${value} is in the \"$ticketStatus\" state. Cannot update it with snapshot.")
                }
            }
        }  
    }
}

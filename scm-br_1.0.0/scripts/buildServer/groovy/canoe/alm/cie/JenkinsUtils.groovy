package canoe.alm.cie

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

class JenkinsUtils {

    static void main( String[] args ) {
        JenkinsUtils jenkinsUtils = new JenkinsUtils()
        def logger = Log4j.getLogger(this.class)
        logger.debug("In main of Cie.groovy")
    }

    def jobPrefix
    def jobURI
    def jobURL
    def configFile
    def jobsView
    def jenkinsUser
    def jenkinsPassword
    def jenkinsResponse
    def jenkinsURL
    def status 
    RESTClient http

    def getJenkinsJobsView(def project) {
        def logger = Log4j.getLogger(this.class)
        def config
        if(System.getenv("SCM_CONFIG") && new File(System.getenv("SCM_CONFIG")).exists()) {
            logger.debug("SCM_CONFIG variable defined. Getting config info now...")
            config = new ConfigSlurper().parse(new File(System.getenv("SCM_CONFIG")).toURL())
        }
        else {
            logger.fatal("SCM_CONFIG variable not defined. Cannot get config info...")
        }

        jenkinsUser = config.jenkins.user
        jenkinsPassword = config.jenkins.password
        jenkinsResponse
        jenkinsURL = config.jenkins.baseURL
        jobURL = config.jenkins.jobURL
        logger.debug("Jenkins URL = $jenkinsURL")
        logger.debug("Jenkins View = $jobURL")
        //System.exit(1)

        http = new RESTClient(jenkinsURL)
        http.auth.basic( jenkinsUser, jenkinsPassword ) 
        def jobViewName = config."$project".view
        jobPrefix = config."$project".prefix
        logger.debug( "jobViewName = $jobViewName" )
        jobURI = "view/$jobViewName/job"
        configFile = 'config.xml'
        jobsView = "view/$jobViewName/api/json"
        logger.debug( "jobsView = $jobsView" )
        http.handler.failure = { resp ->
            println "Unexpected failure ${resp.statusLine} ${resp.status}"
            status = resp.status
        }

        def info
        http.get(path: jobsView) { resp, json ->
            info = json
            status = resp.status
        }
        return info
    }

    def copyJenkinsJobs( String project, String lod_src, String lod_new ) {

        def logger = Log4j.getLogger(this.class)
        jobsView = getJenkinsJobsView(project)
        def resultMap = [:]
        def jobsMap = [:]
        def jobName
        def jobNameNew
        //String jobConfigurationURI = "http://$jenkinsURL"
        def foundJob = "false"

        try {
            //resultMap = info
            resultMap = jobsView
            jobsMap = resultMap.get("jobs")
            File configXml
            File configXmlNew
            OutputStreamWriter out
            FileOutputStream fout

            for (job in jobsMap) {
                jobName = job.get("name")
                logger.debug("jobName = $jobName")
                logger.debug("job_prefix = $jobPrefix")
                logger.debug("lod src = $lod_src")
                if( jobName.startsWith(jobPrefix) && jobName.endsWith(lod_src) ) {
                    foundJob = "true"
                    logger.debug( "In the IF condition - made it!" )
                    //System.exit(1)
                    logger.debug("Found job $jobName for $lod_src")
                    jobNameNew = jobName.replaceAll(lod_src, lod_new)
                    //get config for the job
                    def configPathGet = "$jobURI/$jobName/$configFile"
                    def configPathPost = "createItem"
                    println "configPathGet = $configPathGet"
                    def confOrig
                    def confNew
                    // This is needed so that the connection is authenticated as the request is made, otherwise you get a 403 - Forbidden status
                    http.client.addRequestInterceptor( new HttpRequestInterceptor() {
                       void process(HttpRequest httpRequest, HttpContext httpContext) {
                           httpRequest.addHeader('Authorization', 'Basic ' + jenkinsUser +':'+jenkinsPassword.bytes.encodeBase64().toString())
                       }
                    })
         
                    // make the request to get the config.xml file
                    def resp = http.get(path: configPathGet, contentType : TEXT, headers : [ Accept : 'application/xml' ])
                    confOrig = resp.data.text
                    // do the string replace from old lod to new lod
                    confNew = confOrig.replaceAll(lod_src, lod_new)

                    // now let's create the new job and post the new config.xml
                    http.post(path: configPathPost, requestContentType : XML, body : confNew, query : [ 'name' : jobNameNew ] ) { response ->
                        status = response.status
                        if(status == 200) {
                            logger.info("The new Jenkins job $jobNameNew was created successfully")
                        }
                    }
                }
                else {
                    logger.debug( "Fell outside the IF..." )
                    logger.debug( "job name = $jobName" )
                    logger.debug( "Project = $project" )
                }
            }
        }
        catch (Exception ex) {
            ex.printStackTrace()
        }
        if(foundJob.equals("false")) {
            logger.fatal("No existing Jenkins job(s) found for $lod_src. Exiting now....")
            System.exit(1)
        }
    }

    def deleteJenkinsJobs( String project, String lod ) {
        def logger = Log4j.getLogger(this.class)
        jobsView = getJenkinsJobsView(project)
        def resultMap = [:]
        def jobsMap = [:]
        def jobName
        def jobURL

                def foundJob = "false"

        try {
            //resultMap = info
            resultMap = jobsView
            jobsMap = resultMap.get("jobs")
            File configXml
            File configXmlNew
            OutputStreamWriter out
            FileOutputStream fout

            for (job in jobsMap) {
                jobName = job.get("name")
                jobURL = job.get("url")
                logger.debug("jobName = $jobName")
                logger.debug("jobUrl = $jobURL")
                logger.debug("job_prefix = $jobPrefix")
                logger.debug("lod = $lod")
                if( jobName.startsWith(jobPrefix) && jobName.endsWith(lod) ) {
                    foundJob = "true"
                    logger.debug( "In the IF condition - made it! Now let's remove the job." )
                    //System.exit(1)
                    logger.debug("Found job $jobName for $lod")
                    def actionURI = "$jobURI/$jobName/"
                    def postActionDelete = actionURI + "/doDelete"
                    println "actionURI = $actionURI"
                    // This is needed so that the connection is authenticated as the request is made, otherwise you get a 403 - Forbidden status
                    http.client.addRequestInterceptor( new HttpRequestInterceptor() {
                       void process(HttpRequest httpRequest, HttpContext httpContext) {
                           httpRequest.addHeader('Authorization', 'Basic ' + jenkinsUser +':'+jenkinsPassword.bytes.encodeBase64().toString())
                       }
                    })
         
                    // post doDelete against jenkins job
                    http.post(path: postActionDelete, requestContentType : HTML) { response ->
                        status = response.status
                        if(status == 200) {
                            logger.info("The Jenkins job $jobName was deleted successfully")
                        }
                    }
                }
                else {
                    logger.debug( "Fell outside the IF..." )
                    logger.debug( "job name = $jobName" )
                    logger.debug( "Project = $project" )
                }
            }
        }
        catch (Exception ex) {
            ex.printStackTrace()
        }
        if(foundJob.equals("false")) {
            logger.fatal("No existing Jenkins job(s) found for $lod. Exiting now....")
            System.exit(1)
        }
    }
}


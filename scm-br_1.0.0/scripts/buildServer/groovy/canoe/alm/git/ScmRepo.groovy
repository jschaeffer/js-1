package canoe.alm.git
import canoe.alm.scm.*
import canoe.alm.utils.Log4j
import canoe.alm.utils.OsCommands
import java.lang.String

@Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.5.1')
@GrabExclude("org.codehaus.groovy:groovy") 

class ScmRepo {

    static final gitHubUri = "git@github.com:CanoeVentures"
    //static final snapshotPrefix = "v"
    static final snapshotPrefix = "br_"

    static void main( String[] args ) {
        //validate command line args
        def cli = new CliBuilder( usage: 'groovy ScmRepo.groovy -p "project" -l "lod" [-h]' )
        cli.h(longOpt: 'help', 'usage information')
        cli.p(argName: 'project', args: 1, required: true, 'git project name')
        cli.l(argName: 'lod', args: 1, required: false, 'git lod name')

        def project
        def opt = cli.parse(args)
        if(!opt) return
        if(opt.h) 
            cli.usage()
        if(opt.p)
            project = opt.p

        ScmRepo scmRepo = new ScmRepo()
        def logger = Log4j.getLogger(this.class)
        scmRepo.getLodsForProject(project) 
    }

    def byLength = new Comparator() {
        int compare(a,b) { a.size() <=> b.size() }
    }

    def byNumeric = new Comparator() {
        int compare(a,b) { a <=> b }
    }

    def getLatestSnapshotName( String project, String lod ) {
        def logger = Log4j.getLogger(this.class)
        //def getSnapshotsCmd = "git tag -l $lod*"
        def projectname = project
        def projectDir = projectname
        def lodname = lod
        List tagSubStrings = lodname.tokenize('_')
        def brver = "v_" + tagSubStrings[1]
        def getSnapshotsCmd = "git tag -l $brver*"
        // run command to get snapshots for lod
        //println "stderr: ${proc.err.text}"
        //println "stdout: ${proc.in.text}" 
        def allSnapshots = getSnapshotsCmd.execute(null, new File("$projectDir")).text.split("\n")
        def lodSnapshots = []
        def lodBuildNumbers = []

        def snapshot = ''
        for ( element in allSnapshots ) {
            //if( element.startsWith("$lod") ) {
	    if( element.startsWith("$brver") ) {
                lodSnapshots << element
            }
        }
        int numberOfSnapshots = lodSnapshots.size

        if (numberOfSnapshots > 0 ) {
            lodSnapshots.sort(byLength) 
            logger.debug( lodSnapshots.sort(byLength) )
            def latestSnapshotName = lodSnapshots[numberOfSnapshots-1]
            return latestSnapshotName
        }
        else {
            return ""
        }
    }

    def getNextSnapshotName( String project, String lod ) {
        def logger = Log4j.getLogger(this.class)
        def getSnapshotsCmd = "git tag -l $lod*"
        //def projectname = project
        def projectDir = project
        def lodname = lod

        // run command to get snapshots for lod
        //println "stderr: ${proc.err.text}"
        //println "stdout: ${proc.in.text}" 
        def allSnapshots = getSnapshotsCmd.execute(null, new File("$projectDir")).text.split("\n")
        def lodSnapshots = []
        def lodBuildNumbers = []

        def snapshot = ''
        for ( element in allSnapshots ) {
            if( element.startsWith("$lod") ) {
                lodSnapshots << element
            }
        }
        int numberOfSnapshots = lodSnapshots.size

        if (numberOfSnapshots > 0 ) {
            lodSnapshots.sort(byLength) 
            logger.debug(lodSnapshots.sort(byLength))
            def latestSnapshotName = lodSnapshots[numberOfSnapshots-1]
            Snapshot latestSnapshot = new Snapshot( latestSnapshotName )
            def latestBuildNumber = latestSnapshot.getBuildNumber()
            def nextBuildNumber = latestBuildNumber += 1
            def nextSnapshotName = lod + "_" + nextBuildNumber 
            return nextSnapshotName
        }
        else {
            return lod + "_1"
        }
    }

    def getBrVer( String project, String lod ) {
        def logger = Log4j.getLogger(this.class)
        def projectDir = project
        def lodname = lod
        List tagSubStrings = lodname.tokenize('_')
        def nextSnapshotName = tagSubStrings[1]
//        def nextSnapshotName = "v_" + tagSubStrings[1]
        logger.info("nextSnapshotName:${nextSnapshotName} tagSubStrings: ${tagSubStrings}")
        return nextSnapshotName
    }

    def deleteLod( String project, String lod ) {
        
        def logger = Log4j.getLogger(this.class)
        def returnStatus
        def OsCommands osCmds = new OsCommands()

        def deleteLodCmd = "git push origin :$lod"

        logger.info("Deleting lod $lod....")
        logger.info("Running command: " + deleteLodCmd)
        returnStatus = osCmds.shellCommand(deleteLodCmd, project)
        logger.debug("returnStatus = " + returnStatus)
        if(returnStatus != 0) {
            logger.fatal("Could not delete lod $lod: Please check the system and try again.")
            System.exit(1)
        }
        else {
            logger.info("Successfully deleted lod $lod")
        }
    }

    def createLod( String project, String lod_src, String lod_new ) {

        def logger = Log4j.getLogger(this.class)
        def returnStatus
        def OsCommands osCmds = new OsCommands()
        def projectDir = new File(project)
        if(!projectDir.exists()) {
            logger.fatal("The git project $project does not exist. Please make sure you pass in the correct name as it appears in git.")
            System.exit(1)
        }
        checkout( project, lod_src )
        def verifyLodNewRemoteCmd = "git branch -r | grep $lod_new"
        //def createLodCmd = "git branch $lod_new"
        def createLodCmd = "git push origin origin/$lod_src:refs/heads/$lod_new"
        def pushLodCmd = "git push origin $lod_new"
        logger.info("Checking to see if new lod has already been created....")
        logger.info("Running command: " + verifyLodNewRemoteCmd)
        returnStatus = osCmds.shellCommand(verifyLodNewRemoteCmd, project)
        if(returnStatus == 0) {
            logger.fatal("LOD $lod_new is already in github. Exiting lod creation process")
            System.exit(1)    
        }
        else {
            logger.info("LOD $lod_new not in github. Ready to proceed....")
        }
        logger.info("Creating new lod $lod_new....")
        logger.info("Running command: " + createLodCmd)
        returnStatus = osCmds.shellCommand(createLodCmd, project)
        logger.debug("returnStatus = " + returnStatus)
        if(returnStatus != 0) {
            logger.fatal("Could not create lod $lod_new: Please check the system and try again.")
            System.exit(1)
        }
        else {
// JWS To Do - Incorporate the removal and replacement of the br_ prefix with the v_ prefix for tags consistently
           logger.info("Created new lod $lod_new")
	   def brName = lod_new
           List tagSubStrings = brName.tokenize('_')
	   def ver
           ver = tagSubStrings[1]
           def verTag = "v_" + ver
// JWS Removing first build id from initial tag to allow first build to succeed.
//           def verTag = "v_" + ver + "_1"
           logger.info("Created initial version tag marking branch start = $verTag")

	   def initTagCmd = "git tag ${verTag}"
	   def pushInitTagCmd = "git push --tags"
	   logger.debug("initTagCmd = ${initTagCmd}  pushInitTagCmd = ${pushInitTagCmd}")
	   osCmds.shellCommand(initTagCmd, project) 
	   osCmds.shellCommand(pushInitTagCmd, project)
        }
    }

    def createBuildLod( String project, String lod_src, String lod_new ) {

        def logger = Log4j.getLogger(this.class)
        def returnStatus
        def OsCommands osCmds = new OsCommands()
        def projectDir = new File(project)
        if(!projectDir.exists()) {
            logger.fatal("The git project $project does not exist. Please make sure you pass in the correct name as it appears in git.")
            System.exit(1)
        }
        checkout( project, lod_src )
        def verifyLodNewRemoteCmd = "git branch -r | grep $lod_new"
        //def createLodCmd = "git branch $lod_new"
        def createLodCmd = "git push origin origin/$lod_src:refs/heads/$lod_new"
        def pushLodCmd = "git push origin $lod_new"
        logger.info("Checking to see if new lod has already been created....")
        logger.info("Running command: " + verifyLodNewRemoteCmd)
        returnStatus = osCmds.shellCommand(verifyLodNewRemoteCmd, project)
        if(returnStatus == 0) {
            logger.fatal("LOD $lod_new is already in github. Exiting lod creation process")
            System.exit(1)
        }
        else {
            logger.info("LOD $lod_new not in github. Ready to proceed....")
        }
        logger.info("Creating new lod $lod_new....")
        logger.info("Running command: " + createLodCmd)
        returnStatus = osCmds.shellCommand(createLodCmd, project)
        logger.debug("returnStatus = " + returnStatus)
        if(returnStatus != 0) {
            logger.fatal("Could not create lod $lod_new: Please check the system and try again.")
            System.exit(1)
        }
        else {
// JWS To Do - Incorporate the removal and replacement of the br_ prefix with the v_ prefix for tags consistently
           logger.info("Created new lod $lod_new")
           def brName = lod_new
           List tagSubStrings = brName.tokenize('_')
           def ver
           ver = tagSubStrings[1]
           def verTag = "v_" + ver + "_1"
           logger.info("Created initial version tag marking branch start = $verTag")

           def initTagCmd = "git tag ${verTag}"
           def pushInitTagCmd = "git push --tags"
           logger.debug("initTagCmd = ${initTagCmd}  pushInitTagCmd = ${pushInitTagCmd}")
           osCmds.shellCommand(initTagCmd, project)
           osCmds.shellCommand(pushInitTagCmd, project)
        }
    }


    def getRepositories(String project) {
        
        def logger = Log4j.getLogger(this.class)
        def returnStatus
        def OsCommands osCmds = new OsCommands()
        def config
        if(System.getenv("SCM_CONFIG") && new File(System.getenv("SCM_CONFIG")).exists()) {
            logger.debug("SCM_CONFIG variable defined. Getting config info now...")
            config = new ConfigSlurper().parse(new File(System.getenv("SCM_CONFIG")).toURL())
        }
        else {
            logger.fatal("SCM_CONFIG variable not defined. Cannot get config info...")
        }
        
        def gitUser = config.github.user
        def gitToken = config.github.token
        def curlPrefix = config.github.curl_prefix
        def getReposUrl = config.github.getRepos_url
        def getRepoInfoUri = config.github.getRepoInfo_uri
        def resultMapOrig = [:]
        def resultMapNew = [:]
        def reposMap = [:]
        def reposNames = [:]
        def command
        def jsonString

        // first, get list of all canoe ventures repositories

        command = curlPrefix + " \"" + gitUser + "/token:" + gitToken + "\" " + getReposUrl + " | jsonpretty"
        logger.debug("Getting repositories by running the following command = " + command)
        resultMapOrig = osCmds.shellCommandNew(command, project, 1, 1)
        String tmpString
        String mapString = ""
        resultMapOrig.each { val ->
            tmpString = "$val" 
            mapString = mapString + tmpString
        }
        println mapString
        System.exit(1)

        reposMap = resultMap.get("repositories")
        reposNames = reposMap.get("name")
        reposNames.each { println "$it" }
         
        System.exit(1)

    }

    def getLodsForProject( String project ) {
         
        def logger = Log4j.getLogger(this.class)
        def returnStatus
        def OsCommands osCmds = new OsCommands()
/*
        def projectDir = new File(project)
        if(!projectDir.exists()) {
            logger.fatal("The git project $project does not exist. Please make sure you pass in the correct name as it appears in git.")
            System.exit(1)
        }
*/
        
        def lodPrefix = "br_"
        def output = []
        def gitFetchCmd = "git fetch"
        def getRemoteLodsCmd = "git branch -r | grep $lodPrefix | grep -v review | cut -d '/' -f2"
        logger.info("Updating local metadata to prep for lod check....")
        logger.info("Running command: " + gitFetchCmd)
        osCmds.shellCommand(gitFetchCmd, project)
        logger.info("Getting list of remote lods for project $project....")
        logger.info("Running command: " + getRemoteLodsCmd)
        //returnStatus = osCmds.shellCommand(getRemoteLodsCmd, project)
        output = osCmds.shellCommand(getRemoteLodsCmd, project, 0, 1)
        output.each { println "$it".trim() }
        /*
        if(returnStatus != 0) {
            logger.fatal("Could not get list of lods for project $project.")
            System.exit(1)
        }
        */
    }

    def getTagsForProject( String project ) {

        def logger = Log4j.getLogger(this.class)
        def returnStatus
        def OsCommands osCmds = new OsCommands()
/*
        def projectDir = new File(project)
        if(!projectDir.exists()) {
            logger.fatal("The git project $project does not exist. Please make sure you pass in the correct name as it appears in gi
t.")
            System.exit(1)
        }
*/

	def tagPrefix = "r"
        def output = []
        def gitFetchCmd = "git fetch"
        def getRemoteTagsCmd = "git tag -l | grep $tagPrefix | grep -v review | cut -d '/' -f2"
        logger.info("Updating local metadata to prep for tag check....")
        logger.info("Running command: " + gitFetchCmd)
        osCmds.shellCommand(gitFetchCmd, project)
        logger.info("Getting list of remote lods for project $project....")
        logger.info("Running command: " + getRemoteTagsCmd)
        //returnStatus = osCmds.shellCommand(getRemoteLodsCmd, project)
        output = osCmds.shellCommand(getRemoteTagsCmd, project, 0, 1)
        output.each { println "$it".trim() }
        /*
        if(returnStatus != 0) {
            logger.fatal("Could not get list of tags for project $project.")
            System.exit(1)
        }
        */
    }

    def checkout( String project, String lod ) {

        def logger = Log4j.getLogger(this.class)
        def returnStatus
        def OsCommands osCmds = new OsCommands()
        def checkoutRemoteCmd = "git checkout -b $lod origin/$lod"
        def checkoutLocalCmd = "git checkout $lod"
        def gitFetchCmd = "git fetch"
        def gitResetCmd = "git reset --hard"
        def pullCmd = "git pull origin $lod"
        def getLocalBranchListCmd = "git branch | grep $lod"
         
        logger.info("Checking to see if we have the lod checked out locally....")
        logger.info("Running command: " + getLocalBranchListCmd)
        returnStatus = osCmds.shellCommand(getLocalBranchListCmd, project)
        logger.debug("returnStatus = " + returnStatus)
        if(returnStatus != 0) {
            logger.info("LOD $lod was not found locally. Trying remote checkout...")
            // do a git fetch first to get any meta-data for new branches from github
            logger.info("Running command: " + gitFetchCmd)
            osCmds.shellCommand(gitFetchCmd, project)
            logger.info("Reset to ensure no local modifications: " + gitResetCmd)
            osCmds.shellCommand(gitResetCmd, project,1)

            returnStatus = osCmds.shellCommand(checkoutRemoteCmd, project)
            if( returnStatus != 0) {
                logger.fatal("LOD $lod is not in github. Check the name and try again.")
                System.exit(returnStatus)
            }
        }
        logger.info("LOD $lod was found locally. Now do a fetch, then switch to that branch...")
        // do a git fetch first to get any meta-data for new tags from github
        logger.info("Running command: " + gitFetchCmd)
        osCmds.shellCommand(gitFetchCmd, project)
        logger.info("Reset to ensure no local modifications: " + gitResetCmd)
        osCmds.shellCommand(gitResetCmd, project,1)
        logger.info("Running command: " + checkoutLocalCmd)
        returnStatus = osCmds.shellCommand(checkoutLocalCmd, project)
        if(returnStatus == 0) {
            logger.info("Ready to bring down changes: " + pullCmd)
            osCmds.shellCommand(pullCmd, project,1)
        }
    } 

    def checkoutSnapshot( String project, String snapshot, String workspaceRoot ) {
        def logger = Log4j.getLogger(this.class)
        def returnStatus
        def OsCommands osCmds = new OsCommands()
        def gitHubProjUrl = this.gitHubUri+"/"+project+".git"
        logger.debug("project github url = $gitHubProjUrl")
        logger.debug("project snapshot = $snapshot")
        logger.debug("project workspace = $workspaceRoot")
        def gitCloneCmd = "git clone $gitHubProjUrl"
        def checkoutSnapshotCmd = "git checkout " + snapshotPrefix + snapshot
        def workspace = workspaceRoot + "/" + project
        logger.debug("checkout snapshot command = $checkoutSnapshotCmd")
        osCmds.shellCommand(gitCloneCmd, workspaceRoot)
        osCmds.shellCommand(checkoutSnapshotCmd, workspace)
    }

    /*
    more robust branch checking
    - do a 'git branch | grep "* lodName"' if status = 0, you're on the right lod - do a pull. If status = 1, do next command
    - do a 'git branch | grep lodName' - put into list. If lod in list, do 'git checkout lod' then do a pull. If lod not in list, do next command
    - do a 'git checkout -b lodName origin/lodName' - check for error messages (status != 0). If status = 0, you're good to go. Otherwise, fail
    */

}

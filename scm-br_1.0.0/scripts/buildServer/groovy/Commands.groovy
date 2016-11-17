import java.lang.Object
import canoe.alm.git.ScmRepo
import canoe.alm.scm.Snapshot
import canoe.alm.utils.*
import canoe.alm.cie.JenkinsUtils
import java.lang.Runtime
import java.lang.Process

class GenericCommand {

    static final scmBaseDirGroovy = "/opt/build/scm/scripts/buildServer/groovy"
    static final tmpDir = "/opt/build/tempDirs"
    static final gitHubUri = "git@github.com:CanoeVentures"
    static final propsBaseDir = ".." + File.separator + "properties" + File.separator + "projects"
    def GenericCommand() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("in GenericCommand constructor...")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def exec() {
        this.run() 
    }

    def verifyArgs(args) {

    }

    def verifyOptions(options) {

    }

    def setGlobalOptions(options) {
        this.logger.debug("in setGlobalOptions")
        this.globalOptions = options 
        this.logger.debug("globalOptions = $options")
    }
}

public static commandFactory(String command) {
    return dynamicClassInstantiator("$command")
}

public static dynamicClassInstantiator(Object classname) {
    return Class.forName("$classname",true, Thread.currentThread().contextClassLoader).newInstance() 
}

class CreateRelease extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = [ 'CreateSnapshot', 'LiquibaseGenChgLog', 'CreateReleaseTars' ]
    def requiredOptions = [ 'LOCAL_DIR', 'LOD', 'RELEASE_TARS_DIR' ]
    def commandObjects = [:]
    def logger

    def CreateRelease() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateRelease default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateRelease....")
        def projectName = this.globalOptions.get("PROJECT")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        def lod = this.globalOptions.get("LOD")
	def build_number = this.globalOptions.get("BUILD_NUMBER")
        def buildNo = this.globalOptions.get("BUILD_NUMBER")
	//this.logger.debug("build_number=${build_number}")
	def lastBuildno 
	lastBuildno = Integer.parseInt(build_number)-1
	//this.logger.debug("Last build_number=${lastBuildno}")
        String[] buildCmds = this.globalOptions.get("BUILD_ARGS")
        this.globalOptions.put("CHECKOUT", "false")
        def repo = new ScmRepo()
        def osCmds = new OsCommands()
	def cleanTarget = "rm target/*.war*"
        // get the latest code so we can build
        repo.checkout( project, lod )

        File appPropsFile = new File(project + File.separator + "application.properties")

        if(appPropsFile.exists()) {
            // grab the next snapshot and put in application.properties
//  New Grails app snapshot inclusiong with "v" prefix
           def nextSnapshot = repo.getBrVer( project, lod )
           this.logger.debug("next Snapshot = $nextSnapshot")
           nextSnapshot = nextSnapshot + "_" + buildNo
           this.logger.debug("Snapshot = $nextSnapshot")
            def matcher
            def appVersionRegEx = /app.version=(.*)/
//  End Grails app snapshot changes
            def appProps = appPropsFile.text
            matcher = (appProps =~ appVersionRegEx)
            if(matcher.size() > 0) {
                def matchKey = matcher[0][0]
                appProps = appProps.replaceAll(matchKey, "app.version=${nextSnapshot}")
                appPropsFile.write(appProps) 
		logger.info("Finished build_number string-sub for version: ${build_number} information in application.properties")
                logger.info("Finished string-sub for version: ${nextSnapshot} information in application.properties")
            }
            else {
                logger.warn("Running grails app, but no app.version was found in application.properties. Make sure this entry exists so that the version info can get into the war.")
            }
        }
        else {
            logger.debug("no application.properties found")
        }

	// Clean target dir
	logger.info("Cleaning the target dir of old .war files...")
	osCmds.shellCommand( cleanTarget, project )	
        // do a build
        logger.info("Getting ready to run the build command...")
        String buildCmd
        for (int i = 0; i < buildCmds.length; i++) {
            buildCmd = buildCmds[i]
            osCmds.shellCommand( buildCmd, project, 1 )
            logger.debug("Running command: " + buildCmd + " for project: " + project)
        }
        logger.info("Finished running grails build...")

        this.commandObjects["CreateSnapshot"].setGlobalOptions(this.globalOptions)
        this.commandObjects["CreateSnapshot"].exec()

        def propsPackageFile = super.propsBaseDir + File.separator + projectName + File.separator + "project.properties"
        def packageConfig = new ConfigSlurper().parse(new File(propsPackageFile).toURL())
	def ChgLogUpd = packageConfig.database.liquibase.update_chglog
        this.logger.debug("ChgLogUpd = ${ChgLogUpd}...")

        if(ChgLogUpd == "true") {
           //this.logger.debug("ChgLogUpd = ${ChgLogUpd}...")
           this.logger.debug("Getting ready to create the ChangeLog for Liquibase in ${packageConfig.database.liquibase.change_log_dir}...")
           this.commandObjects["LiquibaseGenChgLog"].setGlobalOptions(this.globalOptions)
           this.commandObjects["LiquibaseGenChgLog"].exec()
           this.logger.debug("LiquibaseGenChgLog Finished...")
	}
        logger.info("Getting ready to create the release tars...")
        this.commandObjects["CreateReleaseTars"].setGlobalOptions(this.globalOptions)
        this.commandObjects["CreateReleaseTars"].exec()
        logger.info("CreateRelease Finished...")
    }
}
class CreateJenkinsPackage extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'LOCAL_DIR', 'LOD' ]
    def commandObjects = [:]
    def logger
    def capTagCmd

//JWS331    def CreateSnapshot() {
//JWS331        this.logger=Log4j.getLogger(this.class)
//JWS331        this.logger.debug("CreateSnapshot default constructor")
//JWS331        for( command in this.commandsUsed ) {
//JWS331            this.commandObjects[command] = Commands.commandFactory( command )
//JWS331        }
//JWS331    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateJenkinsRelease....")
        def projectName = this.globalOptions.get("PROJECT")
        def lod = this.globalOptions.get("LOD")
        def buildNo = this.globalOptions.get("BUILD_NUMBER")
        def lastBuildno
        lastBuildno = Integer.parseInt(buildNo)-1
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        def doCheckout = this.globalOptions.get("CHECKOUT")
        def updateJira = this.globalOptions.get("UPDATE_JIRA")
        logger.debug("DoCheckout = $doCheckout")
        logger.debug("Update Jira = $updateJira")
        def repo = new ScmRepo()
        def osCmds = new OsCommands()

        def nextSnapshot = repo.getBrVer( project, lod )
        def vernoprefix = nextSnapshot + "_" + buildNo
//JWS331        this.logger.debug("current Snapshot = $nextSnapshot")
//JWS331        def currentSnapshot = repo.getLatestSnapshotName( project, lod )
//JWS331       nextSnapshot = "v_" + nextSnapshot + "_" + buildNo
//JWS331       this.logger.debug("Snapshot = Prior: $currentSnapshot and Current: $nextSnapshot")
//JWS331        String gitLogCmd

        // if first snapshot, need to get log history for entire lod
//JWS331        if( nextSnapshot == lod +"_1" ) {
//JWS331            gitLogCmd = "echo \"first snapshot\" > RELNOTES.txt"
//JWS331        }
//JWS331        else {
//JWS331            gitLogCmd = "git log --reverse --pretty=\"  * %s\" $currentSnapshot..HEAD > RELNOTES.txt"
//JWS331        }

//JWS331        this.logger.debug("getting log output for annotated tag: " + gitLogCmd)
//JWS331       osCmds.shellCommand( gitLogCmd, project )
//JWS331       File logFile = new File("$project/RELNOTES.txt")
//JWS331        String logString = logFile.getText()

//JWS331        String gitSignedTagCmd = "./signedTag.sh $nextSnapshot " + this.globalOptions.get("PROJECT")
//JWS331        this.logger.debug("creating snapshot for $project: " + gitSignedTagCmd)
//JWS331        osCmds.shellCommand( gitSignedTagCmd, "bin" )
//JWS331        // Remove the RELNOTES.txt file
//JWS331        String rmRelNotesCmd = "rm RELNOTES.txt"
//JWS331        osCmds.shellCommand( rmRelNotesCmd, project )

//JWS331        String gitPushTagCmd = "git push --tags"
//JWS331        this.logger.debug("pushing tag to github: " + gitPushTagCmd)
//JWS331        osCmds.shellCommand( gitPushTagCmd, project )
        // put the new snapshot in the options
//        this.globalOptions.put( "LATEST_SNAPSHOT", nextSnapshot )
        updateJira = "true"
        // -JWS if(updateJira == "true" && nextSnapshot != lod +"_1") {
        // -JWS    UpdateJiraTicketsWithSnapshot(logString, nextSnapshot, this.logger, projectName)
        // -JWS }


        def releaseTarsDir = this.globalOptions.get("RELEASE_TARS_DIR")
        def releaseTarName = this.globalOptions.get("RELEASE_TAR_NAME")
        def stagingDir = "$releaseTarsDir/" + this.globalOptions.get("PROJECT") + "/tmp/staging"
        def tarAppDefined = this.globalOptions.get("TAR_APP")
        def tarApp = "TRUE"
        if( tarAppDefined.equals("FALSE")) {
            tarApp = "FALSE"
        }
        def propsPackageFile = super.propsBaseDir + File.separator + projectName + File.separator + "project.properties"
        def packageConfig
        packageConfig = new ConfigSlurper().parse(new File(propsPackageFile).toURL())
        def artifactNames = []
        def location = []
        // Start of Pre-pkg command addition
        def prePkgCmds
        def postPkgCmds = []
        prePkgCmds = packageConfig.build_package?.pre_pkg_cmds
        this.logger.debug("prePkgCmds = ${prePkgCmds}")
        if(prePkgCmds.size() < 1) {
            this.logger.debug("No pre-package commands to run....")
        }
        else {
// Beginning of Maven Pre-Pkg additions
        File appPropsFile1 = new File(project + File.separator + "pom.xml")
        this.logger.debug("appPropsFile1 = $appPropsFile1")
        if(appPropsFile1.exists()) {
           def pomver = repo.getBrVer( project, lod )
           pomver = pomver + "_" + buildNo
           this.logger.debug("pomver = $pomver")
           def scriptName
           def binFile
           scriptName = "${packageConfig.build_package.artifacts.location.bin}/package.bash"
           binFile = packageConfig.build_package.artifacts.name.bin
           this.logger.debug("scriptName = $scriptName  binFile = $binFile")
           String packageTemp = """
#! /bin/bash
distDir=dist
rm -rf \$distDir
mkdir \$distDir

cp ${binFile} \$distDir/${binFile}

cd \$distDir
jar xf ${binFile} META-INF/MANIFEST.MF
export IMP_LINE=`cat META-INF/MANIFEST.MF | awk '/Implementation-Version/ {print}'`
export APP_VERSION=`cat META-INF/MANIFEST.MF | awk -F":" '/Implementation-Version/ {print \$2}'`
echo "\$APP_VERSION"
sed -e "s|Implementation-Version: \$APP_VERSION|Implementation-Version: ${pomver}|" -i '' META-INF/MANIFEST.MF
sed -e "s|Implementation-Version:\$APP_VERSION|Implementation-Version: ${pomver}|" -i '' META-INF/MANIFEST.MF
jar Muf ${binFile} META-INF/MANIFEST.MF
cat META-INF/MANIFEST.MF
#rm -rf META-INF
cp ${binFile} ..
"""
        File writescriptName = new File("$scriptName")
        writescriptName.write("${packageTemp}")
        println writescriptName
        }
        else {
           logger.debug("no pom.xml found")
        }
//  End of Maven Pre-Pkg additions
            this.logger.debug("Found " + prePkgCmds.size() + " pre-deploy commands to run....")
            prePkgCmds.each() { key, value ->
                this.logger.debug("command name = $key")
                this.logger.debug("command value = $value")
                osCmds.shellCommand( value, project )
            }
        }
        // End of Pre-pkg command addition

        if(tarApp.equals("TRUE")) {
            def commonTargetDir = packageConfig.commonTargetRoot
            String mkDir = "mkdir -p $releaseTarsDir/" + this.globalOptions.get("PROJECT")
            osCmds.shellCommand( mkDir, project )
            mkDir = "mkdir -p $stagingDir"
            osCmds.shellCommand( mkDir, project )
// Beginning of ReleaseTar naming change
// Attempt to place the buildNo and lod together .vs. checking for a snapshot which sorts incorrectly
            String tarName = releaseTarName + "_" + vernoprefix + ".tar"
//  Below is original and working
//            String tarName = releaseTarName + "_" + snapshotName + ".tar"
// End of ReleaseTar naming change
            this.logger.debug("Tar Name= " + tarName + " ....")
            String copyCmd
            artifactNames = packageConfig.build_package.artifacts.name
            location = packageConfig.build_package.artifacts.location
            def artifactName
            def artifactSrcDir
            artifactNames.each() { key, value ->
                this.logger.debug("key = $key")
                this.logger.debug("value = $value")
                artifactName = value
                artifactSrcDir = location.get(key, null)
                this.logger.debug("copying $artifactSrcDir/$artifactName to staging dir....")
                copyCmd = "cp -r $artifactSrcDir/$artifactName $stagingDir"
                osCmds.shellCommand( copyCmd, project )
            }
            String tarCmd = "tar cvf $tarName *"
            String copyTarCmd = "cp $tarName $releaseTarsDir/" + this.globalOptions.get("PROJECT")
            osCmds.shellCommand( tarCmd, stagingDir )
            osCmds.shellCommand( copyTarCmd, stagingDir )
            osCmds.shellCommand( "rm -rf $stagingDir", project )
            logger.info("Finished creating the release tar: Download from this link:")
            logger.info("http://cvbuild.cv.infra/releaseTars/$projectName/$tarName")
            logger.info("")
            logger.info("For all $projectName releases: http://cvbuild.cv.infra/releaseTars/$projectName.")
            logger.info("")
        }
   }
}

class CreateJenkinsRelease extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'LOCAL_DIR', 'LOD' ]
    def commandObjects = [:]
    def logger
    def capTagCmd
    
    def CreateSnapshot() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateSnapshot default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateJenkinsRelease....")
        def projectName = this.globalOptions.get("PROJECT")
	def lod = this.globalOptions.get("LOD")
	def buildNo = this.globalOptions.get("BUILD_NUMBER")
	def lastBuildno
	lastBuildno = Integer.parseInt(buildNo)-1
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        def doCheckout = this.globalOptions.get("CHECKOUT")
        def updateJira = this.globalOptions.get("UPDATE_JIRA")
        logger.debug("DoCheckout = $doCheckout")
        logger.debug("Update Jira = $updateJira")
        def repo = new ScmRepo()
        def osCmds = new OsCommands()

        def nextSnapshot = repo.getBrVer( project, lod ) 
        def vernoprefix = nextSnapshot + "_" + buildNo
        this.logger.debug("current Snapshot = $nextSnapshot")
        def currentSnapshot = repo.getLatestSnapshotName( project, lod ) 
	nextSnapshot = "v_" + nextSnapshot + "_" + buildNo
        this.logger.debug("Snapshot = Prior: $currentSnapshot and Current: $nextSnapshot")
        String gitLogCmd

        // if first snapshot, need to get log history for entire lod
        if( nextSnapshot == lod +"_1" ) {
            gitLogCmd = "echo \"first snapshot\" > RELNOTES.txt"
        }
        else {
            gitLogCmd = "git log --reverse --pretty=\"  * %s\" $currentSnapshot..HEAD > RELNOTES.txt"
        }

        this.logger.debug("getting log output for annotated tag: " + gitLogCmd)
        osCmds.shellCommand( gitLogCmd, project )
        File logFile = new File("$project/RELNOTES.txt")
        String logString = logFile.getText()

        String gitSignedTagCmd = "./signedTag.sh $nextSnapshot " + this.globalOptions.get("PROJECT")
        this.logger.debug("creating snapshot for $project: " + gitSignedTagCmd)
        osCmds.shellCommand( gitSignedTagCmd, "bin" )
        // Remove the RELNOTES.txt file
        String rmRelNotesCmd = "rm RELNOTES.txt"
        osCmds.shellCommand( rmRelNotesCmd, project )

        String gitPushTagCmd = "git push --tags"
        this.logger.debug("pushing tag to github: " + gitPushTagCmd)
        osCmds.shellCommand( gitPushTagCmd, project )
        // put the new snapshot in the options
        this.globalOptions.put( "LATEST_SNAPSHOT", nextSnapshot )
        updateJira = "true"
        // -JWS if(updateJira == "true" && nextSnapshot != lod +"_1") {
        // -JWS    UpdateJiraTicketsWithSnapshot(logString, nextSnapshot, this.logger, projectName)
        // -JWS }
    

        def releaseTarsDir = this.globalOptions.get("RELEASE_TARS_DIR")
        def releaseTarName = this.globalOptions.get("RELEASE_TAR_NAME")
        def stagingDir = "$releaseTarsDir/" + this.globalOptions.get("PROJECT") + "/tmp/staging"
        def tarAppDefined = this.globalOptions.get("TAR_APP")
        def tarApp = "TRUE"
        if( tarAppDefined.equals("FALSE")) {
            tarApp = "FALSE"
        }
        def propsPackageFile = super.propsBaseDir + File.separator + projectName + File.separator + "project.properties"
        def packageConfig
        packageConfig = new ConfigSlurper().parse(new File(propsPackageFile).toURL())
        def artifactNames = []
        def location = []
	// Start of Pre-pkg command addition
        def prePkgCmds 
        def postPkgCmds = []
	prePkgCmds = packageConfig.build_package?.pre_pkg_cmds
	this.logger.debug("prePkgCmds = ${prePkgCmds}")
        if(prePkgCmds.size() < 1) {
            this.logger.debug("No pre-package commands to run....")
        }
        else {
// Beginning of Maven Pre-Pkg additions
        File appPropsFile1 = new File(project + File.separator + "pom.xml")
	this.logger.debug("appPropsFile1 = $appPropsFile1")
        if(appPropsFile1.exists()) {
           def pomver = repo.getBrVer( project, lod )
           pomver = pomver + "_" + buildNo
           this.logger.debug("pomver = $pomver")
           def scriptName
	   def binFile
	   scriptName = "${packageConfig.build_package.artifacts.location.bin}/package.bash"
	   binFile = packageConfig.build_package.artifacts.name.bin
           this.logger.debug("scriptName = $scriptName  binFile = $binFile")
	   String packageTemp = """
#! /bin/bash
distDir=dist
rm -rf \$distDir
mkdir \$distDir

cp ${binFile} \$distDir/${binFile}

cd \$distDir
jar xf ${binFile} META-INF/MANIFEST.MF
sed -e "s|@@VERSION_NUMBER@@|${pomver}|" -i '' META-INF/MANIFEST.MF
jar uf ${binFile} META-INF/MANIFEST.MF
jar umf META-INF/MANIFEST.MF ${binFile}
cat META-INF/MANIFEST.MF
#rm -rf META-INF
cp ${binFile} ..
"""
        File writescriptName = new File("$scriptName")
        writescriptName.write("${packageTemp}")
        println writescriptName
        }
        else {
           logger.debug("no pom.xml found")
        }
//  End of Maven Pre-Pkg additions
            this.logger.debug("Found " + prePkgCmds.size() + " pre-deploy commands to run....")
            prePkgCmds.each() { key, value ->
                this.logger.debug("command name = $key")
                this.logger.debug("command value = $value")
		osCmds.shellCommand( value, project )
            }
        }
	// End of Pre-pkg command addition

        if(tarApp.equals("TRUE")) {
            def commonTargetDir = packageConfig.commonTargetRoot
            String mkDir = "mkdir -p $releaseTarsDir/" + this.globalOptions.get("PROJECT")
            osCmds.shellCommand( mkDir, project )
            mkDir = "mkdir -p $stagingDir"
            osCmds.shellCommand( mkDir, project )
// Beginning of ReleaseTar naming change
// Attempt to place the buildNo and lod together .vs. checking for a snapshot which sorts incorrectly
            String tarName = releaseTarName + "_" + vernoprefix + ".tar"
//  Below is original and working
//            String tarName = releaseTarName + "_" + snapshotName + ".tar"
// End of ReleaseTar naming change
            this.logger.debug("Tar Name= " + tarName + " ....")
            String copyCmd
            artifactNames = packageConfig.build_package.artifacts.name 
            location = packageConfig.build_package.artifacts.location
            def artifactName
            def artifactSrcDir
            artifactNames.each() { key, value ->
                this.logger.debug("key = $key")
                this.logger.debug("value = $value")
                artifactName = value
                artifactSrcDir = location.get(key, null) 
                this.logger.debug("copying $artifactSrcDir/$artifactName to staging dir....")
                copyCmd = "cp -r $artifactSrcDir/$artifactName $stagingDir" 
                osCmds.shellCommand( copyCmd, project )
            }
            String tarCmd = "tar cvf $tarName *"
            String copyTarCmd = "cp $tarName $releaseTarsDir/" + this.globalOptions.get("PROJECT")
            osCmds.shellCommand( tarCmd, stagingDir )
            osCmds.shellCommand( copyTarCmd, stagingDir )
            osCmds.shellCommand( "rm -rf $stagingDir", project )
	    logger.info("Finished creating the release tar: Download from this link:")
            logger.info("http://cvbuild.cv.infra/releaseTars/$projectName/$tarName") 
	    logger.info("")
	    logger.info("For all $projectName releases: http://cvbuild.cv.infra/releaseTars/$projectName.")
            logger.info("")
        }
   }
}


class CreateSnapshot extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'LOCAL_DIR', 'LOD' ]
    def commandObjects = [:]
    def logger
    def capTagCmd
    
    def CreateSnapshot() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateSnapshot default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateSnapshot....")
        def projectName = this.globalOptions.get("PROJECT")
	def lod = this.globalOptions.get("LOD")
	def buildNo = this.globalOptions.get("BUILD_NUMBER")
	def lastBuildno
	lastBuildno = Integer.parseInt(buildNo)-1
	//this.logger.debug("Jenkins Tag - v_${lod}_${buildNo}")
        //this.logger.debug("3rd build_number=${buildNo}")
        //this.logger.debug("3rd Last build_number=${lastBuildno}")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        def doCheckout = this.globalOptions.get("CHECKOUT")
        def updateJira = this.globalOptions.get("UPDATE_JIRA")
        logger.debug("DoCheckout = $doCheckout")
        logger.debug("Update Jira = $updateJira")
        def repo = new ScmRepo()
        def osCmds = new OsCommands()
// JWS	def currentSnapshot
// JWS	currentSnapshot = ("v_" + ${lod} + "_" + ${buildNo})
// JWS  Old Snapshot method with br_ prefix.   def currentSnapshot = repo.getLatestSnapshotName( project, lod )
        def nextSnapshot = repo.getBrVer( project, lod ) 
        this.logger.debug("current Snapshot = $nextSnapshot")
        def currentSnapshot = repo.getLatestSnapshotName( project, lod ) 
//	def currentSnapshot = nextSnapshot + "_" + lastBuildno
	nextSnapshot = "v_" + nextSnapshot + "_" + buildNo
        this.logger.debug("Snapshot = Prior: $currentSnapshot and Current: $nextSnapshot")
        if( doCheckout == "true" ) {
            repo.checkout( project, lod )
        }
        String gitLogCmd
        // if first snapshot, need to get log history for entire lod
        if( nextSnapshot == lod +"_1" ) {
            gitLogCmd = "echo \"first snapshot\" > RELNOTES.txt"
        }
        else {
            gitLogCmd = "git log --reverse --pretty=\"  * %s\" $currentSnapshot..HEAD > RELNOTES.txt"
        }

        this.logger.debug("getting log output for annotated tag: " + gitLogCmd)
        osCmds.shellCommand( gitLogCmd, project )
        File logFile = new File("$project/RELNOTES.txt")
        String logString = logFile.getText()

        // TAG Capturing the tag into a file
        //String capTagCmd 
	//capTagCmd = "echo $nextSnapshot > TAGFILE.txt"
        //File tagFile = new File("$project/TAGFILE.txt")
        //String tagString = tagFile.getText()
	//this.logger.debug("inserting tag into tagfile: " + capTagCmd)
        // TAG osCmds.shellCommand( capTagCmd, project )

        //String gitTagCmd = "git tag -F RELNOTES.txt $nextSnapshot"
        String gitSignedTagCmd = "./signedTag.sh $nextSnapshot " + this.globalOptions.get("PROJECT")
        //this.logger.debug("creating snapshot for $project: " + gitTagCmd)
        this.logger.debug("creating snapshot for $project: " + gitSignedTagCmd)
        //osCmds.shellCommand( gitTagCmd, project )
        osCmds.shellCommand( gitSignedTagCmd, "bin" )

        // - JWS String rmRelNotesCmd = "rm RELNOTES.txt"
        // - JWS osCmds.shellCommand( rmRelNotesCmd, project )
        // - JWS String rmTagFileCmd = "rm TAGFILE.txt"
        // - JWS osCmds.shellCommand( rmTagFileCmd, project )

        String gitPushTagCmd = "git push --tags"
        this.logger.debug("pushing tag to github: " + gitPushTagCmd)
        osCmds.shellCommand( gitPushTagCmd, project )
        // put the new snapshot in the options
        this.globalOptions.put( "LATEST_SNAPSHOT", nextSnapshot )
        updateJira = "true"
        // -JWS if(updateJira == "true" && nextSnapshot != lod +"_1") {
        // -JWS    UpdateJiraTicketsWithSnapshot(logString, nextSnapshot, this.logger, projectName)
        // -JWS }
    }

    def UpdateJiraTicketsWithSnapshot(String log, String snapshot, def logger, def project) {

        logger.debug("In UpdateJiraTicketsWithSnapshot")
        def jiraUtils = new JiraUtils()
        def jiraTix = [:] 
        def matcher
        def tixRegEx = /([a-zA-Z]+-\d+(?:\.\d+)*)/
        matcher = (log =~ tixRegEx)
        for(i in 0..<matcher.count) {
            def matchKey = matcher[i][0]
            jiraTix.put("$matchKey", matcher[i][0].toUpperCase())
        }
        Snapshot mysnapshot = new Snapshot( snapshot )
        def snapshotName = mysnapshot.getNameWithoutPrefix( snapshot )
        jiraUtils.setBuildFixedIn(jiraTix, snapshotName, project) 
    }
}

class CreateAntBuildSnapshot extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'LOCAL_DIR', 'LOD' ]
    def commandObjects = [:]
    def logger

    def CreateSnapshot() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateSnapshot default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateSnapshot....")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        def projectName = this.globalOptions.get("PROJECT")
        def lod = this.globalOptions.get("LOD")
        def doCheckout = this.globalOptions.get("CHECKOUT")
        def updateJira = this.globalOptions.get("UPDATE_JIRA")
        logger.debug("Update Jira = $updateJira")
        this.logger.debug("doCheckout = $doCheckout")
        def repo = new ScmRepo()
        def osCmds = new OsCommands()
        def currentSnapshot = repo.getLatestSnapshotName( project, lod )
        this.logger.debug("current Snapshot = $currentSnapshot")
        def nextSnapshot = repo.getNextSnapshotName( project, lod )
        this.logger.debug("next Snapshot = $nextSnapshot")
        repo.checkout( project, lod )

        String gitLogCmd
        // if first snapshot, need to get log history for entire lod
        if( nextSnapshot == lod +"_1" ) {
            gitLogCmd = "echo \"first snapshot\" > RELNOTES.txt"
        }
        else {
            gitLogCmd = "git log --reverse --pretty=\"  * %s\" $currentSnapshot..HEAD > RELNOTES.txt"
        }

        this.logger.debug("getting log output for annotated tag: " + gitLogCmd)
        osCmds.shellCommand( gitLogCmd, project )
        File logFile = new File("$project/RELNOTES.txt")
        String logString = logFile.getText()

        //String gitTagCmd = "git tag -F RELNOTES.txt $nextSnapshot"
        String gitSignedTagCmd = "./signedTag.sh $nextSnapshot " + this.globalOptions.get("PROJECT")
        //this.logger.debug("creating snapshot for $project: " + gitTagCmd)
        this.logger.debug("creating snapshot for $project: " + gitSignedTagCmd)
        //osCmds.shellCommand( gitTagCmd, project )
        osCmds.shellCommand( gitSignedTagCmd, "bin" )

        String rmRelNotesCmd = "rm RELNOTES.txt"
        osCmds.shellCommand( rmRelNotesCmd, project )

        String gitPushTagCmd = "git push --tags"
        this.logger.debug("pushing tag to github: " + gitPushTagCmd)
        osCmds.shellCommand( gitPushTagCmd, project )
        // put the new snapshot in the options
        this.globalOptions.put( "LATEST_SNAPSHOT", nextSnapshot )
        updateJira = "true"
        // -JWS if(updateJira == "true" && nextSnapshot != lod +"_1") {
        // -JWS    UpdateJiraTicketsWithSnapshot(logString, nextSnapshot, this.logger, projectName)
        // -JWS }
    }

    def UpdateJiraTicketsWithSnapshot(String log, String snapshot, def logger, def project) {

        logger.debug("In UpdateJiraTicketsWithSnapshot")
        def jiraUtils = new JiraUtils()
        def jiraTix = [:]
        def matcher
        def tixRegEx = /([a-zA-Z]+-\d+(?:\.\d+)*)/
        matcher = (log =~ tixRegEx)
        for(i in 0..<matcher.count) {
            def matchKey = matcher[i][0]
            jiraTix.put("$matchKey", matcher[i][0].toUpperCase())
        }
        Snapshot mysnapshot = new Snapshot( snapshot )
        def snapshotName = mysnapshot.getNameWithoutPrefix( snapshot )
        jiraUtils.setBuildFixedIn(jiraTix, snapshotName, project)
    }
}

class LiquibaseGenSql extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'PROJECT', 'SNAPSHOT', 'ENVIRONMENT' ]
    def commandObjects = [:]
    def logger

    def LiquibaseGenSql() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("LiquibaseGenSql default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        def osCmds = new OsCommands()
        def repo = new ScmRepo()
        this.logger.debug("In LiquibaseGenSql....")
        def projectName = this.globalOptions.get("PROJECT")
        this.logger.debug("project = $projectName")
        def env = this.globalOptions.get("ENVIRONMENT")
        this.logger.debug("environment = $env")
        def snapshot = this.globalOptions.get("SNAPSHOT")
        def tarName = projectName + "_" + snapshot + ".tar"
        this.logger.debug("Snapshot = $snapshot")
        def releaseTarsDir = this.globalOptions.get("RELEASE_TARS_DIR")
        def propsFile = super.propsBaseDir + File.separator + projectName + File.separator + "project.properties"
        def propsConfig
        def changeLogFile
        def liquibaseBaseDir
        def genSqlCmd
        def sqlUpdatePath = "sql" + File.separator + "env" + File.separator + env
        def projectTmpDir = super.tmpDir + File.separator + projectName +"_" + snapshot
        def projectRoot = projectTmpDir + File.separator + projectName
        def mkUpdateSqlDirCmd = "mkdir -p $releaseTarsDir" + File.separator + "$projectName" + File.separator + sqlUpdatePath
        def cpUpdateSqlCmd = "cp update.sql $releaseTarsDir" + File.separator + "$projectName" + File.separator + sqlUpdatePath
        def appendSqlCmd = "tar --append --file=$tarName $sqlUpdatePath"
        logger.debug("project tmp dir = $projectTmpDir")
        def mkTmpDirCmd = "mkdir $projectTmpDir"
        def rmTmpDirCmd = "rm -rf $projectTmpDir"
        def rmUpdateSqlDirCmd = "rm -rf $releaseTarsDir" + File.separator + "$projectName" + File.separator + "sql"

        // load the project properties we need so we can get the database info necessary for liquibase
        if(new File(propsFile).exists()) {
            propsConfig = new ConfigSlurper().parse(new File(propsFile).toURL())
        }
        else {
            logger.fatal("Project properties file for: $projectName was not found. Please contact SCM (scmteam@canoe-ventures.com) for assistance.")
            System.exit(1)
        } 
        changeLogFile = propsConfig.database.liquibase.change_log_file
        logger.debug("Change log file = $changeLogFile")
        genSqlCmd = propsConfig.database.liquibase.command
        logger.debug("liquibase command = $genSqlCmd")

        //create clean temp dir
        osCmds.shellCommand(mkTmpDirCmd, super.tmpDir)

        //clone repository and checkout the snapshot
        repo.checkoutSnapshot(projectName, snapshot, projectTmpDir)
        //go to project root in workspace so we can run liquibase updateSQL against its changelog
        //if there is a base dir setting in props file, cd to it. Otherwise, just go to project root
        liquibaseBaseDir = propsConfig.database.liquibase.base_dir
        if(liquibaseBaseDir != "") {
            projectRoot += File.separator + liquibaseBaseDir         
        } 
        logger.debug("Project root = $projectRoot")
        // NOTE: THIS IS A TEMP HACK UNTIL DAI SWITCHES OVER TO GRADLE!!!
        if(projectName.equals("Dynamic-Ad-Insertion-core")) {
            osCmds.shellCommand("cp build.gradle $projectRoot", scmBaseDirGroovy + File.separator + "bin")
            logger.debug("project = Dynamic-Ad-Insertion-core, so copying build.gradle to $projectRoot")
        }
        osCmds.shellCommand(genSqlCmd, projectRoot, 1)
        logger.info("Finished generating update sql for env: $env")

        //now cp update.sql file we just generated to the appropriate subdirectory for the environment we ran it against
        logger.debug("path to sql update file = $sqlUpdatePath")
        osCmds.shellCommand(mkUpdateSqlDirCmd, releaseTarsDir, 1)
        logger.debug("Successfully created directory for update.sql: $sqlUpdatePath")
        osCmds.shellCommand(cpUpdateSqlCmd, projectRoot, 1)
        logger.debug("Successfully copied update.sql to: " + releaseTarsDir + File.separator + sqlUpdatePath)
        //now append the update.sql file to the existing release tar
        osCmds.shellCommand(appendSqlCmd, releaseTarsDir + File.separator + projectName, 1)
        logger.info("Successfully appended update.sql for $env env to: $tarName")

        //now let's clean up after ourselves
        logger.debug("Removing temp dir....")
        osCmds.shellCommand(rmTmpDirCmd, super.tmpDir)

        logger.debug("Removing temp directory for update.sql...")
        osCmds.shellCommand(rmUpdateSqlDirCmd, releaseTarsDir)
    }
}
class LiquibaseGenChgLog extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'PROJECT', 'LATEST_SNAPSHOT' ]
    def commandObjects = [:]
    def logger

    def LiquibaseGenChgLog() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("LiquibaseGenChgLog default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        def projectName = this.globalOptions.get("PROJECT")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        def osCmds = new OsCommands()
        def repo = new ScmRepo()
        this.logger.debug("In LiquibaseChgLog....")
        this.logger.debug("project = $projectName")
        def buildNo = this.globalOptions.get("BUILD_NUMBER")
        def lod = this.globalOptions.get("LOD")
        def chgLogVer = repo.getBrVer( project, lod )
        chgLogVer = chgLogVer + "_" + buildNo
        this.logger.debug("current ChangeLogVers = $chgLogVer")
        def snapshot = this.globalOptions.get("LATEST_SNAPSHOT")
        this.logger.debug("Snapshot = $snapshot")
        def propsFile = super.propsBaseDir + File.separator + projectName + File.separator + "project.properties"
        def propsConfig
        def changeLogFile
        def changeLogDir
	def chglogfilename
	def vchgLogDir
	def chglogloc
	def chglogmaster

        // load the project properties we need so we can get the database info necessary for liquibase
        if(new File(propsFile).exists()) {
            propsConfig = new ConfigSlurper().parse(new File(propsFile).toURL())
        }
        else {
            logger.fatal("Project properties file for: $projectName was not found. Please contact SCM (scmteam@canoe-ventures.com) for assistance.")
            System.exit(1)
        }
	// Create this format Changelog file in the original Liquibase development directory

	chglogfilename = "changelog-${snapshot}.xml"
	logger.debug("chglogfilename = $chglogfilename")
        changeLogDir = propsConfig.database.liquibase.change_log_dir
	vchgLogDir = propsConfig.database.liquibase.vchange_log_dir
        logger.debug("Change log dir = $changeLogDir  VChange log dir = $vchgLogDir")
	chglogloc = propsConfig.database.liquibase.change_log_loc
        chglogmaster = propsConfig.database.liquibase.change_log_master
	String tmpmaster = "${changeLogDir}/tmpmaster.xml"

String changelogtemp = """<?xml version=\"1.0\" encoding=\"UTF-8\"?>

<databaseChangeLog xmlns=\"http://www.liquibase.org/xml/ns/dbchangelog\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-2.0.xsd\">

  <changeSet author=\"Release Build\" id=\"${chgLogVer}\">
    <sql>insert into version (version) values ('${chgLogVer}')</sql>

    <rollback>
      <sql>delete from version where version='${chgLogVer}'</sql>
    </rollback>
  </changeSet>
</databaseChangeLog>
"""
	File file = new File("${vchgLogDir}/${chglogfilename}")
	file.write("${changelogtemp}\n")

// Section to add the include statement to changelogs
	String sedChg
        sedChg = "/bin/sed -e \'s#</databaseChangeLog>#<include file=\"version_changelogs/${chglogfilename}\" relativeToChangelogFile=\"true\"/>#g\' ${chglogloc}/${chglogmaster} >${tmpmaster}" 
	osCmds.shellCommand( sedChg, project)
	logger.debug("File sed complete")
	def f
	f = new File("${tmpmaster}")
	logger.debug("tmpmaster identified for change")
	f.append("</databaseChangeLog>\n")
	logger.debug("File appended")
	String mkMasCmd
	mkMasCmd = "cp ${tmpmaster} ${changeLogDir}/${chglogmaster}"
	osCmds.shellCommand( mkMasCmd, project)
	String rmTmpMs
	rmTmpMs = "rm ${tmpmaster}"
	osCmds.shellCommand( rmTmpMs, project)


// End Section

// Section to commit the changes to GitHub repository and move the snapshot tag	
        String gitRmTagCmd
        gitRmTagCmd = "git tag -d ${snapshot}; git push origin :${snapshot}"
        osCmds.shellCommand( gitRmTagCmd, project )
	String gitAdCmd
        gitAdCmd = "cd ${changeLogDir}; git add version_changelogs/${chglogfilename} ${chglogmaster}"
        osCmds.shellCommand( gitAdCmd, project )
        String gitCiCmd
        gitCiCmd = "cd ${changeLogDir}; git commit -a -m \"Adding ${snapshot} liquibase changelog version_changelogs/${chglogfilename} ${chglogmaster}\""
        logger.debug("gitCiCmd = ${gitCiCmd}")
        osCmds.shellCommand( gitCiCmd, project )
	String gitPuCmd
	gitPuCmd = "git push origin"
	osCmds.shellCommand( gitPuCmd, project )
	String gitReTagCmd
	gitReTagCmd = "git tag ${snapshot}"
	osCmds.shellCommand( gitReTagCmd, project )
        String gitPuTaCmd
        gitPuTaCmd = "git push origin ${snapshot}:${snapshot}"
        osCmds.shellCommand( gitPuTaCmd, project )
    }
}


/** 
 * Keeping around for historical purposes. Not needed anymore due to new requirements for all artifacts, including db scripts, to be included in a single tar file.
 */
class CreateDBTar extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = [ ]
    def requiredOptions = [ 'LOCAL_DIR', 'LOD' ]
    def commandObjects = [:]
    def logger

    def CreateDBTar() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateDBTar default constructor..." )
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateDBTar....")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        def lod = this.globalOptions.get("LOD")
        def dbDir = this.globalOptions.get("RESOURCE_DB_DIR")
        def dbName = this.globalOptions.get("RESOURCE_DB_NAME")
        def releaseTarsDir = this.globalOptions.get("RELEASE_TARS_DIR")
        def releaseTarDBName = this.globalOptions.get("RELEASE_TAR_DB_NAME")
        String dbTarResourceDir = "$project/$dbDir"
        def osCmds = new OsCommands()
        def currentSnapshotName = this.globalOptions.get("LATEST_SNAPSHOT")
        Snapshot latestSnapshot = new Snapshot( currentSnapshotName )
        def snapshotName = latestSnapshot.getNameWithoutPrefix( currentSnapshotName )
        String mkDir = "mkdir -p $releaseTarsDir/" + this.globalOptions.get("PROJECT")
        osCmds.shellCommand( mkDir, project )
        String tarDBName = releaseTarDBName + "_" + snapshotName + ".tar"
        String tarDBCmd = "tar cvf $tarDBName $dbName"
        String copyDBTarCmd = "cp $tarDBName $releaseTarsDir/" + this.globalOptions.get("PROJECT")
        osCmds.shellCommand( tarDBCmd, dbTarResourceDir )  
        osCmds.shellCommand( copyDBTarCmd, dbTarResourceDir )
    }
}

class CreateReleaseTars extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'LOCAL_DIR', 'LOD' ]
    def commandObjects = [:]
    def logger
    def repo = new ScmRepo()

    def CreateReleaseTars() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateReleaseTars default constructor...")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateReleaseTars....")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def projectName = this.globalOptions.get("PROJECT")
        def project = path_to_project + "/" + projectName 
        def lod = this.globalOptions.get("LOD")
        def releaseTarsDir = this.globalOptions.get("RELEASE_TARS_DIR")
        def releaseTarName = this.globalOptions.get("RELEASE_TAR_NAME")
        def stagingDir = "$releaseTarsDir/" + this.globalOptions.get("PROJECT") + "/tmp/staging"
        def tarDB = this.globalOptions.get("TAR_DB")
        def tarAppDefined = this.globalOptions.get("TAR_APP")
        def tarApp = "TRUE"
        if( tarAppDefined.equals("FALSE")) {
            tarApp = "FALSE"
        }
        //def propsPackageFile = "../properties/projects/"+projectName+"/package.properties"
        def propsPackageFile = super.propsBaseDir + File.separator + projectName + File.separator + "project.properties"
        def packageConfig
        packageConfig = new ConfigSlurper().parse(new File(propsPackageFile).toURL())
        def artifactNames = []
        def location = []

	// Start of Pre-pkg command addition
        def buildNo = this.globalOptions.get("BUILD_NUMBER")
	def osCmds = new OsCommands()
        def prePkgCmds 
        def postPkgCmds = []
	prePkgCmds = packageConfig.build_package?.pre_pkg_cmds
	this.logger.debug("prePkgCmds = ${prePkgCmds}")
        if(prePkgCmds.size() < 1) {
            this.logger.debug("No pre-package commands to run....")
        }
        else {
// Beginning of Maven Pre-Pkg additions
        File appPropsFile1 = new File(project + File.separator + "pom.xml")
	this.logger.debug("appPropsFile1 = $appPropsFile1")
        if(appPropsFile1.exists()) {
           def pomver = repo.getBrVer( project, lod )
           pomver = pomver + "_" + buildNo
           this.logger.debug("pomver = $pomver")
           def scriptName
	   def binFile
	   scriptName = "${packageConfig.build_package.artifacts.location.bin}/package.bash"
	   binFile = packageConfig.build_package.artifacts.name.bin
           this.logger.debug("scriptName = $scriptName  binFile = $binFile")
	   String packageTemp = """
#! /bin/bash
distDir=dist
rm -rf \$distDir
mkdir \$distDir

cp ${binFile} \$distDir/${binFile}

cd \$distDir
jar xf ${binFile} META-INF/MANIFEST.MF
sed -e "s|@@VERSION_NUMBER@@|${pomver}|" -i '' META-INF/MANIFEST.MF
jar uf ${binFile} META-INF/MANIFEST.MF
jar umf META-INF/MANIFEST.MF ${binFile}
cat META-INF/MANIFEST.MF
rm -rf META-INF
cp ${binFile} ..
"""
        File writescriptName = new File("$scriptName")
        writescriptName.write("${packageTemp}")
        println writescriptName
        }
        else {
           logger.debug("no pom.xml found")
        }
//  End of Maven Pre-Pkg additions
            this.logger.debug("Found " + prePkgCmds.size() + " pre-deploy commands to run....")
            prePkgCmds.each() { key, value ->
                this.logger.debug("command name = $key")
                this.logger.debug("command value = $value")
		osCmds.shellCommand( value, project )
            }
        }
	// End of Pre-pkg command addition

        if(tarApp.equals("TRUE")) {
            def commonTargetDir = packageConfig.commonTargetRoot
            def repo = new ScmRepo()
            def currentSnapshotName = this.globalOptions.get("LATEST_SNAPSHOT")
            if(currentSnapshotName == null)
                currentSnapshotName = repo.getLatestSnapshotName(project, lod)
            println currentSnapshotName
            // strip of leading "br_" prefix
            Snapshot latestSnapshot = new Snapshot( currentSnapshotName )
            def snapshotName = latestSnapshot.getNameWithoutPrefix( currentSnapshotName )
            String mkDir = "mkdir -p $releaseTarsDir/" + this.globalOptions.get("PROJECT")
            osCmds.shellCommand( mkDir, project )
            mkDir = "mkdir -p $stagingDir"
            osCmds.shellCommand( mkDir, project )
// Beginning of ReleaseTar naming change
// Attempt to place the buildNo and lod together .vs. checking for a snapshot which sorts incorrectly
//            String tarName = releaseTarName + "_" + lod + "_" + buildNo + ".tar"
//  Below is original and working
            String tarName = releaseTarName + "_" + snapshotName + ".tar"
// End of ReleaseTar naming change
            String copyCmd
            artifactNames = packageConfig.build_package.artifacts.name 
            location = packageConfig.build_package.artifacts.location
            def artifactName
            def artifactSrcDir
            artifactNames.each() { key, value ->
                this.logger.debug("key = $key")
                this.logger.debug("value = $value")
                artifactName = value
                artifactSrcDir = location.get(key, null) 
                this.logger.debug("copying $artifactSrcDir/$artifactName to staging dir....")
                copyCmd = "cp -r $artifactSrcDir/$artifactName $stagingDir" 
                osCmds.shellCommand( copyCmd, project )
            }
            String tarCmd = "tar cvf $tarName *"
            String copyTarCmd = "cp $tarName $releaseTarsDir/" + this.globalOptions.get("PROJECT")
            osCmds.shellCommand( tarCmd, stagingDir )
            osCmds.shellCommand( copyTarCmd, stagingDir )
            osCmds.shellCommand( "rm -rf $stagingDir", project )
	    logger.info("Finished creating the release tar: Download from this link:")
            logger.info("http://cvbuild.cv.infra/releaseTars/$projectName/$tarName") 
	    logger.info("")
	    logger.info("For all $projectName releases: http://cvbuild.cv.infra/releaseTars/$projectName.")
            logger.info("")
        }
        if(tarDB.equals("TRUE")) {
            logger.info("Getting ready to create the database tar...")
            this.commandObjects["CreateDBTar"] = Commands.commandFactory( "CreateDBTar" )
            this.commandObjects["CreateDBTar"].setGlobalOptions(this.globalOptions)
            this.commandObjects["CreateDBTar"].exec()
            logger.info("Finished creating the database tar...")
        }
    }
}

class GetLatestRelease extends GenericCommand {
    
    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'LOD', 'PROJECT' ]
    def commandObjects = [:]
    def logger

    def GetLatestRelease() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("GetLatestRelease default constructor")
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In GetLatestRelease....")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        def lod = this.globalOptions.get("LOD")
        def repo = new ScmRepo()
        def currentSnapshot = repo.getLatestSnapshotName( project, lod ) 
        println currentSnapshot
    }
}

class DeleteLodCie extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = [ 'DeleteCieJobs' ]
    def requiredOptions = [ 'PROJECT', 'LOD' ]
    def commandObjects = [:]
    def logger

    def DeleteLodCie() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("DeleteLodCie default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In DeleteLodCie....")
        def projectName = this.globalOptions.get("PROJECT")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + File.separator + projectName
        def lod = this.globalOptions.get("LOD")
        def repo = new ScmRepo()
        def osCmds = new OsCommands()
        repo.deleteLod(project, lod)
        logger.info("Finished deleting lod $lod")

        //now let's remove any associated Jenkins jobs
        this.commandObjects["DeleteCieJobs"].setGlobalOptions(this.globalOptions)
        this.commandObjects["DeleteCieJobs"].exec()
    }
}

class CreateLodCie extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = [ 'CreateSnapshot', 'CopyCieJobs' ]
    def requiredOptions = [ 'PROJECT', 'LOD_SRC', 'LOD_NEW' ]
    def commandObjects = [:]
    def logger

    def CreateLodCie() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateLodCie default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateLodCie....")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def projectName = this.globalOptions.get("PROJECT")
        def project = path_to_project + "/" + projectName
        def lod_src = this.globalOptions.get("LOD_SRC")
        def lod_new = this.globalOptions.get("LOD_NEW")
        // - JWS def lodRegularExpression = /br_[0-9]+.[0-9]+.[0-9]+/
        def lodRegularExpression = /br_[0-9]+.[0-9]+|br_[0-9]+.[0-9]+.[0-9]+|br_[0-9]+.[0-9]+.[0-9]+.[0-9]+/
        def lodComp

        // make sure the new lod name follows the naming standards
        if( lod_new ==~ lodRegularExpression ) {
            logger.info("lod $lod_new matches the lod naming convention - proceeding.....")
        
            lodComp = lodWLevelCompare( lod_src, lod_new )
            if( lodComp < 0 ) {
                logger.info("lod $lod_new increments properly - proceeding.....")
            }
            else {
                logger.fatal("lod $lod_new decrements incorrectly.  Please try again, ensuring the new lod increments to a higher version, for example, br_1.0 -> br_1.2, br_1.0.0 -> br_1.0.1")
                System.exit(1)
            }
        }
        else {
            logger.fatal("lod $lod_new does not match the naming convention. Please try again, ensuring the lod name matches, for example, br_1.0.0")
            System.exit(1)
        }

        def repo = new ScmRepo()
        def osCmds = new OsCommands()
        repo.createLod(project, lod_src, lod_new)
        logger.info("Finished creating new lod $lod_new")

        //now let's create the first snapshot so that future createReleases can correctly identify the git commit logs.
        // JWS this.globalOptions.put("LOD", lod_new)
        // JWS this.commandObjects["CreateSnapshot"].setGlobalOptions(this.globalOptions)
        // JWS this.commandObjects["CreateSnapshot"].exec()

        //now let's create the new jenkins job(s) for the new lod.
        this.commandObjects["CopyCieJobs"].setGlobalOptions(this.globalOptions)
        this.commandObjects["CopyCieJobs"].exec()
    }

    def lodWLevelCompare(def x, def y) {
       def x_array = x.split('_')
       def y_array = y.split('_')
        def x_lod = x_array[1]
        def y_lod = y_array[1]
        return lodCompare(x_lod, y_lod)
    }

    def lodCompare(def x, def y) {
        def x_array = x.tokenize('.') as int[]
        def y_array = y.tokenize('.') as int[]
        def majorCompare = x_array[0] - y_array[0]
        def minorCompare = x_array[1] - y_array[1]
// JWS 103014 commented out to allow for 2 digit and 3 digit versions br_4.0 and br_4.0.1
// First comment Lines commented below include this change
//        def patchCompare = x_array[2] - y_array[2]
        if( majorCompare != 0 ) {
            return majorCompare
        }
//        else if( minorCompare != 0 ) {

        else {

        }
//            return minorCompare
////        }
//        else {
//            return patchCompare
//        }
// JWS 103014 End of section
    }
}

class CreateBuildLod extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = [ 'CreateSnapshot', 'CopyCieJobs' ]
    def requiredOptions = [ 'PROJECT', 'LOD_SRC', 'LOD_NEW' ]
    def commandObjects = [:]
    def logger

    def CreateBuildLod() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateBuildLod default constructor")
        // Commented for this class  for( command in this.commandsUsed ) {
        // JWS 1/7/2015              this.commandObjects[command] = Commands.commandFactory( command )
        //}
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateBuildLod....")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def projectName = this.globalOptions.get("PROJECT")
        def project = path_to_project + "/" + projectName
        def lod_src = this.globalOptions.get("LOD_SRC")
        def lod_new = this.globalOptions.get("LOD_NEW")
        // - JWS def lodRegularExpression = /br_[0-9]+.[0-9]+.[0-9]+/
        def lodRegularExpression = /br_[0-9]+.[0-9]+|br_[0-9]+.[0-9]+.[0-9]+|br_[0-9]+.[0-9]+.[0-9]+.[0-9]+/
        def lodComp

        // make sure the new lod name follows the naming standards
        if( lod_new ==~ lodRegularExpression ) {
            logger.info("lod $lod_new matches the lod naming convention - proceeding.....")

            lodComp = lodWLevelCompare( lod_src, lod_new )
            if( lodComp < 0 ) {
                logger.info("lod $lod_new increments properly - proceeding.....")
            }
            else {
                logger.fatal("lod $lod_new decrements incorrectly.  Please try again, ensuring the new lod increments to a higher version, for example, br_1.0 -> br_1.2, br_1.0.0 -> br_1.0.1")
                System.exit(1)
            }
        }
        else {
            logger.fatal("lod $lod_new does not match the naming convention. Please try again, ensuring the lod name matches, for example, br_1.0.0")
            System.exit(1)
        }

        def repo = new ScmRepo()
        def osCmds = new OsCommands()
        repo.createLod(project, lod_src, lod_new)
        logger.info("Finished creating new lod $lod_new")

    }

    def lodWLevelCompare(def x, def y) {
       def x_array = x.split('_')
       def y_array = y.split('_')
        def x_lod = x_array[1]
        def y_lod = y_array[1]
        return lodCompare(x_lod, y_lod)
    }

    def lodCompare(def x, def y) {
        def x_array = x.tokenize('.') as int[]
        def y_array = y.tokenize('.') as int[]
        def majorCompare = x_array[0] - y_array[0]
        def minorCompare = x_array[1] - y_array[1]
// JWS 103014 commented out to allow for 2 digit and 3 digit versions br_4.0 and br_4.0.1
// First comment Lines commented below include this change
//        def patchCompare = x_array[2] - y_array[2]
        if( majorCompare != 0 ) {
            return majorCompare
        }
//        else if( minorCompare != 0 ) {

        else {

        }
//            return minorCompare
////        }
//        else {
//            return patchCompare
//        }
// JWS 103014 End of section
    }
}

class CreateRsb extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = [ 'CreateSnapshot', 'CopyCieJobs' ]
    def requiredOptions = [ 'PROJECT', 'LOD_SRC', 'LOD_NEW' ]
    def commandObjects = [:]
    def logger

    def CreateRsb() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CreateRsb default constructor")
        for( command in this.commandsUsed ) {
            this.commandObjects[command] = Commands.commandFactory( command )
        }
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In CreateRsb....")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def projectName = this.globalOptions.get("PROJECT")
        def project = path_to_project + "/" + projectName
        def lod_src = this.globalOptions.get("LOD_SRC")
        def lod_new = this.globalOptions.get("LOD_NEW")
        // - JWS def lodRegularExpression = /br_[0-9]+.[0-9]+.[0-9]+/
        def lodRegularExpression = /br_[0-9]+.[0-9]+|br_[0-9]+.[0-9]+.[0-9]+|br_[0-9]+.[0-9]+.[0-9]+.[0-9]+/
        def lodComp

        // make sure the new lod name follows the naming standards
        if( lod_new ==~ lodRegularExpression ) {
            logger.info("lod $lod_new matches the lod naming convention - proceeding.....")

            lodComp = lodWLevelCompare( lod_src, lod_new )
            if( lodComp < 0 ) {
                logger.info("lod $lod_new increments properly - proceeding.....")
            }
            else {
                logger.fatal("lod $lod_new decrements incorrectly.  Please try again, ensuring the new lod increments to a higher version, for example, br_1.0 -> br_1.2, br_1.0.0 -> br_1.0.1")
                System.exit(1)
            }
        }
        else {
            logger.fatal("lod $lod_new does not match the naming convention. Please try again, ensuring the lod name matches, for example, br_1.0.0")
            System.exit(1)
        }

        def repo = new ScmRepo()
        def osCmds = new OsCommands()
        repo.createLod(project, lod_src, lod_new)
        logger.info("Finished creating new lod $lod_new")

        //now let's create the first snapshot so that future createReleases can correctly identify the git commit logs.
        // JWS this.globalOptions.put("LOD", lod_new)
        // JWS this.commandObjects["CreateSnapshot"].setGlobalOptions(this.globalOptions)
        // JWS this.commandObjects["CreateSnapshot"].exec()

        //now let's create the new jenkins job(s) for the new lod.
        this.commandObjects["CopyCieJobs"].setGlobalOptions(this.globalOptions)
        this.commandObjects["CopyCieJobs"].exec()
    }

    def lodWLevelCompare(def x, def y) {
       def x_array = x.split('_')
       def y_array = y.split('_')
        def x_lod = x_array[1]
        def y_lod = y_array[1]
        return lodCompare(x_lod, y_lod)
    }

    def lodCompare(def x, def y) {
        def x_array = x.tokenize('.') as int[]
        def y_array = y.tokenize('.') as int[]
        def majorCompare = x_array[0] - y_array[0]
        def minorCompare = x_array[1] - y_array[1]
// JWS 103014 commented out to allow for 2 digit and 3 digit versions br_4.0 and br_4.0.1
// Lines commented below include this change
//        def patchCompare = x_array[2] - y_array[2]
        if( majorCompare != 0 ) {
            return majorCompare
        }
//        else if( minorCompare != 0 ) {

        else {

        }
//            return minorCompare
////        }
//        else {
//            return patchCompare
//        }
// JWS 103014 End of section
    }
}

class GetRepositories extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'PROJECT' ]
    def commandObjects = [:]
    def logger

    def GetRepositories() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("GetRepositories default constructor")
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {

        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def repo = new ScmRepo()
        return repo.getRepositories(path_to_project) 
    }
}

class GetLodsForProject extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'PROJECT' ]
    def commandObjects = [:]
    def logger

    def GetLodsForProject() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("GetLodsForProject default constructor")
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {

        def repo = new ScmRepo()
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        return repo.getLodsForProject(project) 
    }
}

class GetTagsForProject extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'PROJECT' ]
    def commandObjects = [:]
    def logger

    def GetTagsForProject() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("GetTagsForProject default constructor")
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {

        def repo = new ScmRepo()
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def project = path_to_project + "/" + this.globalOptions.get("PROJECT")
        return repo.getTagsForProject(project)
    }
}

class DeleteCieJobs extends GenericCommand {

    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'PROJECT', 'LOD' ]
    def commandObjects = [:]
    def logger

    def DeleteCieJobs() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("DeleteCieJobs default constructor")
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {

        List lod_substrings = this.globalOptions.get("LOD").split('_')
        def projectName = this.globalOptions.get("PROJECT")
        def lod = lod_substrings[1]
        JenkinsUtils jenkinsUtils = new JenkinsUtils()
        jenkinsUtils.deleteJenkinsJobs(projectName, lod)
        logger.info("Successfully deleted jenkins jobs for $projectName lod: $lod")
        logger.info("DeleteCieJobs complete")
    }
}

class CopyCieJobs extends GenericCommand {
    
    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'PROJECT', 'LOD_SRC', 'LOD_NEW' ]
    def commandObjects = [:]
    def logger

    def CopyCieJobs() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("CopyCieJobs default constructor")
    }

    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {

        List lod_src_substrings = this.globalOptions.get("LOD_SRC").split('_')
        List lod_new_substrings = this.globalOptions.get("LOD_NEW").split('_')
        def project = this.globalOptions.get("PROJECT")
        def lod_src = lod_src_substrings[1]
        def lod_new = lod_new_substrings[1]
        JenkinsUtils jenkinsUtils = new JenkinsUtils()
        jenkinsUtils.copyJenkinsJobs(project, lod_src, lod_new)
        logger.info("Successfully copied jenkins jobs for $lod_new")
        logger.info("CopyCieJobs complete")
    }
}

/**
 * This class is used to deploy a specific tagged version of a release to a target
 * tcserver environment - could be deployed any time, e.g., as part of a formal
 * nightly build process, or ad-hoc.
 */

class DeployRelease extends GenericCommand {
    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'ENVIRONMENT', 'PROJECT', 'VERSION' ]
    def commandObjects = [:]
    def commands = [] 
    def logger

    def DeployRelease() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("DeployRelease default constructor")
    }
    
    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In DeployRelease....")
        def env = this.globalOptions.get("ENVIRONMENT")
        this.logger.debug("environment = $env")
        def snapshot = this.globalOptions.get("SNAPSHOT")
        this.logger.debug("Snapshot = $snapshot")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def releaseTarsDir = this.globalOptions.get("RELEASE_TARS_DIR")
        def projectName = this.globalOptions.get("PROJECT")
        def projectRoot = this.globalOptions.get("PROJECT_ROOT")
        def project = path_to_project + "/" + projectName 
        this.logger.debug("project = $projectName")
        //def propsDeployFile = "../properties/projects/"+projectName+"/project.properties"
        def propsDeployFile = super.propsBaseDir + File.separator + projectName + File.separator + "project.properties"
        this.logger.debug("props deploy file = $propsDeployFile")
        def releaseTarName = projectName + "_" + snapshot + ".tar"
        logger.debug("release tar name = ${releaseTarName}")
        def projectTmpDir = super.tmpDir+"/$projectName-$snapshot"
	//this.logger.debug("projectTmpDir = $projectTmpDir")
        def osCmds = new OsCommands()

        // load project-specific project properties for the env provided
        def deployConfig
        if(System.getenv("DEPLOY_PROPERTIES") && new File(System.getenv("DEPLOY_PROPERTIES")).exists()) {
            logger.debug("DEPLOY_PROPERTIES variable defined. Getting project properties info now...")
            deployConfig = new ConfigSlurper().parse(new File(System.getenv("DEPLOY_PROPERTIES")).toURL())
        }
        else {
            deployConfig = new ConfigSlurper().parse(new File(propsDeployFile).toURL())
        }
        this.logger.debug("env name = " + env)
        this.logger.debug("tc server instance home = " + deployConfig.deploy."$env".tcserver.instance_home)
        // user deploy will be executed as 
        //def deployUser = envConfig.deployUser
        def deployUser = deployConfig.deploy."$env".deployUser
        // environment to deploy to
        def hostEnv = deployConfig.deploy."$env".environment.name
        // tcserver base dir where admin scripts live
        def tcserverBase = deployConfig.deploy."$env".tcserver.base
        // tcserver instance name
        def tcserverInstanceName = deployConfig.deploy."$env".tcserver.instance_name
        // tcserver commands to start, stop and check status of tcserver instances
        def tcserverAdminScript = deployConfig.deploy."$env".tcserver.admin_script
        def tcserverStatusCmd = deployConfig.deploy."$env".tcserver.status_cmd
        def tcserverStopCmd = deployConfig.deploy."$env".tcserver.stop_cmd
        def tcserverStartCmd = deployConfig.deploy."$env".tcserver.start_cmd
        // target dir where the application will be deployed
        def tcserverDeployDir
        def artifactNames = []
        def location = []
        def deployType = []
        def webappProject = []
        def preDeployCmds = []
        def postDeployCmds = []
        tcserverDeployDir = deployConfig.deploy."$env".tcserver.instance_home + "/" + tcserverInstanceName + "/" + deployConfig.webappDir
        logger.debug("tcserver deploy dir = $tcserverDeployDir")
        artifactNames = deployConfig.deploy."$env".artifacts.name
        location = deployConfig.deploy."$env".artifacts.location
        deployType = deployConfig.deploy."$env".artifacts?.deploy_type
        webappProject = deployConfig.deploy."$env".artifacts.webapp_project
        //optional list of commands to run prior to deploying the artifacts
        preDeployCmds = deployConfig.deploy?.pre_deploy_cmds
        //optional list of commands to run after deploying the artifacts
        postDeployCmds = deployConfig.deploy?.post_deploy_cmds
        // needed to clean up tmp dir where we have to extract a tar for a snapshot release deployment
        String rmTmpDirCmd = "rm -rf $projectTmpDir"
        if(preDeployCmds.size() < 1) {
            this.logger.debug("No pre-deploy commands to run....")
        }
        else {
            this.logger.debug("Found " + preDeployCmds.size() + " pre-deploy commands to run....")
            preDeployCmds.each() { key, value ->
                this.logger.debug("command name = $key")
                this.logger.debug("command value = $value")
            }
        }
        // check to see what version we're deploying. If it's a snapshot, we need to untar the tarball. Otherwise, we assume latest built and continue on.
        if(!snapshot.equals("latest")) {
            // we have a snapshot and need to untar
            String mkTmpDirCmd = "mkdir -p $projectTmpDir"
            String copyTarCmd = "cp $releaseTarsDir/$projectName/$releaseTarName $projectTmpDir"
            String unTarCmd = "tar xvf $releaseTarName"
            String rmTarCmd = "rm $releaseTarName"

            // make sure the tar file exists
            File tarFile = new File("$releaseTarsDir/$projectName/$releaseTarName")
            if(tarFile.exists()) {

                osCmds.shellCommand(mkTmpDirCmd, releaseTarsDir)
                osCmds.shellCommand(copyTarCmd, tmpDir)
                osCmds.shellCommand(unTarCmd, projectTmpDir) 
                logger.debug("Tar file for snapshot release $projectName $snapshot has been extracted in preparation for deployment to $env....")
            }
            else {
                logger.fatal("The tar file $releaseTarName was not found. Please check the name and version and try again.")
                System.exit(1)
            }
        }
        this.logger.debug("artifact names = $artifactNames")
        def stopCmd = "ssh $deployUser@" + hostEnv + " \"source ~/.bash_profile && \"$tcserverStopCmd\"\""
        def startCmd = "ssh $deployUser@" + hostEnv + " \"source ~/.bash_profile && \"$tcserverStartCmd\"\""
        def statusCmd = "ssh $deployUser@" + hostEnv + " \"$tcserverStatusCmd\""
        def remoteCmdPrefix = "ssh $deployUser@" + hostEnv + " \"source ~/.bash_profile && "
        def remoteCmdSuffix = "\""
        logger.debug("Server stop command = $stopCmd")
        logger.debug("Server start command = $startCmd")
        def artifactSrcDir
        def artifactName
        def artifactDeployType
        def tcWebProjectName
        String deployCmd
        //========= Finished Loading project properties for the given project and target deployment environment
        this.logger.info("Getting ready to deploy artifacts....")
        this.logger.info("Stopping tcserver instance $tcserverInstanceName....")
        osCmds.shellCommand(stopCmd, project, 0) 
        artifactNames.each() { key, value ->
            this.logger.debug("key = $key")
            this.logger.debug("value = $value")
            artifactName = value
            if(snapshot.equals("latest")) {
                artifactSrcDir = projectRoot + "/" + location.get(key, null) 
            }
            else {
                artifactSrcDir = projectTmpDir
            }
            tcWebProjectName = webappProject.get(key, null)
	    logger.info("webappProject.get = $tcWebProjectName...")
            logger.info("Starting Deploy of $artifactName to $hostEnv in $tcserverDeployDir....")
            this.logger.debug("artifact to deploy = $artifactSrcDir/$artifactName")
            deployCmd = "rsync -carv --safe-links $artifactSrcDir/$artifactName $deployUser@" + hostEnv + ":" + tcserverDeployDir

            if(deployType != null) {
                artifactDeployType = deployType.get(key, "exploded")
            }
            else {
                artifactDeployType = "archive"
            }
	    logger.info("artifactDeployType = $artifactDeployType...")
            if(artifactDeployType.equals("exploded")) {
                def unzipCmdPrefix = "ssh $deployUser@" + hostEnv + " \"source ~/.bash_profile && cd " + tcserverDeployDir + " &&"
                def unzipCmdMain = "unzip -o " + artifactName + " -d " + tcWebProjectName
                def unzipCmdSuffix = "\""
                def unzipCmd = unzipCmdPrefix + " " + unzipCmdMain + " " + unzipCmdSuffix
                // remove existing app dir
                this.logger.info("Removing old app version from tcserver....")
                def removeAppCmd = remoteCmdPrefix + "rm -rf $tcserverDeployDir/$tcWebProjectName*" + remoteCmdSuffix
                osCmds.shellCommand( removeAppCmd, project )

                this.logger.debug("remoteUnzip command = " + unzipCmd) 
                this.logger.info("Running rsync deploy cmd = " + deployCmd)
                osCmds.shellCommand( deployCmd, project, 1 )
                this.logger.info("Running remote unzip cmd: " + unzipCmd)
                osCmds.shellCommand(unzipCmd, project, 1)
            }
            else {

                // remove existing app dir
                this.logger.info("Removing old app version from tcserver....$tcserverDeployDir/$tcWebProjectName*")
                def removeAppCmd = remoteCmdPrefix + "rm -rf $tcserverDeployDir/$tcWebProjectName*" + remoteCmdSuffix
                osCmds.shellCommand( removeAppCmd, project )
		def showDeliveredWar = remoteCmdPrefix + "ls -al $tcserverDeployDir" + remoteCmdSuffix
		osCmds.shellCommand( showDeliveredWar, project )

                // deploy new version of app to tc Server
                logger.info("Running rsync deploy cmd = " + deployCmd)
                osCmds.shellCommand( deployCmd, project, 1 )
                osCmds.shellCommand( showDeliveredWar, project )
            }
            logger.info("Finished Deploying version $snapshot of $artifactName to $hostEnv in $tcserverDeployDir....")
        }
        this.logger.info("Starting tcserver instance $tcserverInstanceName....")
        osCmds.shellCommand(startCmd, project, 1)
        // clean up temp dir if necessary
        // jws removed next line if removal of tmp dire doesn't work
        //osCmds.shellCommand(rmTmpDirCmd, super.tmpDir)
    }
}

/**
 * This class is used to deploy the generated artifacts to a target tcserver
 * env right after they are built in Jenkins as part of a normal check-in process.
 */
class DeployLatestRelease extends GenericCommand {
    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'ENVIRONMENT', 'PROJECT' ]
    def commandObjects = [:]
    def commands = [] 
    def logger

    def DeployLatestRelease() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("DeployLatestRelease default constructor")
    }
    
    def setGlobalOptions(options) {
        super.setGlobalOptions(options)
    }

    def run() {
        this.logger.debug("In DeployLatestRelease....")
        def env = this.globalOptions.get("ENVIRONMENT")
        this.logger.debug("environment = $env")
        def path_to_project = this.globalOptions.get("PATH_TO_PROJECT")
        def projectName = this.globalOptions.get("PROJECT")
        def projectRoot = this.globalOptions.get("PROJECT_ROOT")
        def project = path_to_project + "/" + projectName 
        this.logger.debug("project = $projectName")
        //def propsDeployFile = "../properties/projects/"+projectName+"/project.properties"
        def propsDeployFile = super.propsBaseDir + File.separator + projectName + File.separator + "project.properties"
        this.logger.debug("props deploy file = $propsDeployFile")
        def osCmds = new OsCommands()

        // load project-specific project properties for the env provided
        def deployConfig
        if(System.getenv("DEPLOY_PROPERTIES") && new File(System.getenv("DEPLOY_PROPERTIES")).exists()) {
            logger.debug("DEPLOY_PROPERTIES variable defined. Getting project properties info now...")
            deployConfig = new ConfigSlurper().parse(new File(System.getenv("DEPLOY_PROPERTIES")).toURL())
        }
        else {
            deployConfig = new ConfigSlurper().parse(new File(propsDeployFile).toURL())
        }
        //this.logger.debug("env name = " + envConfig.environment.name)
        //this.logger.debug("tc server instance home = " + envConfig.tcserver.instance_home)
        this.logger.debug("env name = " + env)
        this.logger.debug("tc server instance home = " + deployConfig.deploy."$env".tcserver.instance_home)
        // user deploy will be executed as 
        def deployUser = deployConfig.deploy."$env".deployUser
        // environment to deploy to
        def hostEnv = deployConfig.deploy."$env".environment.name
        // tcserver base dir where admin scripts live
        def tcserverBase = deployConfig.deploy."$env".tcserver.base
        // tcserver instance name
        def tcserverInstanceName = deployConfig.deploy."$env".tcserver.instance_name
        // tcserver commands to start, stop and check status of tcserver instances
        def tcserverAdminScript = deployConfig.deploy."$env".tcserver.admin_script
        def tcserverStatusCmd = deployConfig.deploy."$env".tcserver.status_cmd
        def tcserverStopCmd = deployConfig.deploy."$env".tcserver.stop_cmd
        def tcserverStartCmd = deployConfig.deploy."$env".tcserver.start_cmd
        def webappProject = deploytConfig.deploy."$env".webappProject
        // target dir where the application will be deployed
        def tcserverDeployDir
        def artifactNames = []
        def location = []
        def deployType = []
        //  JWS  def webappProject = []
        def preDeployCmds = []
        def postDeployCmds = []
        tcserverDeployDir = deployConfig.deploy."$env".tcserver.instance_home + "/" + tcserverInstanceName + "/" + deployConfig.webappDir
        logger.debug("tcserver deploy dir = $tcserverDeployDir")
        artifactNames = deployConfig.deploy.artifacts.name
        location = deployConfig.deploy.artifacts.location
        deployType = deployConfig.deploy.artifacts?.deploy_type
        webappProject = deployConfig.deploy.artifacts.webapp_project
        //optional list of commands to run prior to deploying the artifacts
        preDeployCmds = deployConfig.deploy?.pre_deploy_cmds
        //optional list of commands to run after deploying the artifacts
        postDeployCmds = deployConfig.deploy?.post_deploy_cmds
        if(preDeployCmds.size() < 1) {
            this.logger.debug("No pre-deploy commands to run....")
        }
        else {
            this.logger.debug("Found " + preDeployCmds.size() + " pre-deploy commands to run....")
            preDeployCmds.each() { key, value ->
                this.logger.debug("command name = $key")
                this.logger.debug("command value = $value")
            }
        }
        this.logger.debug("artifact names = $artifactNames")
        def stopCmd = "ssh $deployUser@" + hostEnv + " \"source ~/.bash_profile && \"$tcserverStopCmd\"\""
        def startCmd = "ssh $deployUser@" + hostEnv + " \"source ~/.bash_profile && \"$tcserverStartCmd\"\""
        def statusCmd = "ssh $deployUser@" + hostEnv + " \"$tcserverStatusCmd\""
        def remoteCmdPrefix = "ssh $deployUser@" + hostEnv + " \"source ~/.bash_profile && "
        def remoteCmdSuffix = "\""
        logger.debug("Server stop command = $stopCmd")
        logger.debug("Server start command = $startCmd")
        def artifactSrcDir
        def artifactName
        def artifactDeployType
        def tcWebProjectName
        String deployCmd
        //========= Finished Loading project properties for the given project and target deployment environment
        this.logger.info("Getting ready to deploy artifacts....")
        this.logger.info("Stopping tcserver instance $tcserverInstanceName....")
        osCmds.shellCommand(stopCmd, project, 0) 
        artifactNames.each() { key, value ->
            this.logger.debug("key = $key")
            this.logger.debug("value = $value")
            artifactName = value
            artifactSrcDir = projectRoot + "/" + location.get(key, null) 
            tcWebProjectName = webappProject.get(key, null)
            logger.info("Starting Deploy of $artifactName to $hostEnv in $tcserverDeployDir....")
            this.logger.debug("artifact to deploy = $artifactSrcDir/$artifactName")
            deployCmd = "rsync -carv --safe-links $artifactSrcDir/$artifactName $deployUser@" + hostEnv + ":" + tcserverDeployDir

            if(deployType != null) {
                artifactDeployType = deployType.get(key, "exploded")
            }
            else {
                artifactDeployType = "archive"
            }
            if(artifactDeployType.equals("exploded")) {
                def unzipCmdPrefix = "ssh $deployUser@" + hostEnv + " \"source ~/.bash_profile && cd " + tcserverDeployDir + " &&"
                def unzipCmdMain = "unzip -o " + artifactName + " -d " + tcWebProjectName
                def unzipCmdSuffix = "\""
                def unzipCmd = unzipCmdPrefix + " " + unzipCmdMain + " " + unzipCmdSuffix
                // remove existing app dir
                this.logger.info("Removing old app version from tcserver....")
                def removeAppCmd = remoteCmdPrefix + "rm -rf $tcserverDeployDir/$tcWebProjectName*" + remoteCmdSuffix
                osCmds.shellCommand( removeAppCmd, project )

                this.logger.debug("remoteUnzip command = " + unzipCmd) 
                this.logger.info("Running rsync deploy cmd = " + deployCmd)
                osCmds.shellCommand( deployCmd, project, 1 )
                this.logger.info("Running remote unzip cmd: " + unzipCmd)
                osCmds.shellCommand(unzipCmd, project, 1)
            }
            else {

                // remove existing app dir
                this.logger.info("Removing old app version from tcserver....")
                def removeAppCmd = remoteCmdPrefix + "rm -rf $tcserverDeployDir/$tcWebProjectName*" + remoteCmdSuffix
                osCmds.shellCommand( removeAppCmd, project )

                // deploy new version of app to tc Server
                logger.info("Running rsync deploy cmd = " + deployCmd)
                osCmds.shellCommand( deployCmd, project, 1 )
            }
            logger.info("Finished Deploying $artifactName to $hostEnv in $tcserverDeployDir....")
        }
        this.logger.info("Starting tcserver instance $tcserverInstanceName....")
        osCmds.shellCommand(startCmd, project, 1)
    }
}

class Checkout extends GenericCommand {
    def globalOptions = [:]
    def commandsUsed = []
    def requiredOptions = [ 'PATH_TO_PROJECT', 'PROJECT', 'LOD' ]
    def commandObjects = [:]
    def commands = [] 
    def logger

    def Checkout() {
        this.logger=Log4j.getLogger(this.class)
        this.logger.debug("Checkout default constructor...")
        commandsUsed.each{ commandObjects.put( [it], Commands.commandFactory(it) ) }        
        commands[0] = "cd $globalOptions.get( 'PATH_TO_PROJECT' )/$globalOptions.get( 'PROJECT' )"
        commands[1] = "git checkout $globalOptions.get( 'LOD' )"
        commands[2] = "git pull origin $globalOptions.get ( 'LOD' )"
        commands[3] = "git tag $nextSnapshotName"
    }
}

#!/usr/bin/groovy

package canoe.alm.scm
import canoe.alm.utils.Log4j

class Snapshot {

    def name = ''
    def lod = ''
    def buildNumber = ''
    def nextBuildNumber = ''

    static void main( String[] args ) {
        Snapshot snapshot = new Snapshot( args[0] )
    }

    def Snapshot( String name ) {
        def logger = Log4j.getLogger(this.class)
        def snapshotName = name
        List snapshotSubStrings = snapshotName.tokenize('_')
        lod = snapshotSubStrings[0] + "_" + snapshotSubStrings[1]
        buildNumber = Integer.parseInt(snapshotSubStrings[2])
        nextBuildNumber = buildNumber 
        logger.debug("List = $snapshotSubStrings")
        logger.debug("Cur Build Number = $buildNumber")
        logger.debug("nextBuild = " + (nextBuildNumber += 1) )
        //logger.debug("Snapshot lod = $lod")
        //logger.debug("Snapshot build number = $buildNumber")
    }

    def getName() {
        return lod + buildNumber
    }

    def getNameWithoutPrefix( String name ) {
        def logger = Log4j.getLogger(this.class)
        def snapshotName = name
        List snapshotSubStrings = snapshotName.tokenize('_')
        lod = snapshotSubStrings[1]
        buildNumber = Integer.parseInt(snapshotSubStrings[2])
        def snapshotNameWithoutPrefix = lod + "_" + buildNumber
        logger.debug("Snapshot = $snapshotNameWithoutPrefix")
        return snapshotNameWithoutPrefix
    }

    def getBuildNumber() {
        return buildNumber
    }

    def compareSnapshots(snapshot_x, snapshot_y) {
        snapshot_x_number = (snapshot_x[snapshot_x.buildNumber])
        snapshot_y_number = (snapshot_y[snapshot_y.buildNumber])
        logger.debug("snapX = $snapshot_x_number")
        logger.debug("snapY = $snapshot_y_number")
        return snapshot_x_number <=> snapshot_y_number
    }
}

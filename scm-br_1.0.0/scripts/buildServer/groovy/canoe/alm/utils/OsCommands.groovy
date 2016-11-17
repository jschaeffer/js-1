#!/usr/bin/groovy

//import java.lang.Runtime
//import java.lang.Process
//import java.io.FileWriter
//import canoe.scm.utils.Log4j.*
package canoe.alm.utils

class OsCommands {

     static void main( String[] args ) {

     }

    def OsCommands() {
        def logger = Log4j.getLogger(this.class)
        logger.debug("in OsCommands constructor...")
    }

    def shellCommand( String command, String directory ) {
        shellCommand( command, directory, 0, 0 )
    }

    def shellCommand( String command, String directory, def failOnError ) {
        shellCommand( command, directory, failOnError, 0 )
    }

    def shellCommand( String command, String directory, def failOnError, def returnData ) {
        def category = "canoe.alm.utils.shellCommand"
        def logger = Log4j.getLogger("$category")

        File workingDir = new File("$directory")
        def commandArray = new String[3]
        commandArray[0] = "bash"
        commandArray[1] = "-c"
        commandArray[2] = command 

        def process
        def dataOutput = []
        InputStream is
        InputStream err

        def printOutput = 1
        def loopCount = 0
        def trackBytesAvail = 0
        def hasOutput = 0
        def printStatus = 0
        //failOnError = 0
        def available
        def erravailable


        process = new ProcessBuilder(commandArray).directory(workingDir).redirectErrorStream(true).start()
        process.inputStream.eachLine {logger.info("$it")
            if(returnData == 1) {
                dataOutput.add("$it")  
            }
        }
        process.waitFor();
        def exitValue = process.exitValue()
        if (exitValue != 0) {
            if(failOnError == 1) {
                logger.fatal("Command was NOT set to continue on error")
                logger.fatal("Command line was:        " + command)
                System.exit(exitValue)
            }
            else {
                logger.error("Command was set to continue on error")
                logger.error("The command line was:        " + command)
            }
        }
        if(exitValue == 0 && returnData == 1) {
            return dataOutput
        }
        
        else {
            return exitValue
        }
    }

        def shellCommandNew( String command, String directory, def failOnError, def returnData ) {
        def category = "canoe.alm.utils.shellCommand"
        def logger = Log4j.getLogger("$category")

        File workingDir = new File("$directory")
        def commandArray = new String[3]
        commandArray[0] = "bash"
        commandArray[1] = "-c"
        commandArray[2] = command 

        def process
        def dataOutput = []
        InputStream is
        InputStream err

        def printOutput = 1
        def loopCount = 0
        def trackBytesAvail = 0
        def hasOutput = 0
        def printStatus = 0
        //failOnError = 0
        def available
        def erravailable
        String response = ""
        
        try {
            process = new ProcessBuilder(commandArray).directory(workingDir).redirectErrorStream(true).start()
            
            is = process.getInputStream()
            int exitStatus = process.waitFor()
            println "Status = " + exitStatus
            response = convertStreamToStr(is)

            is.close()
        }
        catch(IOException e) {
            println "Error occured executing command " + e.getMessage()
        }
        return response

    }

    def String convertStreamToStr(InputStream is) throws IOException {

        if (is != null) {
        Writer writer = new StringWriter();
         
        char[] buffer = new char[1024];
        try {
        Reader reader = new BufferedReader(new InputStreamReader(is,
        "UTF-8"));
        int n;
        while ((n = reader.read(buffer)) != -1) {
        writer.write(buffer, 0, n);
        }
        } finally {
        is.close();
        }
        return writer.toString();
        }
        else {
        return "";
        }
	}
	 
    def callScript( String scriptName, String[] scriptArgs, String directory ) {
        logger.debug("in callScript...")
    }
}

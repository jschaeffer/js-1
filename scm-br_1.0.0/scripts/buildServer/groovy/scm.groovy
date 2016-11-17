#!/usr/bin/groovy

import java.sql.Timestamp
import java.text.SimpleDateFormat
import canoe.alm.utils.Utils
import canoe.alm.utils.Log4j

def main() {
    
//    try {
        def SimpleDateFormat dFormat = new SimpleDateFormat("yyyy-MM-dd_hh:mm:ss")
        def timestamp = dFormat.format( new Date() )
        def logger = Log4j.getLogger("main") 
        def buildNo 
        def options = Utils.parseArgs(args)
//JWS E
        if( options.containsKey("LOG_LEVEL") ) {
            println "Setting log level to " + options["LOG_LEVEL"]
            Log4j.setLoggerLevel(Log4j.getRootLogger(), options["LOG_LEVEL"])
        }
        logger.debug("options = $options")
        logger.debug("Timestamp = $timestamp")
        logger.debug("Args = $args")
//JWS S
        if( options.containsKey("BUILD_NUMBER") ) {
            logger.debug "BUILD_NUMBER=" + options["BUILD_NUMBER"]
            buildNo = options["BUILD_NUMBER"]
        }

        if( options.containsKey("LOCAL_DIR") ) {
            logger.debug("LOCAL_DIR is defined")
            if( !options.containsKey("TIME_STAMP") )
                options.put("TIME_STAMP", timestamp )
            options["LOCAL_DIR"]=options["LOCAL_DIR"]+"/"+options["TIME_STAMP"]
            def localDir = options["LOCAL_DIR"]
            logger.debug("LOCAL_DIR = $localDir")
        }
        // check to see if there is a project-specific properties file with overrides
        def projectName = options.get("PROJECT")
        def propsFile = "../properties/projects/"+projectName+"/project.properties"
        if( new File(propsFile).exists() ) {
            config = new ConfigSlurper().parse(new File(propsFile).toURL())
            String[] build_args
            String build_args_string = config?.build?.build_args
            if(build_args_string != null) {
                logger.debug("build args = " + config.build.build_args )
                build_args = build_args_string.split(",")
                for(int i = 0; i < build_args.length; i++) {
                    logger.debug("build_args[$i] = " + build_args[i])
                }
                options.put( "BUILD_ARGS", build_args )
                logger.debug("build_args = $build_args")
            }
            def update_jira = config?.jira?.update_jira
            if(update_jira != null) {
                options.put( "UPDATE_JIRA", update_jira )
            }
        }
        else {
            logger.debug("No properties overrides for $projectName project. Continuing with the build....")
        }

        def commandName = options.get("COMMAND")
        logger.debug("scm command = $commandName")
        def command = Commands.commandFactory( commandName )
        command.setGlobalOptions(options)
        command.exec() 
/*
    }
    catch (Exception e) {
        println "caught exception"
        println e.getMessage()
    }
    */
}

main()

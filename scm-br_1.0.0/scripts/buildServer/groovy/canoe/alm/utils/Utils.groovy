#!/usr/bin/groovy

package canoe.alm.utils

import java.lang.Object

public static parseArgs(args) {

    def logger = Log4j.getLogger(this.class)
    def cli = new CliBuilder( usage: 'groovy -c CreateRelease|CreateSnapshot -p "project" -l "lod" --option(s)' )
    cli.c( argName: 'command', longOpt: 'command', args: 1, required: true, 'command to execute' )
    cli.c( argName: 'command', longOpt: 'command', args: 1, required: true, 'command to execute' )
    cli.project( argName: 'project', longOpt: 'project', args: 1, required: false, 'git local workspace name' )
    cli.path_to_project( argName: 'path_to_project', longOpt: 'path_to_project', args: 1, required: false, 'path to local git projects' )
    cli.project_root( argName: 'project_root', longOpt: 'project_root', args: 1, required: false, 'path to local workspace' )
    cli.lod( argName: 'lodName', longOpt: 'lod', args: 1, required: false, 'lod to create snapshot from' )
    cli.lod_src( argName: 'lodSrc', longOpt: 'lod_src', args: 1, required: false, 'lod to create new lod from' )
    cli.lod_new( argName: 'lodNew', longOpt: 'lod_new', args: 1, required: false, 'new lod to create' )
    cli.snapshot( argName: 'snapshot', longOpt: 'snapshot', args: 1, required: false, 'snapshot to deploy' )
    cli.env( argName: 'env', longOpt: 'env', args: 1, required: false, 'environment to deploy to' )
    cli.build_args( argName: 'buildArgs', longOpt: 'buildArgs', args: 1, required: false, 'comma-separated list of build args to execute' )
    cli.update_jira( argName: 'updateJira', longOpt: 'updateJira', args: 1, required: false, 'boolean to determine if the project is capable of integrating with Jira' )
    cli.resource_war_name( argName: 'resource_war_name', longOpt: 'resource_war_name', args: 1, required: false, 'name of war created by the build' )
    cli.resource_war_dir( argName: 'resource_war_dir', longOpt: 'resource_war_dir', args: 1, required: false, 'location of war created by the build' )
    cli.db_tar( argName: 'db_tar', longOpt: 'db_tar', args: 1, required: false, 'If TRUE, indicates project has db scripts needing to be tar\'d. FALSE means otherwise' )
    cli.app_tar( argName: 'app_tar', longOpt: 'app_tar', args: 1, required: false, 'If TRUE, indicates project has application artifact needing to be tar\'d. FALSE means otherwise' )
    cli.resource_db_dir( argName: 'resource_db_dir', longOpt: 'resource_db_dir', args: 1, required: false, 'location of sql scripts for this project' )
    cli.resource_db_name( argName: 'resource_db_name', longOpt: 'resource_db_name', args: 1, required: false, 'sql dir to tar for project' )
    cli.log_level( argName: 'logLevel', longOpt: 'logLevel', args: 1, required: false, 'level for logging output' )
    cli.build_number( argName: 'buildNumber', longOpt: 'buildNumber', args: 1, required: false, 'build number' )
    cli.local_dir( argName: 'localDir', longOpt: 'localDir', args: 1, required: false, 'directory where to run the command' )
    cli.checkout( argName: 'checkout', longOpt: 'checkout', args: 1, required: false, 'flag to tell whether or not to do a pull from git' )
    cli.release_tars_dir( argName: 'release_tars_dir', longOpt: 'release_tars_dir', args: 1, required: false, 'directory to copy the tars into' )
    cli.release_tar_name( argName: 'release_tar_name', longOpt: 'release_tar_name', args: 1, required: false, 'release tar name' )
    cli.release_tar_db_name( argName: 'release_tar_db_name', longOpt: 'release_tar_db_name', args: 1, required: false, 'release tar db name' )
    cli.app_properties_dir( argName: 'app_properties_dir', longOpt: 'app_properties_dir', args: 1, required: false, 'sample application properties file' )
    cli.deploy_instructions_dir( argName: 'deploy_instructions_dir', longOpt: 'deploy_instructions_dir', args: 1, required: false, 'deploy_instructions_dir for the deployment' )
    cli.h( longOpt: 'help', 'usage information' )

    def cliOpts = [:]
    def opt = cli.parse(args)
    if(!opt) return
    if(opt.h)
        logger.debug("help!")
    if(opt.lod) {
        cliOpts.put( "LOD", opt.lod ) 
        logger.debug("lod = $opt.lod")
    }
    if(opt.lod_src) {
        cliOpts.put( "LOD_SRC", opt.lod_src ) 
        logger.debug("lod_src = $opt.lod_src")
    }
    if(opt.lod_new) {
        cliOpts.put( "LOD_NEW", opt.lod_new ) 
        logger.debug("lod_new = $opt.lod_new")
    }
    if(opt.snapshot) {
        cliOpts.put( "SNAPSHOT", opt.snapshot ) 
        logger.debug("snapshot = $opt.snapshot")
    }
    if(opt.env) {
        cliOpts.put( "ENVIRONMENT", opt.env ) 
        logger.debug("env = $opt.env")
    }
    if(opt.project) {
        cliOpts.put( "PROJECT", opt.project )
        logger.debug("project = $opt.project")
    }
    if(opt.build_args) {
        String[] build_args
        build_args = opt.build_args.split(",")
        for(int i = 0; i < build_args.length; i++) {
            logger.debug("build_args[$i] = " + build_args[i])
        }
        cliOpts.put( "BUILD_ARGS", build_args )
        logger.debug("build_args = $build_args")
    }
    if(opt.update_jira) {
        cliOpts.put( "UPDATE_JIRA", opt.update_jira )
        logger.debug("update_jira = $opt.update_jira")
    }
    if(opt.resource_war_name) {
        cliOpts.put( "RESOURCE_WAR_NAME", opt.resource_war_name )
        logger.debug("resource_war_name = $opt.resource_war_name")
    }
    if(opt.resource_war_dir) {
        cliOpts.put( "RESOURCE_WAR_DIR", opt.resource_war_dir )
        logger.debug("resource_war_dir = $opt.resource_war_dir")
    }
    if(opt.db_tar) {
        cliOpts.put( "TAR_DB", opt.db_tar )
        logger.debug("db_tar = $opt.db_tar")
    }
    if(opt.app_tar) {
        cliOpts.put( "TAR_APP", opt.app_tar )
        logger.debug("app_tar = $opt.app_tar")
    }
    if(opt.resource_db_dir) {
        cliOpts.put( "RESOURCE_DB_DIR", opt.resource_db_dir )
        logger.debug("resource_db_dir = $opt.resource_db_dir")
    }
    if(opt.resource_db_name) {
        cliOpts.put( "RESOURCE_DB_NAME", opt.resource_db_name )
        logger.debug("resource_db_name = $opt.resource_db_name")
    }
    if(opt.path_to_project) {
        cliOpts.put( "PATH_TO_PROJECT", opt.path_to_project )
        logger.debug("path_to_project = $opt.path_to_project")
    }
    if(opt.project_root) {
        cliOpts.put( "PROJECT_ROOT", opt.project_root )
        logger.debug("project_root = $opt.project_root")
    }
    if(opt.command) {
        cliOpts.put( "COMMAND", opt.command )
        logger.debug("commandToRun = $opt.command")
    }
    if(opt.checkout) {
        cliOpts.put( "CHECKOUT", opt.checkout )
        logger.debug("checkout = $opt.checkout")
    }
    if(opt.log_level) {
        cliOpts.put( "LOG_LEVEL", opt.log_level )
        logger.debug("logLevel = $opt.log_level")
    }
    if(opt.build_number) {
        cliOpts.put( "BUILD_NUMBER", opt.build_number )
        logger.debug("BUILD_NUMBER = $opt.build_number")
    }
    if(opt.local_dir) {
        cliOpts.put( "LOCAL_DIR", opt.local_dir )
        logger.debug("local_dir = $opt.local_dir")
    }
    if(opt.dry_run) {
        cliOpts.put( "DRY_RUN", opt.dry_run )
        logger.debug("dry_run = $opt.dry_run")
    }
    if(opt.environment) {
        cliOpts.put( "ENVIRONMENT", opt.environment )
        logger.debug("environment = $opt.environment")
    }
    if(opt.env_type) {
        cliOpts.put( "ENV_TYPE", opt.env_type )
        logger.debug("env_type = $opt.env_type")
    }
    if(opt.release_tars_dir) {
        cliOpts.put( "RELEASE_TARS_DIR", opt.release_tars_dir )
        logger.debug("release_tars_dir = $opt.release_tars_dir")
    }
    if(opt.release_tar_name) {
        cliOpts.put( "RELEASE_TAR_NAME", opt.release_tar_name )
        logger.debug("release_tar_name = $opt.release_tar_name")
    }
    if(opt.release_tar_db_name) {
        cliOpts.put( "RELEASE_TAR_DB_NAME", opt.release_tar_db_name )
        logger.debug("release_tar_db_name = $opt.release_tar_db_name")
    }
    if(opt.deployer_tar_destdir) {
        cliOpts.put( "DEPLOYER_TAR_DESTDIR", opt.deployer_tar_destdir )
        logger.debug("deployer_tar_destdir = $opt.deployer_tar_destdir")
    }
    if(opt.deploy_instructions_dir) {
        cliOpts.put( "DEPLOY_INSTRUCTIONS_DIR", opt.deploy_instructions_dir )
        logger.debug("deploy_instructions_dir = $opt.deploy_instructions_dir")
    }
    if(opt.app_properties_dir) {
        cliOpts.put( "APP_PROPERTIES_DIR", opt.app_properties_dir )
        logger.debug("app_properties_dir = $opt.app_properties_dir")
    }
    if(opt.v) {
        cliOpts.put( "VERBOSE", opt.v )
        logger.debug("verbose = $opt.v")
    }

    return cliOpts
}

def loadPropFileFromClasspath (file) {
    props = Properties()
    url = ClassLoader.getSystemResource(file)
    props.load(url.openStream())
    return props
}

def loadPropFile (file) {
    props = Properties()
    fis = FileInputStream(file)
    props.load(fis)
    return props
}


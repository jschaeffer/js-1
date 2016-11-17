import org.apache.log4j.Level

// log4j configuration
// For reference, see: http://www.grails.org/doc/latest/guide/3.%20Configuration.html
log4j = {

    appenders {
        //disable stacktrace file
        'null' name: 'stacktrace'

//        console name:'stdout', layout:pattern(conversionPattern: '%d{MM-dd-yyyy HH:mm:ss} %-5p %c %x >>%m%n')
        console name: 'stdout', layout: pattern(conversionPattern: '%d{MM-dd-yyyy HH:mm:ss} %-5p %c %x >>%m%n'), threshold: Level.INFO

        rollingFile name: 'rollingFileError', layout: pattern(conversionPattern: '%d{MM-dd-yyyy HH:mm:ss} %-5p %c %x >>%m%n'), threshold: Level.ERROR, maxFileSize: "10MB", maxBackupIndex: 15, file: '/opt/tcserver/instances/FW_CM/logs/error.log' 

        // file name:'stacktraceLog', file:'stacktrace.log', layout:pattern(conversionPattern: '%d{MM-dd-yyyy HH:mm:ss} %p %c{2} >>%m%n')
    }

    root {
        debug 'stdout'
        warn 'stdout'
        info 'stdout'
        error stdout: "StackTrace", 'rollingFileError'
    }

    // Set level for all application artifacts
    info 'org.codehaus.groovy.grails.commons', // core / classloading
            'grails.app', 'com.canoeventures', 'org.hibernate.SQL', 'org.hibernate.type'

    error 'org.codehaus.groovy.grails.web.servlet',  //  controllers
            'org.codehaus.groovy.grails.web.pages', //  GSP
            'org.codehaus.groovy.grails.web.sitemesh', //  layouts
            'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
            'org.codehaus.groovy.grails.web.mapping', // URL mapping
            'org.codehaus.groovy.grails.commons', // core / classloading
            'org.codehaus.groovy.grails.plugins', // plugins
            'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
            'org.springframework',
            'org.hibernate',
            'net.sf.ehcache.hibernate',
            'jdbc'

    warn 'org.mortbay.log'

    //debug 'jdbc.sqlonly' // uncomment to turn on Log4JDBC SQL logging
    additivity.StackTrace = false

}

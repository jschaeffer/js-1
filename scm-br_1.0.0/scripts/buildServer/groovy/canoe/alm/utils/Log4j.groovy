package canoe.alm.utils

import org.apache.log4j.Logger
import org.apache.log4j.Level

public static getLogger(logger) {
    logger = Logger.getLogger(logger)
    return logger
}

public static getRootLogger() {
    def logger = Logger.getRootLogger()
    return logger
}

public static setConsoleAppenderPattern(pattern) {
    def logger = getRootLogger()
    def appender = logger.getAppender("ConsoleAppender")
    //appender.setImmediateFlush(true)
    def layout = appender.getLayout()
    layout.setConversionPattern(pattern)
}

public static setLoggerLevel(logger, level) {
    //Valid levels: ALL, DEBUG, ERROR, FATAL, INFO, OFF, TRACE, WARN
    logger.setLevel(Level.toLevel(level))
}


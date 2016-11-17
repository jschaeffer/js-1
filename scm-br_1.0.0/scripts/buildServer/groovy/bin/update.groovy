@Grab('org.jdom:jdom2:2.0.5')
@Grab('jaxen:jaxen:1.1.4')
@GrabExclude('jdom:jdom')

//import groovy.transform.Field
import org.jdom2.*
import org.jdom2.input.*
import org.jdom2.xpath.*
import org.jdom2.output.*

//@Field
//def mvn = "C:\\Tools\\apache-maven-3.2.1\\bin\\mvn.bat"

def newVersion = args[0]

File rootFile = new File("pom.xml")

//parse(rootFile)
//Document root = parse(rootFile)
//

//findChild(root, "version").text = newVersion
//
//write(root, rootFile)

def exit = 0
def poms = []
new File(".").eachFileRecurse { file ->
    if (file.name == "pom.xml") poms.add(file)
}
def pomVersions = [:]
poms.each { file ->
    def pom = parse(file)

    def groupId = findChildValue(pom, "/project/groupId")
    def artifactId = findChildValue(pom, "/project/artifactId")
    def version = findChild(pom, "/project/version")
    def staticFlag = findChild(pom, "/project/properties/canoe.cm.static.version")

    if (version && !staticFlag) {
        version.text = newVersion
    }

    if (version) {
        pomVersions["${groupId}:${artifactId}"] = version.text
    } else {
        println "${file} does not specify a version.  This is a bad idea."
        exit = 1
    }

    write(pom, file)
}

poms.each { file ->
    def pom = parse(file)

    if (findChild(pom, "/project/parent")) {
        def groupId = findChildValue(pom, "/project/parent/groupId")
        def artifactId = findChildValue(pom, "/project/parent/artifactId")
        def version = findChild(pom, "/project/parent/version")

        def key = "${groupId}:${artifactId}"

        if (version && pomVersions[key]) version.text = pomVersions[key]

        write(pom, file)

    }
}

System.exit(exit)

def parse(File file) {
    new SAXBuilder().build(new FileReader(file))
}

def write(Document doc, File file) {
    println "Writing ${file}"
    new XMLOutputter().with {
        format = Format.getRawFormat()
        format.setLineSeparator(LineSeparator.UNIX)

        output(doc, new FileWriter(file))
    }
}
def findChild(Object node, String name) {
    name = name.replaceAll("([^/]+)",'*[local-name()=\'$1\']')
    XPathFactory.instance().compile(name).evaluate(node)[0]
}

def findChildValue(Object node, String name) {
    def child = findChild(node, name)
    child ? child.text : null
}

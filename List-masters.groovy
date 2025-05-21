import com.cloudbees.opscenter.server.model.ConnectedMaster
import jenkins.model.Jenkins

def rootUrl = Jenkins.instance.getRootUrl()
if (!rootUrl) {
    println "ATTENTION : L'URL racine (Root URL) n'est pas configurée dans CJOC. Configure-la dans 'Manage Jenkins' > 'Configure System'."
    return
}

Jenkins.instance.getAllItems(ConnectedMaster.class).each { controller ->
    if (controller.isOnline()) {
        def url = "${rootUrl}blue/organizations/jenkins/${controller.name}/"
        println "Managed Controller EN LIGNE : ${controller.displayName}"
        println " - Nom technique : ${controller.name}"
        println " - URL : ${url}"
        println ""
    }
}

/**
 Az alábbi beállításra a Gatling plugin miatt van szükség, l:
 https://wiki.jenkins-ci.org/display/JENKINS/Configuring+Content+Security+Policy
*/
import java.util.logging.LogManager
def logger = LogManager.getLogManager().getLogger("")

logger.info("Defining Content Security Policy header.")
System.setProperty("hudson.model.DirectoryBrowserSupport.CSP", "")

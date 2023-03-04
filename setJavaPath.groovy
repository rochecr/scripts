import java.util.logging.Logger

def logger = Logger.getLogger("ModifyJavaPathScript")

def newJavaPath = "/usr/pkgs/openjdk/11.0.17/bin/java"

jenkins.model.Jenkins.instanceOrNull.getComputers().each { computer ->
    if(computer.name.contains("pdx.intel.com")){
        try {
            def msg = "${computer.name}:\n\tcurrent: ${computer.getLauncher().getJavaPath()}"
            computer.getLauncher().setJavaPath(newJavaPath)
            msg += "\n\tnew: ${computer.getLauncher().getJavaPath()}"
            logger.info(msg)
            
            if (computer.isOnline()) {
                logger.info("Disconnecting computer ${computer.name} gracefully")
                computer.disconnect()
            }
            
            logger.info("Launching computer ${computer.name}")
            computer.launch()
        } catch (Exception e) {
            logger.warning("Error modifying Java path for computer ${computer.name}: ${e}")
        }
    }
}







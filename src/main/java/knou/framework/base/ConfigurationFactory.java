package knou.framework.base;

import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.builder.fluent.Configurations;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 환경설정 프로퍼티 관리
 */
 public class ConfigurationFactory {
	private static ConfigurationFactory instance = null;
	private static Configurations configs = new Configurations();
	private static final String CONFIG_PATH = "config";

    private static Configuration[] configList = new Configuration[2];

    private static final String CONFIG_SERVER       = "server.properties";
    private static final String CONFIG_FRAMEWORK    = "framework.properties";

    // Logger
    private Logger log = LoggerFactory.getLogger(getClass());

	/**
	 * 생성자
	 */
	private ConfigurationFactory() {
		try {

            Configuration configServer = (new Configurations()).properties(CONFIG_PATH + "/" + CONFIG_SERVER);
            String serverMode = configServer.getString("SERVER.MODE");

            configList[0] = configs.properties(CONFIG_PATH + "/" + serverMode + "/" + CONFIG_FRAMEWORK);
            configList[1] = configs.properties(configList[0].getString("framework.system.web_config_path")+"/web.properties");
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}


    /**
     * Get configuration
     * @return configuration
     */
    public static Configuration getConfiguration(int type) {
        if (instance == null) {
            synchronized(ConfigurationFactory.class) {
                instance = new ConfigurationFactory();
            }
        }

        return configList[type];
    }
}

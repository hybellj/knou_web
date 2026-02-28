package knou.framework.base;

import java.io.IOException;
import java.util.Properties;

import org.jasypt.encryption.StringEncryptor;
import org.jasypt.spring31.properties.EncryptablePropertySourcesPlaceholderConfigurer;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PropertiesLoaderUtils;

/**
 * Database property factory
 */
public class DatabasePropertyFactory {
	private static final String CONFIG_PATH = "config";
	private static final String SERVER_PROPERTIES = "server.properties";
	private static final String DATABASE_PROPERTIES = "database.properties";
	private static final String SERVER_MODE = "SERVER.MODE";
	

	/**
	 * Database property 설정값 로딩 (SERVER.MODE 값에 따라 설정된 properties 파일 로딩)
	 * @param encryptor
	 * @return configurer
	 * @throws IOException
	 */
	public static EncryptablePropertySourcesPlaceholderConfigurer databasePropertyConfigurer(StringEncryptor encryptor) throws IOException {
        Properties serverProps = PropertiesLoaderUtils.loadAllProperties(CONFIG_PATH + "/" + SERVER_PROPERTIES);
        String mode = serverProps.getProperty(SERVER_MODE, System.getProperty(SERVER_MODE, "local"));

        Resource server = new ClassPathResource(CONFIG_PATH + "/" + SERVER_PROPERTIES);
        Resource database = new ClassPathResource(CONFIG_PATH + "/" + mode + "/" + DATABASE_PROPERTIES);

        EncryptablePropertySourcesPlaceholderConfigurer configurer = new EncryptablePropertySourcesPlaceholderConfigurer(encryptor);
        configurer.setLocations(server, database);
        configurer.setIgnoreUnresolvablePlaceholders(false);
        configurer.setOrder(0);
        
        return configurer;
    }

}

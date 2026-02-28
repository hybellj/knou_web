package knou.framework.common;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

/**
 * WAS 부팅시 데이터 로딩 정의
 * 
 * @author shil
 */
@Component
public class CommLoader implements ApplicationListener<ContextRefreshedEvent> {

	@Override
	public void onApplicationEvent(final ContextRefreshedEvent event) {
		ApplicationContext applicationContext = event.getApplicationContext();
		
		if (applicationContext.getParent() != null) {
			// 시스템코드 로드
			//CodeInfo.loadCodeData(applicationContext);
			
			// 환경설정 로드
			//ConfInfo.loadConfData(applicationContext);
			
			// 메뉴 로드
			//MenuInfo.loadMenuData(applicationContext);
		}
	}
}
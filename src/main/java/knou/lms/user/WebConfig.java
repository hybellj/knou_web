package knou.lms.user;
import java.util.List;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        // 우리가 만든 리졸버 등록
        resolvers.add(new UserContextResolver());
    }
    
    @EnableAspectJAutoProxy
    public class AopConfig {
    }
}
package knou.lms.user;

import java.lang.annotation.*;

@Target(ElementType.PARAMETER) // 파라미터에만 붙이겠다
@Retention(RetentionPolicy.RUNTIME) // 실행 시점에 동작한다
public @interface CurrentUser {
}
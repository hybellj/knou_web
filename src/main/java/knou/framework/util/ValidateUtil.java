package knou.framework.util;

import org.springframework.validation.BindingResult;

import knou.lms.common.vo.ProcessResultVO;

import java.util.Optional;

public class ValidateUtil {

    /**
     * 유효성 검사 실패 시 ProcessResultVO 반환
     * @param bindingResult Spring의 유효성 검사 결과
     * @param <T> 제네릭 VO 타입
     * @return 유효성 실패 시 ProcessResultVO<T>, 없으면 null
     */
    public static <T> ProcessResultVO<T> validate(BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            ProcessResultVO<T> result = new ProcessResultVO<>();
            result.setSuccess(false);
            result.setMessage(bindingResult.getAllErrors().get(0).getDefaultMessage());
            return result;
        }
        return null;
    }
    
}

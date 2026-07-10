package knou.lms.crs.sbjct.web.validation;

import java.nio.charset.StandardCharsets;

import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import knou.lms.crs.sbjct.vo.SbjctTmpltVO;

@Component("sbjctTmpltSaveValidator")
public class SbjctTmpltSaveValidator implements Validator {

    private static final int LEN_SBJCT_CD = 30;
    private static final int LEN_NAME = 200;
    private static final int LEN_EXPLN = 4000;

    // 과목 저장 검증 대상 VO 여부를 확인한다.
    @Override
    public boolean supports(Class<?> clazz) {
        return SbjctTmpltVO.class.isAssignableFrom(clazz);
    }

    // 과목 저장 공통 필수값과 형식을 검증한다.
    @Override
    public void validate(Object target, Errors errors) {
        if (!(target instanceof SbjctTmpltVO)) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }
        validateCommon((SbjctTmpltVO) target, errors);
    }

    // 과목 등록 요청값을 검증한다.
    public void validateForRegist(SbjctTmpltVO vo, Errors errors) {
        validate(vo, errors);
    }

    // 과목 수정 요청값을 검증한다.
    public void validateForModify(SbjctTmpltVO vo, Errors errors) {
        if (vo == null) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }
        rejectIfBlank(errors, "sbjctTmpltId", vo.getSbjctTmpltId(), "fail.common.msg");/*에러가 발생했습니다!*/
        validate(vo, errors);
    }

    // 과목 저장 공통 필수값을 검증한다.
    private void validateCommon(SbjctTmpltVO vo, Errors errors) {
        if (vo == null) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }

        rejectIfBlank(errors, "orgId", vo.getOrgId(), "crs.sbjct.alert.select.org");/*기관을 선택해 주세요.*/
        rejectIfBlank(errors, "smstrChrtId", vo.getSmstrChrtId(), "crs.sbjct.alert.select.smstr.chrt");/*학기/기수 명을 선택해 주세요.*/
        rejectIfBlank(errors, "sbjctTycd", vo.getSbjctTycd(), "crs.sbjct.alert.select.type");/*과목분류를 선택해 주세요.*/
        rejectIfBlank(errors, "sbjctnm", vo.getSbjctnm(), "crs.sbjct.alert.input.name");/*과목명을 입력해 주세요.*/
        rejectIfBlank(errors, "sbjctCd", vo.getSbjctCd(), "crs.sbjct.alert.input.code");/*과목코드를 입력해 주세요.*/
        rejectIfBlank(errors, "lctrGbncd", vo.getLctrGbncd(), "crs.sbjct.alert.select.lctr.gbn");/*강의형태를 선택해 주세요.*/
        rejectIfBlank(errors, "useyn", vo.getUseyn(), "crs.sbjct.alert.select.useyn");/*사용여부를 선택해 주세요.*/

        validateMaxByteLength(vo, errors);
        validateFormat(vo, errors);
    }

    // 과목 저장 필드의 최대 바이트 길이를 검증한다.
    private void validateMaxByteLength(SbjctTmpltVO vo, Errors errors) {
        rejectIfOverMaxByte(errors, "sbjctCd", vo.getSbjctCd(), LEN_SBJCT_CD, "common.label.crsauth.crscd");/*과목코드*/
        rejectIfOverMaxByte(errors, "sbjctnm", vo.getSbjctnm(), LEN_NAME, "crs.label.crecrs.nm");/*과목명*/
        rejectIfOverMaxByte(errors, "sbjctExpln", vo.getSbjctExpln(), LEN_EXPLN, "crs.lecture.explain");/*과목설명*/
    }

    // 과목 저장 필드의 값 형식을 검증한다.
    private void validateFormat(SbjctTmpltVO vo, Errors errors) {
        if (!isBlank(vo.getSbjctCd()) && !vo.getSbjctCd().matches("[A-Za-z0-9]+")) {
            errors.rejectValue("sbjctCd", "crs.sbjct.alert.input.code.format");/*과목코드는 영문과 숫자만 입력해 주세요.*/
        }
        if (!isBlank(vo.getUseyn()) && !("Y".equals(vo.getUseyn()) || "N".equals(vo.getUseyn()))) {
            errors.rejectValue("useyn", "crs.sbjct.alert.select.useyn");/*사용여부를 선택해 주세요.*/
        }
    }

    // 빈 문자열이면 지정된 메시지 코드로 오류를 추가한다.
    private void rejectIfBlank(Errors errors, String field, String value, String code) {
        if (isBlank(value)) {
            errors.rejectValue(field, code);
        }
    }

    // 최대 바이트 길이를 초과하면 오류를 추가한다.
    private void rejectIfOverMaxByte(Errors errors, String field, String value, int maxBytes, String labelMessageCode) {
        if (isBlank(value) || byteLength(value) <= maxBytes) {
            return;
        }
        errors.rejectValue(field, "forum.alert.input.max.byte", new Object[] { new DefaultMessageSourceResolvable(labelMessageCode), maxBytes }, null);/*{0}은 {1} byte를 초과하여 입력할 수 없습니다.*/
    }

    // 문자열의 UTF-8 바이트 길이를 계산한다.
    private int byteLength(String value) {
        return value.getBytes(StandardCharsets.UTF_8).length;
    }

    // 문자열이 null 이거나 공백인지 확인한다.
    private boolean isBlank(String value) {
        return value == null || value.trim().length() == 0;
    }
}

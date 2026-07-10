package knou.lms.crs.sbjct.web.validation;

import java.nio.charset.StandardCharsets;

import knou.lms.crs.sbjct.vo.SbjctVO;
import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

/**
 * 공개강좌개설 저장 요청값을 검증한다.
 */
@Component("sbjctOpenLctrOfringSaveValidator")
public class SbjctOpenLctrOfringSaveValidator implements Validator {

    private static final int LEN_SBJCT_CD = 30;
    private static final int LEN_NAME = 200;
    private static final int LEN_EXPLN = 4000;
    private static final int LEN_DTTM = 14;

    // 공개강좌개설 저장 검증 대상 VO 여부를 확인한다.
    @Override
    public boolean supports(Class<?> clazz) {
        return SbjctVO.class.isAssignableFrom(clazz);
    }

    // 공개강좌개설 저장 공통 필수값과 형식을 검증한다.
    @Override
    public void validate(Object target, Errors errors) {
        if (!(target instanceof SbjctVO)) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }
        validateCommon((SbjctVO) target, errors);
    }

    // 공개강좌개설 등록 요청값을 검증한다.
    public void validateForRegist(SbjctVO vo, Errors errors) {
        if (vo == null) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }
        rejectIfBlank(errors, "sbjctTmpltId", vo.getSbjctTmpltId(), "crs.sbjct.ofring.alert.select.subject");/*과목을 선택해 주세요.*/
        validateCommon(vo, errors);
    }

    // 공개강좌개설 수정 요청값을 검증한다.
    public void validateForModify(SbjctVO vo, Errors errors) {
        if (vo == null) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }
        rejectIfBlank(errors, "sbjctId", vo.getSbjctId(), "fail.common.msg");/*에러가 발생했습니다!*/
        validateCommon(vo, errors);
    }

    // 공개강좌개설 저장에 필요한 최소 필수값을 검증한다.
    private void validateCommon(SbjctVO vo, Errors errors) {
        rejectIfBlank(errors, "orgId", vo.getOrgId(), "crs.sbjct.alert.select.org");/*기관을 선택해 주세요.*/
        rejectIfBlank(errors, "smstrChrtId", vo.getSmstrChrtId(), "crs.sbjct.alert.select.smstr.chrt");/*학기/기수 명을 선택해 주세요.*/
        rejectIfBlank(errors, "sbjctCd", vo.getSbjctCd(), "crs.sbjct.alert.input.code");/*과목코드를 입력해 주세요.*/
        rejectIfBlank(errors, "sbjctnm", vo.getSbjctnm(), "crs.sbjct.alert.input.name");/*과목명을 입력해 주세요.*/
        rejectIfBlank(errors, "sbjctExpln", vo.getSbjctExpln(), "crs.sbjct.ofring.alert.input.expln");/*과목설명을 입력해 주세요.*/
        rejectIfBlank(errors, "crsGbncd", vo.getCrsGbncd(), "crs.sbjct.ofring.alert.select.crs.gbn");/*과정구분을 선택해 주세요.*/
        rejectIfBlank(errors, "lctrGbncd", vo.getLctrGbncd(), "crs.sbjct.alert.select.lctr.gbn");/*강의형태를 선택해 주세요.*/
        rejectIfBlank(errors, "useyn", vo.getUseyn(), "crs.sbjct.alert.select.useyn");/*사용여부를 선택해 주세요.*/

        validateMaxByteLength(vo, errors);
        validateFormat(vo, errors);
    }

    // 공개강좌개설 저장 필드의 최대 바이트 길이를 검증한다.
    private void validateMaxByteLength(SbjctVO vo, Errors errors) {
        rejectIfOverMaxByte(errors, "sbjctCd", vo.getSbjctCd(), LEN_SBJCT_CD, "crs.label.subject.code");/*과목코드*/
        rejectIfOverMaxByte(errors, "sbjctnm", vo.getSbjctnm(), LEN_NAME, "crs.sbjct.ofring.label.subject.ko");/*과목명(KO)*/
        rejectIfOverMaxByte(errors, "sbjctEnnm", vo.getSbjctEnnm(), LEN_NAME, "crs.sbjct.ofring.label.subject.en");/*과목명(EN)*/
        rejectIfOverMaxByte(errors, "sbjctExpln", vo.getSbjctExpln(), LEN_EXPLN, "crs.lecture.explain");/*과목설명*/
    }

    // 공개강좌개설 저장 필드의 값 형식을 검증한다.
    private void validateFormat(SbjctVO vo, Errors errors) {
        if (!isBlank(vo.getSbjctCd()) && !vo.getSbjctCd().matches("[A-Za-z0-9]+")) {
            errors.rejectValue("sbjctCd", "crs.sbjct.alert.input.code.format");/*과목코드는 영문과 숫자만 입력해 주세요.*/
        }
        if (!isBlank(vo.getUseyn()) && !isYn(vo.getUseyn())) {
            errors.rejectValue("useyn", "crs.sbjct.alert.select.useyn");/*사용여부를 선택해 주세요.*/
        }
        if (!isYn(vo.getLctrPermYn())) {
            errors.rejectValue("lctrPermYn", "crs.sbjct.ofring.alert.input.lctr.period");/*강의 기간의 시작일시와 종료일시를 입력해 주세요.*/
            return;
        }
        if ("N".equals(vo.getLctrPermYn())
                && (!isValidDttm(vo.getSbjctLctrSdttm()) || !isValidDttm(vo.getSbjctLctrEdttm()))) {
            errors.rejectValue("sbjctLctrSdttm", "crs.sbjct.ofring.alert.input.lctr.period");/*강의 기간의 시작일시와 종료일시를 입력해 주세요.*/
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

    // Y/N 값인지 확인한다.
    private boolean isYn(String value) {
        return "Y".equals(value) || "N".equals(value);
    }

    // 일시 값은 yyyyMMddHHmmss 형식일 때만 허용한다.
    private boolean isValidDttm(String value) {
        return value != null && value.length() == LEN_DTTM && value.matches("\\d{14}");
    }

    // 문자열이 null 이거나 공백인지 확인한다.
    private boolean isBlank(String value) {
        return value == null || value.trim().length() == 0;
    }
}

package knou.lms.crs.sbjct.web.validation;

import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import knou.lms.crs.sbjct.vo.SbjctSchdlVO;

@Component("sbjctOfringSchdlSaveValidator")
public class SbjctOfringSchdlSaveValidator implements Validator {

    private static final int LEN_SBJCT_SCHDL_WKNONM = 100;

    // 과목개설 주차 기간 설정 저장 검증 대상 VO 여부를 확인한다.
    @Override
    public boolean supports(Class<?> clazz) {
        return SbjctSchdlVO.class.isAssignableFrom(clazz);
    }

    // 과목개설 주차 기간 설정 저장 필수값과 형식을 검증한다.
    @Override
    public void validate(Object target, Errors errors) {
        if (!(target instanceof SbjctSchdlVO)) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }
        validateForSave((SbjctSchdlVO) target, errors);
    }

    // 과목개설 주차 기간 설정 저장 요청값을 검증한다.
    public void validateForSave(SbjctSchdlVO vo, Errors errors) {
        if (vo == null) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }

        rejectIfBlank(errors, "sbjctId", vo.getSbjctId(), "fail.common.msg");/*에러가 발생했습니다!*/

        List<SbjctSchdlVO> schdlList = vo.getSchdlList();
        if (schdlList == null || schdlList.isEmpty()) {
            errors.rejectValue("schdlList", "crs.sbjct.ofring.alert.schdl.empty");/*주차 기간 설정 항목이 없습니다.*/
            return;
        }

        for (int i = 0; i < schdlList.size(); i++) {
            validateSchdlRow(schdlList.get(i), errors, "schdlList[" + i + "]");
        }
    }

    // 과목개설 주차 기간 설정 저장 요청의 1개 주차 row를 검증한다.
    private void validateSchdlRow(SbjctSchdlVO vo, Errors errors, String fieldPrefix) {
        if (vo == null) {
            errors.rejectValue(fieldPrefix, "crs.sbjct.ofring.alert.schdl.empty");/*주차 기간 설정 항목이 없습니다.*/
            return;
        }

        rejectIfNull(errors, fieldPrefix + ".sbjctSchdlWkno", vo.getSbjctSchdlWkno(), "crs.sbjct.ofring.alert.schdl.empty");/*주차 기간 설정 항목이 없습니다.*/
        rejectIfNull(errors, fieldPrefix + ".tocSeqno", vo.getTocSeqno(), "crs.sbjct.ofring.alert.schdl.empty");/*주차 기간 설정 항목이 없습니다.*/
        rejectIfBlank(errors, fieldPrefix + ".sbjctSchdlWknonm", vo.getSbjctSchdlWknonm(), "crs.sbjct.ofring.alert.input.schdl.wknonm");/*주차명을 입력해 주세요.*/
        rejectIfBlank(errors, fieldPrefix + ".sbjctSymd", vo.getSbjctSymd(), "crs.sbjct.ofring.alert.input.schdl.period");/*학습 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfBlank(errors, fieldPrefix + ".sbjctEymd", vo.getSbjctEymd(), "crs.sbjct.ofring.alert.input.schdl.period");/*학습 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfBlank(errors, fieldPrefix + ".sbjctAtndcRcgSymd", vo.getSbjctAtndcRcgSymd(), "crs.sbjct.ofring.alert.input.atndc.rcg.period");/*출석 인정 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfBlank(errors, fieldPrefix + ".sbjctAtndcRcgEymd", vo.getSbjctAtndcRcgEymd(), "crs.sbjct.ofring.alert.input.atndc.rcg.period");/*출석 인정 기간의 시작일과 종료일을 입력해 주세요.*/

        rejectIfOverMaxByte(errors, fieldPrefix + ".sbjctSchdlWknonm", vo.getSbjctSchdlWknonm(), LEN_SBJCT_SCHDL_WKNONM, "주차명");
        rejectIfInvalidYmd(errors, fieldPrefix + ".sbjctSymd", vo.getSbjctSymd(), "crs.sbjct.ofring.alert.input.schdl.period");/*학습 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfInvalidYmd(errors, fieldPrefix + ".sbjctEymd", vo.getSbjctEymd(), "crs.sbjct.ofring.alert.input.schdl.period");/*학습 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfInvalidYmd(errors, fieldPrefix + ".sbjctAtndcRcgSymd", vo.getSbjctAtndcRcgSymd(), "crs.sbjct.ofring.alert.input.atndc.rcg.period");/*출석 인정 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfInvalidYmd(errors, fieldPrefix + ".sbjctAtndcRcgEymd", vo.getSbjctAtndcRcgEymd(), "crs.sbjct.ofring.alert.input.atndc.rcg.period");/*출석 인정 기간의 시작일과 종료일을 입력해 주세요.*/

        if (isYmd(vo.getSbjctSymd()) && isYmd(vo.getSbjctEymd())
                && vo.getSbjctSymd().compareTo(vo.getSbjctEymd()) > 0) {
            errors.rejectValue(fieldPrefix + ".sbjctSymd", "crs.sbjct.ofring.alert.invalid.date.order");/*시작일은 종료일보다 늦을 수 없습니다.*/
        }
        if (isYmd(vo.getSbjctAtndcRcgSymd()) && isYmd(vo.getSbjctAtndcRcgEymd())
                && vo.getSbjctAtndcRcgSymd().compareTo(vo.getSbjctAtndcRcgEymd()) > 0) {
            errors.rejectValue(fieldPrefix + ".sbjctAtndcRcgSymd", "crs.sbjct.ofring.alert.invalid.date.order");/*시작일은 종료일보다 늦을 수 없습니다.*/
        }
    }

    // 빈 문자열이면 지정된 메시지 코드로 오류를 추가한다.
    private void rejectIfBlank(Errors errors, String field, String value, String code) {
        if (isBlank(value)) {
            errors.rejectValue(field, code);
        }
    }

    // null 이면 지정된 메시지 코드로 오류를 추가한다.
    private void rejectIfNull(Errors errors, String field, Object value, String code) {
        if (value == null) {
            errors.rejectValue(field, code);
        }
    }

    // 최대 바이트 길이를 초과하면 오류를 추가한다.
    private void rejectIfOverMaxByte(Errors errors, String field, String value, int maxBytes, String defaultLabel) {
        if (isBlank(value) || byteLength(value) <= maxBytes) {
            return;
        }
        errors.rejectValue(field, "forum.alert.input.max.byte", new Object[] { defaultLabel, maxBytes }, null);/*{0}은 {1} byte를 초과하여 입력할 수 없습니다.*/
    }

    // 일자 값은 yyyyMMdd 형식일 때만 허용한다.
    private void rejectIfInvalidYmd(Errors errors, String field, String value, String code) {
        if (!isBlank(value) && !isYmd(value)) {
            errors.rejectValue(field, code);
        }
    }

    // YYYYMMDD 형식의 일자인지 확인한다.
    private boolean isYmd(String value) {
        return value != null && value.matches("\\d{8}");
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

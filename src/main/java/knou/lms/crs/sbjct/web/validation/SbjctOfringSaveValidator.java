package knou.lms.crs.sbjct.web.validation;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;

import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import knou.lms.crs.sbjct.vo.SbjctVO;

@Component("sbjctOfringSaveValidator")
public class SbjctOfringSaveValidator implements Validator {

    private static final int LEN_SBJCT_CD = 30;
    private static final int LEN_NAME = 200;
    private static final int LEN_EXPLN = 4000;
    private static final int LEN_DTTM = 14;

    // 과목개설 저장 검증 대상 VO 여부를 확인한다.
    @Override
    public boolean supports(Class<?> clazz) {
        return SbjctVO.class.isAssignableFrom(clazz);
    }

    // 과목개설 저장 공통 필수값과 형식을 검증한다.
    @Override
    public void validate(Object target, Errors errors) {
        if (!(target instanceof SbjctVO)) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }
        validateCommon((SbjctVO) target, errors);
    }

    // 과목개설 등록 요청값을 검증한다.
    public void validateForRegist(SbjctVO vo, Errors errors) {
        validate(vo, errors);
        if (vo != null) {
            rejectIfBlank(errors, "sbjctTmpltId", vo.getSbjctTmpltId(), "crs.sbjct.ofring.alert.select.subject");/*과목을 선택해 주세요.*/
        }
    }

    // 과목개설 수정 요청값을 검증한다.
    public void validateForModify(SbjctVO vo, Errors errors) {
        validate(vo, errors);
        if (vo != null) {
            rejectIfBlank(errors, "sbjctId", vo.getSbjctId(), "fail.common.msg");/*에러가 발생했습니다!*/
        }
    }

    // 과목개설 저장 공통 필수값을 검증한다.
    private void validateCommon(SbjctVO vo, Errors errors) {
        if (vo == null) {
            errors.reject("fail.common.msg");/*에러가 발생했습니다!*/
            return;
        }

        rejectIfBlank(errors, "orgId", vo.getOrgId(), "crs.sbjct.alert.select.org");/*기관을 선택해 주세요.*/
        rejectIfBlank(errors, "smstrChrtId", vo.getSmstrChrtId(), "crs.sbjct.alert.select.smstr.chrt");/*학기/기수 명을 선택해 주세요.*/
        rejectIfBlank(errors, "sbjctnm", vo.getSbjctnm(), "crs.sbjct.alert.input.name");/*과목명을 입력해 주세요.*/
        rejectIfBlank(errors, "sbjctExpln", vo.getSbjctExpln(), "crs.sbjct.ofring.alert.input.expln");/*과목설명을 입력해 주세요.*/
        rejectIfBlank(errors, "sbjctCd", vo.getSbjctCd(), "crs.sbjct.alert.input.code");/*과목코드를 입력해 주세요.*/
        rejectIfBlank(errors, "crsGbncd", vo.getCrsGbncd(), "crs.sbjct.ofring.alert.select.crs.gbn");/*과정구분을 선택해 주세요.*/
        rejectIfBlank(errors, "lctrGbncd", vo.getLctrGbncd(), "crs.sbjct.alert.select.lctr.gbn");/*강의형태를 선택해 주세요.*/
        rejectIfBlank(errors, "cmcrsGbncd", vo.getCmcrsGbncd(), "crs.sbjct.ofring.alert.select.cmcrs.gbn");/*이수구분을 선택해 주세요.*/
        rejectIfBlank(errors, "evlGbncd", vo.getEvlGbncd(), "crs.sbjct.ofring.alert.select.evl.gbn");/*평가방법을 선택해 주세요.*/
        rejectIfBlank(errors, "lctrFrmtGbncd", vo.getLctrFrmtGbncd(), "crs.sbjct.ofring.alert.select.lctr.frmt");/*강의형식을 선택해 주세요.*/
        rejectIfBlank(errors, "lrnCntrlGbncd", vo.getLrnCntrlGbncd(), "crs.sbjct.ofring.alert.select.lrn.cntrl");/*학습제어를 선택해 주세요.*/
        rejectIfBlank(errors, "atndlcAplyMthdCd", vo.getAtndlcAplyMthdCd(), "crs.sbjct.ofring.alert.select.atndlc.aply");/*수강신청 변경을 선택해 주세요.*/
        rejectIfBlank(errors, "atndlcCertStscd", vo.getAtndlcCertStscd(), "crs.sbjct.ofring.alert.select.atndlc.cert");/*수강인증상태를 선택해 주세요.*/
        rejectIfBlank(errors, "rvwPsblGbncd", vo.getRvwPsblGbncd(), "crs.sbjct.ofring.alert.select.rvw.psbl");/*복습기간유형을 선택해 주세요.*/
        rejectIfBlank(errors, "lctrEvlyn", vo.getLctrEvlyn(), "crs.sbjct.ofring.alert.select.lctr.evl");/*강의평가 여부를 선택해 주세요.*/
        rejectIfBlank(errors, "useyn", vo.getUseyn(), "crs.sbjct.alert.select.useyn");/*사용여부를 선택해 주세요.*/
        rejectIfBlank(errors, "dvclasNcknm", vo.getDvclasNcknm(), "crs.sbjct.ofring.alert.input.dvclas.alias");/*분반 별칭을 입력해 주세요.*/
        rejectIfBlank(errors, "atndlcAplySdttm", vo.getAtndlcAplySdttm(), "crs.sbjct.ofring.alert.input.atndlc.aply.period");/*수강 신청 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfBlank(errors, "atndlcAplyEdttm", vo.getAtndlcAplyEdttm(), "crs.sbjct.ofring.alert.input.atndlc.aply.period");/*수강 신청 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfBlank(errors, "sbjctLctrSdttm", vo.getSbjctLctrSdttm(), "crs.sbjct.ofring.alert.input.lctr.period");/*강의 기간의 시작일시와 종료일시를 입력해 주세요.*/
        rejectIfBlank(errors, "sbjctLctrEdttm", vo.getSbjctLctrEdttm(), "crs.sbjct.ofring.alert.input.lctr.period");/*강의 기간의 시작일시와 종료일시를 입력해 주세요.*/
        rejectIfBlank(errors, "sbjctLateRecgDttm", vo.getSbjctLateRecgDttm(), "crs.sbjct.ofring.alert.input.late.recg.dttm");/*지각 인정 일시를 입력해 주세요.*/
        rejectIfBlank(errors, "auditEdttm", vo.getAuditEdttm(), "crs.sbjct.ofring.alert.input.audit.end.dttm");/*청강 종료 일시를 입력해 주세요.*/
        rejectIfBlank(errors, "mrkProcSdttm", vo.getMrkProcSdttm(), "crs.sbjct.ofring.alert.input.mrk.proc.period");/*성적 처리 기간의 시작일과 종료일을 입력해 주세요.*/
        rejectIfBlank(errors, "mrkProcEdttm", vo.getMrkProcEdttm(), "crs.sbjct.ofring.alert.input.mrk.proc.period");/*성적 처리 기간의 시작일과 종료일을 입력해 주세요.*/

        rejectIfNull(errors, "crdts", vo.getCrdts(), "crs.sbjct.ofring.alert.input.crdts");/*학점을 입력해 주세요.*/
        rejectIfNull(errors, "dvclasNo", vo.getDvclasNo(), "crs.sbjct.ofring.alert.select.dvclas");/*분반을 1반부터 10반 사이로 선택해 주세요.*/
        rejectIfNull(errors, "lctrPrvwWkno", vo.getLctrPrvwWkno(), "crs.sbjct.ofring.alert.select.week");/*주차를 올바르게 선택해 주세요.*/

        if ("Y".equals(vo.getLimitYn())) {
            rejectIfNull(errors, "atndlcQuota", vo.getAtndlcQuota(), "crs.sbjct.ofring.alert.input.quota");/*수강정원은 0 이상으로 입력해 주세요.*/
        }
        if ("PASSFAIL".equals(vo.getEvlGbncd())) {
            rejectIfNull(errors, "passfailScr", vo.getPassfailScr(), "crs.sbjct.ofring.alert.input.passfail.scr");/*PASS/FAIL 점수를 0점부터 100점 사이로 입력해 주세요.*/
        }
        if ("PRD_STNG".equals(vo.getRvwPsblGbncd())) {
            rejectIfBlank(errors, "rvwSdttm", vo.getRvwSdttm(), "crs.sbjct.ofring.alert.input.rvw.period");/*복습기간의 시작일과 종료일을 입력해 주세요.*/
            rejectIfBlank(errors, "rvwEdttm", vo.getRvwEdttm(), "crs.sbjct.ofring.alert.input.rvw.period");/*복습기간의 시작일과 종료일을 입력해 주세요.*/
        }

        validateMaxByteLength(vo, errors);
        validateFormat(vo, errors);
        validateNumberRange(vo, errors);
    }

    // 과목개설 저장 필드의 최대 바이트 길이를 검증한다.
    private void validateMaxByteLength(SbjctVO vo, Errors errors) {
        rejectIfOverMaxByte(errors, "sbjctCd", vo.getSbjctCd(), LEN_SBJCT_CD, "crs.label.subject.code");/*과목코드*/
        rejectIfOverMaxByte(errors, "sbjctnm", vo.getSbjctnm(), LEN_NAME, "crs.sbjct.ofring.label.subject.ko");/*과목명(KO)*/
        rejectIfOverMaxByte(errors, "sbjctExpln", vo.getSbjctExpln(), LEN_EXPLN, "crs.lecture.explain");/*과목설명*/
        rejectIfOverMaxByte(errors, "sbjctEnnm", vo.getSbjctEnnm(), LEN_NAME, "crs.sbjct.ofring.label.subject.en");/*과목명(EN)*/
        rejectIfOverMaxByte(errors, "dvclasNcknm", vo.getDvclasNcknm(), LEN_NAME, "crs.sbjct.ofring.label.dvclas.alias");/*분반 별칭*/
    }

    // 과목개설 저장 필드의 값 형식을 검증한다.
    private void validateFormat(SbjctVO vo, Errors errors) {
        if (!isBlank(vo.getSbjctCd()) && !vo.getSbjctCd().matches("[A-Za-z0-9]+")) {
            errors.rejectValue("sbjctCd", "crs.sbjct.alert.input.code.format");/*과목코드는 영문과 숫자만 입력해 주세요.*/
        }
        if (!isBlank(vo.getUseyn()) && !isYn(vo.getUseyn())) {
            errors.rejectValue("useyn", "crs.sbjct.alert.select.useyn");/*사용여부를 선택해 주세요.*/
        }
        if (!isBlank(vo.getLctrEvlyn()) && !isYn(vo.getLctrEvlyn())) {
            errors.rejectValue("lctrEvlyn", "crs.sbjct.ofring.alert.select.lctr.evl");/*강의평가 여부를 선택해 주세요.*/
        }

        rejectIfInvalidDttm(errors, "atndlcAplySdttm", vo.getAtndlcAplySdttm());
        rejectIfInvalidDttm(errors, "atndlcAplyEdttm", vo.getAtndlcAplyEdttm());
        rejectIfInvalidDttm(errors, "sbjctLctrSdttm", vo.getSbjctLctrSdttm());
        rejectIfInvalidDttm(errors, "sbjctLctrEdttm", vo.getSbjctLctrEdttm());
        rejectIfInvalidDttm(errors, "sbjctLateRecgDttm", vo.getSbjctLateRecgDttm());
        rejectIfInvalidDttm(errors, "auditEdttm", vo.getAuditEdttm());
        rejectIfInvalidDttm(errors, "mrkProcSdttm", vo.getMrkProcSdttm());
        rejectIfInvalidDttm(errors, "mrkProcEdttm", vo.getMrkProcEdttm());
        rejectIfInvalidDttm(errors, "rvwSdttm", vo.getRvwSdttm());
        rejectIfInvalidDttm(errors, "rvwEdttm", vo.getRvwEdttm());
    }

    // 과목개설 숫자 입력값의 허용 범위를 검증한다.
    private void validateNumberRange(SbjctVO vo, Errors errors) {
        if (vo.getCrdts() != null && (vo.getCrdts() < 0 || vo.getCrdts() > 999)) {
            errors.rejectValue("crdts", "crs.sbjct.ofring.alert.input.crdts");/*학점을 입력해 주세요.*/
        }
        if (vo.getDvclasNo() != null && (vo.getDvclasNo() < 1 || vo.getDvclasNo() > 10)) {
            errors.rejectValue("dvclasNo", "crs.sbjct.ofring.alert.select.dvclas");/*분반을 1반부터 10반 사이로 선택해 주세요.*/
        }
        if (vo.getAtndlcQuota() != null && vo.getAtndlcQuota() < 0) {
            errors.rejectValue("atndlcQuota", "crs.sbjct.ofring.alert.input.quota");/*수강정원은 0 이상으로 입력해 주세요.*/
        }
        if (vo.getLctrPrvwWkno() != null && vo.getLctrPrvwWkno() < 0) {
            errors.rejectValue("lctrPrvwWkno", "crs.sbjct.ofring.alert.select.week");/*주차를 올바르게 선택해 주세요.*/
        }
        if (vo.getPassfailScr() != null && (vo.getPassfailScr().compareTo(BigDecimal.ZERO) < 0
                || vo.getPassfailScr().compareTo(new BigDecimal("100")) > 0)) {
            errors.rejectValue("passfailScr", "crs.sbjct.ofring.alert.input.passfail.scr");/*PASS/FAIL 점수를 0점부터 100점 사이로 입력해 주세요.*/
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
    private void rejectIfOverMaxByte(Errors errors, String field, String value, int maxBytes, String labelMessageCode) {
        if (isBlank(value) || byteLength(value) <= maxBytes) {
            return;
        }
        errors.rejectValue(field, "forum.alert.input.max.byte", new Object[] { new DefaultMessageSourceResolvable(labelMessageCode), maxBytes }, null);/*{0}은 {1} byte를 초과하여 입력할 수 없습니다.*/
    }

    // 일시 값은 yyyyMMddHHmmss 형식일 때만 허용한다.
    private void rejectIfInvalidDttm(Errors errors, String field, String value) {
        if (!isBlank(value) && (value.length() != LEN_DTTM || !value.matches("\\d{14}"))) {
            errors.rejectValue(field, "crs.sbjct.ofring.alert.input.datetime");/*기간/일시 값이 올바르지 않습니다.*/
        }
    }

    // 문자열의 UTF-8 바이트 길이를 계산한다.
    private int byteLength(String value) {
        return value.getBytes(StandardCharsets.UTF_8).length;
    }

    // Y/N 값인지 확인한다.
    private boolean isYn(String value) {
        return "Y".equals(value) || "N".equals(value);
    }

    // 문자열이 null 이거나 공백인지 확인한다.
    private boolean isBlank(String value) {
        return value == null || value.trim().length() == 0;
    }
}

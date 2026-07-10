package knou.lms.forum2.web.validation;

import java.nio.charset.StandardCharsets;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import knou.lms.forum2.vo.DscsDvclasSelVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.forum2.vo.DscsTeamGrpVO;
import knou.lms.forum2.vo.DscsVO;

@Component("dscsSaveValidator")
public class DscsSaveValidator implements Validator {

    private static final int LEN_ID = 30;
    private static final int LEN_CODE = 10;
    private static final int LEN_EVL_SCR_TYCD = 30;
    private static final int LEN_TITLE = 4000;
    private static final int LEN_CONTENTS = 4000;
    private static final int LEN_DTTM = 14;
    private static final int LEN_DVCLAS_NO = 3;
    private static final int LEN_YN = 1;

    /**
     * DscsVO 검증을 지원하는 Validator 인지 확인한다.
     */
    @Override
    public boolean supports(Class<?> clazz) {
        return DscsVO.class.isAssignableFrom(clazz);
    }

    /**
     * 토론 저장 공통 항목을 검증한다.
     */
    @Override
    public void validate(Object target, Errors errors) {
        if (!(target instanceof DscsVO)) {
            errors.reject("fail.common.msg"); // 에러가 발생했습니다!
            return;
        }
        validateCommon((DscsVO) target, errors);
    }

    /**
     * 토론 등록 시 필요한 공통 항목과 분반, 팀토론 정보를 검증한다.
     */
    public void validateForRegist(DscsVO vo, Errors errors) {
        validate(vo, errors);
        if (vo == null) {
            return;
        }

        Set<String> checkedDvclasNos = getCheckedDvclasNos(vo);
        if (checkedDvclasNos.isEmpty()) {
            errors.reject("forum.alert.select.dvclas"); // 등록할 분반을 선택해 주세요.
        }

        if (isTeamDiscussion(vo)) {
            validateTeamDiscussion(vo, checkedDvclasNos, true, errors);
        }
    }

    /**
     * 토론 수정 시 필요한 공통 항목과 토론 ID, 팀토론 정보를 검증한다.
     */
    public void validateForModify(DscsVO vo, Errors errors) {
        if (vo == null) {
            errors.reject("fail.common.msg"); // 에러가 발생했습니다!
            return;
        }
        if (isBlank(vo.getDscsId())) {
            errors.rejectValue("dscsId", "forum.alert.input.dscs.id"); // 토론 ID가 필요합니다.
        }

        validate(vo, errors);

        if (isTeamDiscussion(vo)) {
            validateTeamDiscussion(vo, getCheckedDvclasNos(vo), false, errors);
        }
    }

    /**
     * 등록/수정에서 공통으로 필요한 필수값, 일시 형식, DB 길이를 검증한다.
     */
    private void validateCommon(DscsVO vo, Errors errors) {
        if (vo == null) {
            errors.reject("fail.common.msg"); // 에러가 발생했습니다!
            return;
        }

        rejectIfBlank(errors, "dscsTtl", vo.getDscsTtl(), "forum.alert.input.forum_title"); // 토론명을 입력하세요.
        rejectIfBlank(errors, "dscsCts", vo.getDscsCts(), "forum.alert.input.forum_content"); // 토론 내용을 입력하세요.
        rejectIfBlank(errors, "dscsSdttm", vo.getDscsSdttm(), "forum.alert.input.forum_start_date"); // 토론 시작일을 입력하세요.
        rejectIfBlank(errors, "dscsEdttm", vo.getDscsEdttm(), "forum.alert.input.forum_end_date"); // 토론 종료일을 입력하세요.
        rejectIfBlank(errors, "mrkRfltyn", vo.getMrkRfltyn(), "forum.alert.input.scoreAplyYn"); // 성적 반영 여부를 선택하세요.
        rejectIfBlank(errors, "mrkOyn", vo.getMrkOyn(), "forum.alert.input.scoreOpenYn"); // 성적공개 여부를 선택하세요.
        rejectIfBlank(errors, "evlScrTycd", vo.getEvlScrTycd(), "forum.alert.input.evalCtgr"); // 평가 방법을 선택하세요.
        rejectIfBlank(errors, "dscsUnitTycd", vo.getDscsUnitTycd(), "forum.alert.input.dscs.unit.type"); // 토론 유형을 선택하세요.

        if (!isBlank(vo.getDscsSdttm()) && !isDscsDateTime(vo.getDscsSdttm())) {
            errors.rejectValue("dscsSdttm", "forum.alert.input.forum_start_date"); // 토론 시작일을 입력하세요.
        }
        if (!isBlank(vo.getDscsEdttm()) && !isDscsDateTime(vo.getDscsEdttm())) {
            errors.rejectValue("dscsEdttm", "forum.alert.input.forum_end_date"); // 토론 종료일을 입력하세요.
        }
        if (isDscsDateTime(vo.getDscsSdttm()) && isDscsDateTime(vo.getDscsEdttm())
                && vo.getDscsEdttm().compareTo(vo.getDscsSdttm()) <= 0) {
            errors.rejectValue("dscsEdttm", "forum.alert.invalid.dscs.date.range"); // 토론 종료일시는 시작일시보다 이후여야 합니다.
        }

        validateMaxByteLength(vo, errors);
    }

    /**
     * TB_LMS_DSCS 컬럼 크기를 기준으로 byte 길이를 검증한다.
     */
    private void validateMaxByteLength(DscsVO vo, Errors errors) {
        rejectIfOverMaxByte(errors, "dscsId", vo.getDscsId(), LEN_ID, "dscsId");
        rejectIfOverMaxByte(errors, "dscsUnitTycd", vo.getDscsUnitTycd(), LEN_CODE, "forum.label.forum.type", "dscsUnitTycd"); // 토론 구분
        rejectIfOverMaxByte(errors, "evlScrTycd", vo.getEvlScrTycd(), LEN_EVL_SCR_TYCD, "forum.label.evalCtgr", "evlScrTycd"); // 평가 방법
        rejectIfOverMaxByte(errors, "dscsTtl", vo.getDscsTtl(), LEN_TITLE, "forum.label.forum.title", "dscsTtl"); // 토론명
        rejectIfOverMaxByte(errors, "dscsCts", vo.getDscsCts(), LEN_CONTENTS, "forum.label.forum.content", "dscsCts"); // 토론내용
        rejectIfOverMaxByte(errors, "dscsSdttm", vo.getDscsSdttm(), LEN_DTTM, "dscsSdttm");
        rejectIfOverMaxByte(errors, "dscsEdttm", vo.getDscsEdttm(), LEN_DTTM, "dscsEdttm");
        rejectIfOverMaxByte(errors, "teamGrpId", vo.getTeamGrpId(), LEN_ID, "forum.label.teamSelect", "teamGrpId"); // 팀 분류 선택
        rejectIfOverMaxByte(errors, "mrkRfltyn", vo.getMrkRfltyn(), LEN_YN, "forum.label.scoreAplyYn", "mrkRfltyn"); // 성적 반영
        rejectIfOverMaxByte(errors, "mrkOyn", vo.getMrkOyn(), LEN_YN, "forum.label.scoreOpenYn", "mrkOyn"); // 성적 공개
        rejectIfOverMaxByte(errors, "sbjctId", vo.getSbjctId(), LEN_ID, "forum.label.subject", "sbjctId"); // 제목
        rejectIfOverMaxByte(errors, "dvclasNo", vo.getDvclasNo(), LEN_DVCLAS_NO, "dvclasNo");
        rejectIfOverMaxByte(errors, "byteamDscsUseyn", vo.getByteamDscsUseyn(), LEN_YN, "byteamDscsUseyn");

        validateTeamDetailMaxByteLength(vo, errors);
    }

    /**
     * 팀별 부주제 상세가 자식 토론으로 저장될 때의 DB 길이를 검증한다.
     */
    private void validateTeamDetailMaxByteLength(DscsVO vo, Errors errors) {
        if (vo.getTeamDscsDtlList() == null) {
            return;
        }

        for (int i = 0; i < vo.getTeamDscsDtlList().size(); i++) {
            DscsTeamDscsVO teamDscsVO = vo.getTeamDscsDtlList().get(i);
            if (teamDscsVO == null) {
                continue;
            }

            String prefix = "teamDscsDtlList[" + i + "]";
            rejectIfOverMaxByte(errors, prefix + ".dscsId", teamDscsVO.getDscsId(), LEN_ID, "dscsId");
            rejectIfOverMaxByte(errors, prefix + ".teamId", teamDscsVO.getTeamId(), LEN_ID, "forum.label.team", "teamId"); // 팀
            rejectIfOverMaxByte(errors, prefix + ".dscsTtl", teamDscsVO.getDscsTtl(), LEN_TITLE, "forum.label.team.ttl", "dscsTtl"); // 부주제
            rejectIfOverMaxByte(errors, prefix + ".dscsCts", teamDscsVO.getDscsCts(), LEN_CONTENTS, "forum.label.forum.content", "dscsCts"); // 토론내용
            rejectIfOverMaxByte(errors, prefix + ".teamGrpId", teamDscsVO.getTeamGrpId(), LEN_ID, "forum.label.teamSelect", "teamGrpId"); // 팀 분류 선택
            rejectIfOverMaxByte(errors, prefix + ".dvclasNo", teamDscsVO.getDvclasNo(), LEN_DVCLAS_NO, "dvclasNo");
            rejectIfOverMaxByte(errors, prefix + ".sbjctId", teamDscsVO.getSbjctId(), LEN_ID, "forum.label.subject", "sbjctId"); // 제목
        }
    }

    /**
     * 팀토론 저장에 필요한 팀그룹과 팀별 부주제 상세 존재 여부를 검증한다.
     */
    private void validateTeamDiscussion(DscsVO vo, Set<String> checkedDvclasNos, boolean regist, Errors errors) {
        List<DscsTeamGrpVO> teamGrpInfoList = vo.getTeamGrpInfoList();
        if (teamGrpInfoList == null || teamGrpInfoList.isEmpty()) {
            if (!regist && !isBlank(vo.getTeamGrpId())) {
                if ("Y".equalsIgnoreCase(vo.getByteamDscsUseyn()) && !hasAnyTeamDetail(vo)) {
                    errors.reject("forum.alert.input.team.dscs.detail"); // 학습그룹별 토론 설정 시 팀 목록이 필요합니다.
                }
                return;
            }
            errors.reject("forum.alert.select.team.ctgr"); // 팀 분류를 선택해 주세요.
            return;
        }

        if (regist) {
            for (String dvclasNo : checkedDvclasNos) {
                DscsTeamGrpVO teamGrpInfo = findTeamGrpInfo(teamGrpInfoList, dvclasNo);
                if (teamGrpInfo == null || isBlank(teamGrpInfo.getTeamGrpId())) {
                    errors.reject("forum.alert.select.team.ctgr"); // 팀 분류를 선택해 주세요.
                    return;
                }
                if ("Y".equalsIgnoreCase(teamGrpInfo.getByteamDscsUseyn()) && !hasTeamDetail(vo, dvclasNo)) {
                    errors.reject("forum.alert.input.team.dscs.detail"); // 학습그룹별 토론 설정 시 팀 목록이 필요합니다.
                    return;
                }
            }
        } else {
            boolean hasTeamGrp = false;
            for (DscsTeamGrpVO teamGrpInfo : teamGrpInfoList) {
                if (teamGrpInfo == null || isBlank(teamGrpInfo.getTeamGrpId())) {
                    continue;
                }
                hasTeamGrp = true;
                if ("Y".equalsIgnoreCase(teamGrpInfo.getByteamDscsUseyn()) && !hasTeamDetail(vo, teamGrpInfo.getDvclasNo())) {
                    errors.reject("forum.alert.input.team.dscs.detail"); // 학습그룹별 토론 설정 시 팀 목록이 필요합니다.
                    return;
                }
            }
            if (!hasTeamGrp && isBlank(vo.getTeamGrpId())) {
                errors.reject("forum.alert.select.team.ctgr"); // 팀 분류를 선택해 주세요.
            }
        }
    }

    /**
     * 분반 번호에 해당하는 팀그룹 설정 정보를 찾는다.
     */
    private DscsTeamGrpVO findTeamGrpInfo(List<DscsTeamGrpVO> teamGrpInfoList, String dvclasNo) {
        for (DscsTeamGrpVO teamGrpInfo : teamGrpInfoList) {
            if (teamGrpInfo != null && equalsValue(dvclasNo, teamGrpInfo.getDvclasNo())) {
                return teamGrpInfo;
            }
        }
        return null;
    }

    /**
     * 등록 화면에서 선택된 분반 번호 목록을 추출한다.
     */
    private Set<String> getCheckedDvclasNos(DscsVO vo) {
        Set<String> checkedDvclasNos = new HashSet<>();
        if (vo == null || vo.getDvclasSelList() == null) {
            return checkedDvclasNos;
        }
        for (DscsDvclasSelVO dvclasSelVO : vo.getDvclasSelList()) {
            if (dvclasSelVO != null && "Y".equalsIgnoreCase(dvclasSelVO.getCheckedYn()) && !isBlank(dvclasSelVO.getDvclasNo())) {
                checkedDvclasNos.add(dvclasSelVO.getDvclasNo().trim());
            }
        }
        return checkedDvclasNos;
    }

    /**
     * 지정 분반의 팀별 부주제 상세가 하나 이상 존재하는지 확인한다.
     */
    private boolean hasTeamDetail(DscsVO vo, String dvclasNo) {
        if (vo == null || vo.getTeamDscsDtlList() == null || vo.getTeamDscsDtlList().isEmpty()) {
            return false;
        }
        for (DscsTeamDscsVO teamDscsVO : vo.getTeamDscsDtlList()) {
            if (teamDscsVO == null || isBlank(teamDscsVO.getTeamId())) {
                continue;
            }
            if (isBlank(dvclasNo) || equalsValue(dvclasNo, teamDscsVO.getDvclasNo())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 분반 구분 없이 팀별 부주제 상세가 하나 이상 존재하는지 확인한다.
     */
    private boolean hasAnyTeamDetail(DscsVO vo) {
        return hasTeamDetail(vo, null);
    }

    /**
     * 토론 단위 유형이 팀토론인지 확인한다.
     */
    private boolean isTeamDiscussion(DscsVO vo) {
        return vo != null && ("TEAM".equalsIgnoreCase(vo.getDscsUnitTycd()) || "Y".equalsIgnoreCase(vo.getDscsUnitTycd()));
    }

    /**
     * 토론 일시 값이 yyyyMMddHHmm 형식인지 확인한다.
     */
    private boolean isDscsDateTime(String value) {
        return value != null && value.matches("\\d{12}");
    }

    /**
     * 필수값이 비어 있으면 지정한 메시지 코드로 오류를 추가한다.
     */
    private void rejectIfBlank(Errors errors, String field, String value, String code) {
        if (isBlank(value)) {
            errors.rejectValue(field, code);
        }
    }

    /**
     * 필드명이 그대로 표시되는 항목의 byte 초과 오류를 추가한다.
     */
    private void rejectIfOverMaxByte(Errors errors, String field, String value, int maxBytes, String defaultLabel) {
        rejectIfOverMaxByte(errors, field, value, maxBytes, null, defaultLabel);
    }

    /**
     * 메시지 라벨 코드가 있는 항목의 byte 초과 오류를 추가한다.
     */
    private void rejectIfOverMaxByte(Errors errors, String field, String value, int maxBytes, String labelCode, String defaultLabel) {
        if (isBlank(value) || byteLength(value) <= maxBytes) {
            return;
        }

        Object label = labelCode == null
                ? defaultLabel
                : new DefaultMessageSourceResolvable(new String[] { labelCode }, null, defaultLabel);
        errors.rejectValue(field, "forum.alert.input.max.byte", new Object[] { label, maxBytes }, null); // {0}은 {1} byte를 초과하여 입력할 수 없습니다.
    }

    /**
     * UTF-8 기준 byte 길이를 계산한다.
     */
    private int byteLength(String value) {
        return value.getBytes(StandardCharsets.UTF_8).length;
    }

    /**
     * 두 문자열을 trim 기준으로 비교한다.
     */
    private boolean equalsValue(String value1, String value2) {
        return value1 != null && value2 != null && value1.trim().equals(value2.trim());
    }

    /**
     * 문자열이 null 이거나 공백인지 확인한다.
     */
    private boolean isBlank(String value) {
        return value == null || value.trim().length() == 0;
    }
}

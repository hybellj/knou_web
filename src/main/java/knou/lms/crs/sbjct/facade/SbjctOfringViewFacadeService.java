package knou.lms.crs.sbjct.facade;

import knou.framework.context2.UserContext;
import knou.lms.crs.sbjct.vo.SbjctAtndlcVO;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctVO;

import java.util.Map;

/**
 * 일반 과목개설 화면에서 사용할 모델 속성 Map을 조립한다.
 */
public interface SbjctOfringViewFacadeService {

    /**
     * 일반 과목개설 목록 화면의 기관, 코드, 검색 기준 모델을 구성한다.
     */
    Map<String, Object> listView(SbjctListVO sbjctListVO, UserContext userCtx) throws Exception;

    /**
     * 일반 과목개설 등록/수정 화면의 기관, 코드, 기본 VO 모델을 구성한다.
     */
    Map<String, Object> registView(SbjctVO sbjctVO, String mode, UserContext userCtx) throws Exception;

    /**
     * 일반 과목개설 상세 화면에서 사용할 상세 VO 모델을 구성한다.
     */
    Map<String, Object> detailView(SbjctVO detailVO, UserContext userCtx);

    /**
     * 일반 과목개설 기본정보 팝업의 상세 VO와 관리자 목록 모델을 구성한다.
     */
    Map<String, Object> basicInfoPopView(SbjctVO detailVO, UserContext userCtx);

    /**
     * 주차 기간 설정 화면의 상세 VO와 기존 주차 설정 모델을 구성한다.
     */
    Map<String, Object> schdlRegistView(SbjctVO detailVO, UserContext userCtx);

    /**
     * 과목관리자 등록 화면의 관리자 목록과 코드 모델을 구성한다.
     */
    Map<String, Object> admRegistView(SbjctVO detailVO, UserContext userCtx) throws Exception;

    /**
     * 수강생 등록 화면의 수강생 목록과 기관 모델을 구성한다.
     */
    Map<String, Object> stdntRegistView(SbjctVO detailVO, UserContext userCtx) throws Exception;

    /**
     * 수강생 엑셀 업로드 팝업에서 사용할 기준 VO와 유효성 상태를 구성한다.
     */
    Map<String, Object> stdntExcelUploadPop(SbjctAtndlcVO vo, boolean validUploadContext);
}

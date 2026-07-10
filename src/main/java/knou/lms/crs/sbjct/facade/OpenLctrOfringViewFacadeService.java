package knou.lms.crs.sbjct.facade;

import knou.framework.context2.UserContext;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctVO;

import java.util.Map;

/**
 * 공개강좌개설 화면에서 사용할 모델 속성 Map을 조립한다.
 */
public interface OpenLctrOfringViewFacadeService {

    /**
     * 공개강좌개설 목록 화면의 기관, 코드, 검색 기준 모델을 구성한다.
     */
    Map<String, Object> listView(SbjctListVO sbjctListVO, UserContext userCtx) throws Exception;

    /**
     * 공개강좌개설 등록/수정 화면의 기관, 코드, 기본 VO 모델을 구성한다.
     */
    Map<String, Object> registView(SbjctVO sbjctVO, String mode, UserContext userCtx) throws Exception;

    /**
     * 공개강좌 관리자 등록 화면의 관리자 목록과 코드 모델을 구성한다.
     */
    Map<String, Object> admRegistView(SbjctVO detailVO, UserContext userCtx) throws Exception;

    /**
     * 공개강좌개설 상세 화면에서 사용할 상세 VO 모델을 구성한다.
     */
    Map<String, Object> detailView(SbjctVO detailVO, UserContext userCtx);

    /**
     * 공개강좌 기본정보 팝업의 상세 VO와 관리자 목록 모델을 구성한다.
     */
    Map<String, Object> basicInfoPopView(SbjctVO detailVO, UserContext userCtx);
}

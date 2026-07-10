package knou.lms.crs.sbjct.facade;

import knou.framework.context2.UserContext;
import knou.lms.crs.sbjct.vo.SbjctTmpltListVO;
import knou.lms.crs.sbjct.vo.SbjctTmpltVO;

import java.util.Map;

/**
 * 과목 템플릿 화면에서 사용할 모델 속성 Map을 조립한다.
 */
public interface SbjctTmpltViewFacadeService {

    /**
     * 과목 템플릿 목록 화면의 기관 목록과 검색 기준 모델을 구성한다.
     */
    Map<String, Object> listView(SbjctTmpltListVO sbjctTmpltListVO, UserContext userCtx) throws Exception;

    /**
     * 과목 템플릿 엑셀 업로드 팝업에서 사용할 기준 VO와 유효성 상태를 구성한다.
     */
    Map<String, Object> excelUploadPopView(SbjctTmpltVO vo, boolean validUploadContext);

    /**
     * 과목 템플릿 등록/수정 화면의 기관, 코드, 기본 VO 모델을 구성한다.
     */
    Map<String, Object> registView(SbjctTmpltVO vo, String mode, UserContext userCtx) throws Exception;
}

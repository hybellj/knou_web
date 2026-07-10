package knou.lms.contents.facade;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import knou.framework.context2.UserContext;
import knou.lms.contents.web.paging.ContsPageInfo;
import knou.lms.contents.web.paging.ContsExrcsQstnPageInfo;
import knou.lms.contents.web.paging.ContsSddnQstnPageInfo;
import knou.lms.contents.vo.LctrContsVO;
import knou.lms.contents.vo.LctrWknoSchdlVO;

public interface AdmContsViewFacadeService {

    /**
     * 관리자 콘텐츠 목록 화면에 필요한 기본 모델을 조립한다.
     * @param pageInfo
     * @param userCtx
     * @return
     * @throws Exception
     */
    Map<String, Object> listView(ContsPageInfo pageInfo, UserContext userCtx) throws Exception;

    /**
     * 강의주차일정 관리 팝업에 필요한 모델을 조립한다.
     * @param vo
     * @param userCtx
     * @return
     */
    Map<String, Object> lctrWknoSchdlMngPop(LctrWknoSchdlVO vo, UserContext userCtx);

    /**
     * 관리자 학습목차 동영상 등록 팝업에 필요한 모델을 조립한다.
     * @param lctrContsVO
     * @param request
     * @param userCtx
     * @return
     */
    Map<String, Object> lctrContsVideoRegistPop(LctrContsVO lctrContsVO, HttpServletRequest request, UserContext userCtx);

    /**
     * 관리자 학습목차 연습문제 등록 팝업에 필요한 모델을 조립한다.
     * @param lctrContsVO
     * @param userCtx
     * @return
     */
    Map<String, Object> lctrContsExrcsQstnRegistPop(LctrContsVO lctrContsVO, UserContext userCtx);

    /**
     * 관리자 학습목차 소셜 콘텐츠 등록 팝업에 필요한 모델을 조립한다.
     * @param lctrContsVO
     * @param request
     * @param userCtx
     * @return
     */
    Map<String, Object> lctrContsSnsRegistPop(LctrContsVO lctrContsVO, HttpServletRequest request, UserContext userCtx);

    /**
     * 관리자 학습목차 돌발퀴즈 선택 팝업에 필요한 모델을 조립한다.
     * @param pageInfo
     * @param userCtx
     * @return
     */
    Map<String, Object> lctrContsSddnQstnListPop(ContsSddnQstnPageInfo pageInfo, UserContext userCtx);

    /**
     * 관리자 학습목차 연습문제 선택 팝업에 필요한 모델을 조립한다.
     * @param pageInfo
     * @param userCtx
     * @return
     */
    Map<String, Object> lctrContsExrcsQstnListPop(ContsExrcsQstnPageInfo pageInfo, UserContext userCtx);
}

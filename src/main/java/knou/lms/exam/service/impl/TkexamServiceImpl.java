package knou.lms.exam.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.exam.dao.ExamDAO;
import knou.lms.exam.dao.ExampprDAO;
import knou.lms.exam.dao.QstnDAO;
import knou.lms.exam.dao.QstnVwitmDAO;
import knou.lms.exam.dao.TkexamAnswShtDAO;
import knou.lms.exam.dao.TkexamDAO;
import knou.lms.exam.dao.TkexamHstryDAO;
import knou.lms.exam.dao.TkexamRsltDAO;
import knou.lms.exam.service.TkexamService;
import knou.lms.exam.vo.ExamDtlVO;
import knou.lms.exam.vo.TkexamHstryVO;

@Service("tkexamService")
public class TkexamServiceImpl extends ServiceBase implements TkexamService {

	@Resource
	private TkexamDAO tkexamDAO;

	@Resource
	private TkexamHstryDAO tkexamHstryDAO;

	@Resource
	private TkexamAnswShtDAO tkexamAnswShtDAO;

	@Resource
	private ExampprDAO exampprDAO;

	@Resource
	private ExamDAO examDAO;

	@Resource
	private TkexamRsltDAO tkexamRsltDAO;

	@Resource
	private QstnDAO qstnDAO;

	@Resource
	private QstnVwitmDAO qstnVwitmDAO;

	/**
	* 퀴즈응시목록조회
	*
	* @param examBscId 		시험기본아이디
    * @param tkexamCmptnyn 	응시여부
    * @param evlyn 			평가여부
    * @param searchValue 	검색어(학과, 학번, 이름)
    * @param userId		 	사용자아이디
	* @return 퀴즈응시목록
	*/
	@Override
	public List<EgovMap> quizTkexamList(Map<String, Object> params) {
		return tkexamDAO.quizTkexamList(params);
	}

	/**
	* 퀴즈응시자조회
	*
	* @param examDtlId 	시험상세아이디
    * @param userId 	사용자이이디
	* @return 퀴즈응시자조회
	*/
	public EgovMap quizExamneeSelect(String examDtlId, String userId) {
		return tkexamDAO.quizExamneeSelect(examDtlId, userId);
	}

	/**
	* 퀴즈재응시설정
	*
	* @param List<ExamDtlVO>
	*/
	public void quizRetkexamSetting(List<ExamDtlVO> list) {
		// 1. 시험상세 재시험 일자, 적용률 수정
		examDAO.quizRetkexamListModify(list);

		// 2. 시험응시 재시험 수정
		for(ExamDtlVO vo : list) {
			vo.setSubParam(IdGenUtil.genNewId(IdPrefixType.TKEXM));
		}
		tkexamDAO.userListRetkexamSetting(list);

		// 3. 시험응시답안 삭제
		tkexamAnswShtDAO.userListTkexamAnswShtDelete(list);

		// 4. 시험지 삭제
		exampprDAO.userListExampprDelete(list);

		// 5. 시험지 등록
		exampprDAO.userListExampprRegist(list);

		// 6. 시험응시이력 재시험설정 이력 등록
		for(ExamDtlVO vo : list) {
			vo.setSubParam(IdGenUtil.genNewId(IdPrefixType.TKHTR));
		}
		tkexamHstryDAO.userListRetkexamHstryRegist(list);
	}

	/**
	* 퀴즈시험지초기화
	*
	* @param tkexamId 	시험응시아이디
	* @param examBscId 	시험기본아이디
	* @param examDtlId 	시험상세아이디
	* @param userId 	사용자아이디
	*/
	@Override
	public void quizExampprInit(Map<String, Object> params) {
		// 1. 응시정보 등록
		Object tkexamId = params.get("tkexamId");
		if(tkexamId == null || "null".equals(String.valueOf(tkexamId).trim().toLowerCase())) {
			params.put("tkexamId", IdGenUtil.genNewId(IdPrefixType.TKEXM));
			tkexamDAO.userTkexamRegist(params);
		}

		// 2. 초기화 전 사용자시험응시정보조회
		TkexamHstryVO hstryVO = tkexamHstryDAO.userTkexamInfoSelect(params);

		// 3. 시험응시이력 시험지부여 이력 등록
		hstryVO.setRgtrId((String) params.get("rgtrId"));
		hstryVO.setTkexamHstryId(IdGenUtil.genNewId(IdPrefixType.TKHTR));
		hstryVO.setTkexamEdttm(null);
		tkexamHstryDAO.userTkexamHstryRegist(hstryVO);

		// 4. 시험응시답안 삭제
		tkexamAnswShtDAO.userTkexamAnswShtDelete(params);

		// 5. 시험지 삭제
		exampprDAO.userExampprDelete(params);

		// 6. 시험지 등록
		exampprDAO.userExampprRegist(params);

		// 7. 시험응시결과 초기화
		tkexamRsltDAO.userTkexamRsltInit(params);

		// 8. 시험응시 초기화
		tkexamDAO.userTkexamInit(params);
	}

	/**
	* 사용자시험응시현황조회
	*
	* @param examBscId 	시험기본아이디
    * @param sbjctId 	과목이이디
	* @return 퀴즈응시현황조회
	*/
	@Override
	public EgovMap userTkexamStatusSelect(String examBscId, String sbjctId) {
		return tkexamDAO.userTkexamStatusSelect(examBscId, sbjctId);
	}

	/**
	* 학생퀴즈응시
	*
	* @param examBscId 	시험기본아이디
    * @param examDtlId 	시험상세여부
    * @param sbjctId 	과목아이디
    * @param userId		사용자아이디
	*/
	@Override
	public ResultDTO<EgovMap> stdntQuizTkexam(Map<String, Object> params) {
		ResultDTO<EgovMap> resultVO = new ResultDTO<EgovMap>();

		// 학생퀴즈응시정보조회
		EgovMap tkexamInfo = tkexamDAO.stdntQuizTkexamInfoSelect(params);
		if(tkexamInfo == null || tkexamInfo.isEmpty()) {
			// 퀴즈응시목록
			EgovMap stdnt = tkexamDAO.quizTkexamList(params).get(0);
			if(stdnt == null) {
				resultVO.setResultFailed();
				resultVO.setMessage("응시 대상자가 아닙니다.");
				return resultVO;
			} else {
				// 퀴즈시험지초기화
				quizExampprInit(params);
				// 학생퀴즈응시정보조회
				tkexamInfo = tkexamDAO.stdntQuizTkexamInfoSelect(params);
				params.put("tkexamId", tkexamInfo.get("tkexamId"));
			}
		} else {
			params.put("tkexamId", tkexamInfo.get("tkexamId"));
			// 시험응시시험지답안목록조회
			List<EgovMap> exampprList = exampprDAO.tkexamExampprAnswShtList(tkexamInfo.get("tkexamId").toString(), params.get("userId").toString());
			if(exampprList.size() == 0) {
				// 퀴즈시험지초기화
				quizExampprInit(params);
			}
		}

		// 학생시험응시결과 초기값 등록
		params.put("tkexamRsltId", IdGenUtil.genNewId(IdPrefixType.TKRST));
		tkexamRsltDAO.stdntTkexamRsltRegist(params);

		if("N".equals(tkexamInfo.get("tkexamPeriodyn"))) {
			resultVO.setResultFailed();
			resultVO.setMessage("퀴즈 응시기간이 아닙니다.");
			return resultVO;
		}

		if(Integer.parseInt(tkexamInfo.get("remainderTm").toString()) <= 0) {
			resultVO.setResultFailed();
			resultVO.setMessage("퀴즈 응시 시간을 초과하였습니다.");
			return resultVO;
		}

		if(tkexamInfo.get("tkexamEdttm") != null) {
			resultVO.setResultFailed();
			resultVO.setMessage("퀴즈 제출을 이미 완료하였습니다.");
			return resultVO;
		}

		EgovMap map = new EgovMap();
		map.put("tkexamInfo", tkexamInfo);
		// 학생시험지문항목록조회
		map.put("qstnList", qstnDAO.stdntExampprQstnList(params));
		// 학생시험지문항보기항목목록조회
		map.put("qstnVwitmList", qstnVwitmDAO.stdntExampprQstnVwitmList(params));
		// 학생시험지응시답안목록조회
		map.put("answShtList", tkexamAnswShtDAO.stdntExampprAnswShtList(params));

		// 학생퀴즈응시
		tkexamDAO.stdntQuizTkexam(params);

		// 사용자시험응시정보조회
		TkexamHstryVO hstryVO = tkexamHstryDAO.userTkexamInfoSelect(params);

		// 시험응시이력등록
		hstryVO.setRgtrId((String) params.get("userId"));
		hstryVO.setTkexamHstryId(IdGenUtil.genNewId(IdPrefixType.TKHTR));
		hstryVO.setTkexamIp(StringUtil.nvl(params.get("ip"), "0:0:0:0:0:0:0:1"));
		hstryVO.setExamHstryGbncd("TKEXAM_STRT");
		hstryVO.setTkexamEdttm(null);
		tkexamHstryDAO.userTkexamHstryRegist(hstryVO);

		resultVO.setResultSuccess();
		resultVO.setData(map);

		return resultVO;
	}

}

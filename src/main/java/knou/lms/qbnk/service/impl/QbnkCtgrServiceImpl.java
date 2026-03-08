package knou.lms.qbnk.service.impl;

import java.math.BigDecimal;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.qbnk.dao.QbnkCtgrDAO;
import knou.lms.qbnk.service.QbnkCtgrService;
import knou.lms.qbnk.vo.QbnkCtgrVO;

@Service("qbnkCtgrService")
public class QbnkCtgrServiceImpl extends ServiceBase implements QbnkCtgrService {

	@Resource(name="qbnkCtgrDAO")
	private QbnkCtgrDAO qbnkCtgrDAO;

	/**
	 * 교수문제은행분류목록조회
	 *
	 * @param userId 		사용자아이디
	 * @param sbjctId 		과목아이디
	 * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * return 문제은행분류 목록
	 * @throws Exception
	 */
	@Override
	public List<QbnkCtgrVO> profQbnkCtgrList(QbnkCtgrVO vo) throws Exception {
		return qbnkCtgrDAO.profQbnkCtgrList(vo);
	}

	/**
	 * 교수문제은행분류전체목록조회
	 *
	 * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * @param sbjctId 		과목아이디
	 * @param userRprsId 	사용자대표아이디
	 * @param searchValue 	검색어(분류명, 과목, 담당교수)
	 * return 문제은행분류 목록
	 * @throws Exception
	 */
	@Override
	public ProcessResultVO<EgovMap> profQbnkCtgrAllList(QbnkCtgrVO vo) throws Exception {
		PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        List<EgovMap> ctgrList = qbnkCtgrDAO.profQbnkCtgrAllList(vo);

        if(ctgrList.size() > 0) {
            paginationInfo.setTotalRecordCount(((BigDecimal) ctgrList.get(0).get("totalCnt")).intValue());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        resultVO.setReturnList(ctgrList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
	}

	/**
	 * 교수문제은행과목조회
	 *
	 * @param sbjctId 		과목아이디
	 * return 문제은행과목 정보
	 * @throws Exception
	 */
	@Override
	public EgovMap profQbnkSbjctSelect(String sbjctId) throws Exception {
		return qbnkCtgrDAO.profQbnkSbjctSelect(sbjctId);
	}

	/**
	 * 문제은행다음분류순번조회
	 *
	 * @param userRprsId 		사용자대표아이디
	 * @param upQbnkCtgrId 		상위문제은행분류아이디
	 * return 문제은행다음분류순번
	 * @throws Exception
	 */
	@Override
	public int qbnkNextCtgrSeqnoSelect(QbnkCtgrVO vo) throws Exception {
		return qbnkCtgrDAO.qbnkNextCtgrSeqnoSelect(vo);
	}

	/**
	* 문제은행분류등록
	*
	* @param QbnkCtgrVO
	* @throws Exception
	*/
	@Override
	public void qbnkCtgrRegist(QbnkCtgrVO vo) throws Exception {
		if("".equals(StringUtil.nvl(vo.getQbnkCtgrId()))) {
			vo.setQbnkCtgrId(IdGenUtil.genNewId(IdPrefixType.QBCTG));
		}
		qbnkCtgrDAO.qbnkCtgrRegist(vo);
	}

	/**
	 * 문제은행분류조회
	 *
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * return 문제은행분류 정보
	 * @throws Exception
	 */
	@Override
	public QbnkCtgrVO qbnkCtgrSelect(String qbnkCtgrId) throws Exception {
		return qbnkCtgrDAO.qbnkCtgrSelect(qbnkCtgrId);
	}

	/**
	 * 문제은행분류사용수조회
	 *
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * return 문제은행분류사용수
	 * @throws Exception
	 */
	public EgovMap qbnkCtgrUseCntSelect(String qbnkCtgrId) throws Exception {
		return qbnkCtgrDAO.qbnkCtgrUseCntSelect(qbnkCtgrId);
	}

	/**
	* 문제은행분류삭제
	*
	* @param QbnkCtgrVO
	* @throws Exception
	*/
	public void qbnkCtgrDelete(QbnkCtgrVO vo) throws Exception {
		// 문제은행분류순번수정
		qbnkCtgrDAO.qbnkCtgrSeqnoModify(vo);

		// 문제은행분류삭제
		qbnkCtgrDAO.qbnkCtgrDelete(vo);
	}

	/**
	 * 문제은행검색과목목록
	 *
	 * @param userId 	사용자아이디
	 * return 문제은행검색과목목록
	 * @throws Exception
	 */
	public List<EgovMap> qbnkSearchSbjctList(String userId) throws Exception {
		return qbnkCtgrDAO.qbnkSearchSbjctList(userId);
	}

	/**
	 * 문제은행검색교수목록
	 *
	 * return 문제은행검색교수목록
	 * @throws Exception
	 */
	public List<EgovMap> qbnkSearchProfList() throws Exception {
		return qbnkCtgrDAO.qbnkSearchProfList();
	}

}

package knou.lms.qbnk.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.qbnk.dao.QbnkCtgrDAO;
import knou.lms.qbnk.service.QbnkCtgrService;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.web.view.QbnkPageInfo;

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
	 */
	@Override
	public List<QbnkCtgrVO> profQbnkCtgrList(QbnkCtgrVO vo) {
		return qbnkCtgrDAO.profQbnkCtgrList(vo);
	}

	/**
	 * 교수문제은행분류전체목록조회
	 *
	 * @param upQbnkCtgrId 	상위문제은행분류아이디
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * @param sbjctId 		과목아이디
	 * @param userId 		사용자아이디
	 * @param searchValue 	검색어(분류명, 과목, 담당교수)
	 * @param searchKey 	검색키(현재 과목아이디)
	 * return 문제은행분류 목록
	 */
	@Override
	public ResultDTO<EgovMap> profQbnkCtgrAllList(QbnkPageInfo pageInfo) {
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(qbnkCtgrDAO.profQbnkCtgrAllList(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
	 * 교수문제은행과목조회
	 *
	 * @param sbjctId 		과목아이디
	 * return 문제은행과목 정보
	 */
	@Override
	public EgovMap profQbnkSbjctSelect(String sbjctId) {
		return qbnkCtgrDAO.profQbnkSbjctSelect(sbjctId);
	}

	/**
	 * 문제은행다음분류순번조회
	 *
	 * @param userId 			사용자아이디
	 * @param upQbnkCtgrId 		상위문제은행분류아이디
	 * return 문제은행다음분류순번
	 */
	@Override
	public int qbnkNextCtgrSeqnoSelect(QbnkCtgrVO vo) {
		return qbnkCtgrDAO.qbnkNextCtgrSeqnoSelect(vo);
	}

	/**
	* 문제은행분류등록
	*
	* @param QbnkCtgrVO
	*/
	@Override
	public void qbnkCtgrRegist(QbnkCtgrVO vo) {
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
	 */
	@Override
	public QbnkCtgrVO qbnkCtgrSelect(String qbnkCtgrId) {
		return qbnkCtgrDAO.qbnkCtgrSelect(qbnkCtgrId);
	}

	/**
	 * 문제은행분류사용수조회
	 *
	 * @param qbnkCtgrId 	문제은행분류아이디
	 * return 문제은행분류사용수
	 */
	public EgovMap qbnkCtgrUseCntSelect(String qbnkCtgrId) {
		return qbnkCtgrDAO.qbnkCtgrUseCntSelect(qbnkCtgrId);
	}

	/**
	* 문제은행분류삭제
	*
	* @param QbnkCtgrVO
	*/
	public void qbnkCtgrDelete(QbnkCtgrVO vo) {
		// 문제은행분류순번수정
		qbnkCtgrDAO.qbnkCtgrSeqnoModify(vo);

		// 문제은행분류삭제
		qbnkCtgrDAO.qbnkCtgrDelete(vo);
	}

	/**
	 * 문제은행검색과목목록
	 *
	 * @param sbjctId 	과목아이디
	 * return 문제은행검색과목목록
	 */
	public List<EgovMap> qbnkSearchSbjctList(String sbjctId) {
		return qbnkCtgrDAO.qbnkSearchSbjctList(sbjctId);
	}

	/**
	 * 문제은행검색교수목록
	 *
	 * return 문제은행검색교수목록
	 */
	public List<EgovMap> qbnkSearchProfList() {
		return qbnkCtgrDAO.qbnkSearchProfList();
	}

}

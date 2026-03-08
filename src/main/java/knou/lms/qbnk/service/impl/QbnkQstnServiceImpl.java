package knou.lms.qbnk.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.qbnk.dao.QbnkQstnDAO;
import knou.lms.qbnk.dao.QbnkQstnVwitmDAO;
import knou.lms.qbnk.service.QbnkQstnService;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.vo.QbnkQstnVwitmVO;

@Service("qbnkQstnService")
public class QbnkQstnServiceImpl extends ServiceBase implements QbnkQstnService {

	@Resource(name="qbnkQstnDAO")
	private QbnkQstnDAO qbnkQstnDAO;

	@Resource(name="qbnkQstnVwitmDAO")
	private QbnkQstnVwitmDAO qbnkQstnVwitmDAO;

	/**
	* 문제은행문항목록조회
	*
	* @param upQbnkCtgrId 	상위문제은행분류아이디
    * @param qbnkCtgrId 	문제은행분류아이디
    * @param sbjctId 		과목아이디
    * @param userId 		사용자아이디
    * @param searchValue 	검색어(문항제목)
	* @return 문제은행문항목록
	* @throws Exception
	*/
	@Override
	public ProcessResultVO<EgovMap> qbnkQstnList(Map<String, Object> params) throws Exception {
		PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo((Integer) params.get("pageIndex"));
        paginationInfo.setRecordCountPerPage(Integer.parseInt((String) params.get("listScale")));
        paginationInfo.setPageSize(Integer.parseInt((String) params.get("listScale")));

        params.put("firstIndex", paginationInfo.getFirstRecordIndex());
        params.put("lastIndex", paginationInfo.getLastRecordIndex());

        List<EgovMap> qstnList = qbnkQstnDAO.qbnkQstnList(params);

        if(qstnList.size() > 0) {
            paginationInfo.setTotalRecordCount(((BigDecimal) qstnList.get(0).get("totalCnt")).intValue());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        resultVO.setReturnList(qstnList);
        resultVO.setPageInfo(paginationInfo);

        return resultVO;
	}

	/**
     * 교수문항복사문제은행문항목록조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항목록
     * @throws Exception
     */
    @Override
    public List<EgovMap> profQstnCopyQbnkQstnList(QbnkQstnVO vo) throws Exception {
        return qbnkQstnDAO.profQstnCopyQbnkQstnList(vo);
    }

    /**
     * 문제은행문항조회
     *
     * @param qbnkCtgrId 	문제은행문항아이디
     * @return 문제은행문항
     * @throws Exception
     */
	public EgovMap qbnkQstnSelect(QbnkQstnVO vo) throws Exception {
		return qbnkQstnDAO.qbnkQstnSelect(vo);
	}

	/**
     * 문제은행문항등록
     *
     * @param QbnkQstnVO
     * @throws Exception
     */
    @Override
    public void qbnkQstnRegist(QbnkQstnVO vo) throws Exception {
    	// 1. 문항 등록
    	vo.setQbnkQstnId(IdGenUtil.genNewId(IdPrefixType.QBQSN));
    	vo.setQstnSeqno(qbnkQstnDAO.qbnkNextQstnSeqnoSelect(vo));
    	qbnkQstnDAO.qbnkQstnRegist(vo);

    	// 2. 문항보기항목 일괄등록
    	if (vo.getQstns() != null && !vo.getQstns().isEmpty()) {
            List<QbnkQstnVwitmVO> vwitmList = new ArrayList<QbnkQstnVwitmVO>();

            for (Map<String, Object> map : vo.getQstns()) {
            	QbnkQstnVwitmVO vwitm = new QbnkQstnVwitmVO();

            	vwitm.setQbnkQstnId(vo.getQbnkQstnId());
            	vwitm.setRgtrId(vo.getRgtrId());
            	vwitm.setQbnkQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QBQVW));
            	vwitm.setVwitmCts((String) map.get("vwitmCts"));
            	vwitm.setCransyn((String) map.get("cransyn"));
            	vwitm.setVwitmSeqno((Integer) map.get("vwitmSeqno"));

                vwitmList.add(vwitm);
            }
            qbnkQstnVwitmDAO.qbnkQstnVwitmBulkRegist(vwitmList);
        }
    }

    /**
     * 문제은행문항수정
     *
     * @param QbnkQstnVO
     * @throws Exception
     */
    @Override
    public void qbnkQstnModify(QbnkQstnVO vo) throws Exception {
    	// 1. 문항 수정
    	qbnkQstnDAO.qbnkQstnModfiy(vo);

    	// 2. 기존 문항보기항목 삭제
    	qbnkQstnVwitmDAO.qbnkQstnVwitmDelete(vo);

    	// 3. 신규 문항보기항목 일괄등록
    	if (vo.getQstns() != null && !vo.getQstns().isEmpty()) {
    		List<QbnkQstnVwitmVO> vwitmList = new ArrayList<QbnkQstnVwitmVO>();

    		for (Map<String, Object> map : vo.getQstns()) {
    			QbnkQstnVwitmVO vwitm = new QbnkQstnVwitmVO();

    			vwitm.setQbnkQstnId(vo.getQbnkQstnId());
    			vwitm.setRgtrId(vo.getRgtrId());
    			vwitm.setQbnkQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QBQVW));
    			vwitm.setVwitmCts((String) map.get("vwitmCts"));
    			vwitm.setCransyn((String) map.get("cransyn"));
    			vwitm.setVwitmSeqno((Integer) map.get("vwitmSeqno"));

    			vwitmList.add(vwitm);
    		}
    		qbnkQstnVwitmDAO.qbnkQstnVwitmBulkRegist(vwitmList);
    	}
    }

    /**
	 * 문제은행문항삭제
	 *
	 * @param QbnkQstnVO
	 * @throws Exception
	 */
	public void qbnkQstnDelete(QbnkQstnVO vo) throws Exception {
		// 1. 문제은행문항 삭제여부 수정
		qbnkQstnDAO.qbnkQstnDelynModify(vo);

		// 2. 문제은행문항 미삭제 순번 수정
		qbnkQstnDAO.qbnkQstnDelNSeqnoModify(vo);
	}

}

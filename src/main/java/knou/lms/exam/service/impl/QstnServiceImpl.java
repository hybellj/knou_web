package knou.lms.exam.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.lms.exam.dao.QstnDAO;
import knou.lms.exam.dao.QstnVwitmDAO;
import knou.lms.exam.service.QstnService;
import knou.lms.exam.vo.QstnVO;
import knou.lms.exam.vo.QstnVwitmVO;

@Service("qstnService")
public class QstnServiceImpl extends ServiceBase implements QstnService {

	@Resource(name="qstnDAO")
	private QstnDAO qstnDAO;

	@Resource(name="qstnVwitmDAO")
	private QstnVwitmDAO qstnVwitmDAO;

	/**
	 * 문항목록조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return 문항 목록
	 * @throws Exception
	 */
	@Override
	public List<QstnVO> qstnList(QstnVO vo) throws Exception {
		return qstnDAO.qstnList(vo);
	}

	/**
	 * 문항개수조회
	 *
	 * @param examDtlId 시험상세아이디
	 * return int
	 * @throws Exception
	 */
	@Override
	public int qstnCntSelect(QstnVO vo) throws Exception {
		return qstnDAO.qstnCntSelect(vo);
	}

	/**
     * 퀴즈문항등록
     *
     * @param QstnVO
     * @throws Exception
     */
    @Override
    public void quizQstnRegist(QstnVO vo) throws Exception {
    	// 1. 문항 등록
    	vo.setQstnId(IdGenUtil.genNewId(IdPrefixType.QSTN));
    	qstnDAO.qstnRegist(vo);

    	// 2. 문항보기항목 일괄등록
    	if (vo.getQstns() != null && !vo.getQstns().isEmpty()) {
            List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();

            for (Map<String, Object> map : vo.getQstns()) {
                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(vo.getQstnId());
                vwitm.setQstnVwitmGbncd(vo.getQstnGbncd());
                vwitm.setRgtrId(vo.getRgtrId());
                vwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
                vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
                vwitm.setCransYn((String) map.get("cransYn"));
                vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));

                vwitmList.add(vwitm);
            }
            qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);
        }
    }

    /**
     * 퀴즈문항수정
     *
     * @param QstnVO
     * @throws Exception
     */
    @Override
    public void quizQstnModify(QstnVO vo) throws Exception {
    	// 1. 문항 수정
    	qstnDAO.qstnModify(vo);

    	// 2. 기존 문항보기항목 삭제
    	QstnVwitmVO vwitmDeleteVO = new QstnVwitmVO();
    	vwitmDeleteVO.setQstnId(vo.getQstnId());
    	qstnVwitmDAO.qstnVwitmDelete(vwitmDeleteVO);

    	// 3. 신규 문항보기항목 일괄등록
        if (vo.getQstns() != null && !vo.getQstns().isEmpty()) {
            List<QstnVwitmVO> vwitmList = new ArrayList<QstnVwitmVO>();

            for (Map<String, Object> map : vo.getQstns()) {
                QstnVwitmVO vwitm = new QstnVwitmVO();
                vwitm.setQstnId(vo.getQstnId());
                vwitm.setQstnVwitmGbncd(vo.getQstnGbncd());
                vwitm.setRgtrId(vo.getRgtrId());
                vwitm.setQstnVwitmId(IdGenUtil.genNewId(IdPrefixType.QSVW));
                vwitm.setQstnVwitmCts((String) map.get("qstnVwitmCts"));
                vwitm.setCransYn((String) map.get("cransYn"));
                vwitm.setQstnVwitmSeqno((Integer) map.get("qstnVwitmSeqno"));

                vwitmList.add(vwitm);
            }
            qstnVwitmDAO.qstnVwitmBulkRegist(vwitmList);
        }
    }

    /**
     * 문항순번수정
     *
     * @param examDtlId 		시험상세아이디
     * @param qstnSeqno 		변경할 문항순번
     * @param searchKey 		문항순번
     * @throws Exception
     */
    @Override
    public void qstnSeqnoModify(QstnVO vo) throws Exception {
    	qstnDAO.qstnSeqnoModify(vo);
    }

    /**
	 * 문항후보순번수정
	 *
	 * @param examDtlId 		시험상세아이디
	 * @param qstnId	 		문항아이디
	 * @param qstnSeqno 		문항순번
	 * @param qstnCnddtSeqno 	변경할 문항후보순번
	 * @throws Exception
	 */
    @Override
	public void qstnCnddtSeqnoModify(QstnVO vo) throws Exception {
		qstnDAO.qstnCnddtSeqnoModify(vo);
	}

	/**
	 * 문항정보조회
	 *
	 * @param examDtlId 시험상세아이디
	 * @param qstnId 	문항아이디
	 * return 문항 정보
	 * @throws Exception
	 */
    @Override
	public QstnVO qstnSelect(QstnVO vo) throws Exception {
		QstnVO qstn = qstnDAO.qstnSelect(vo);
		if(qstn != null) {
			QstnVwitmVO vwitm = new QstnVwitmVO();
			vwitm.setQstnId(qstn.getQstnId());
			List<QstnVwitmVO> vwitmList = qstnVwitmDAO.qstnVwitmList(vwitm);
			qstn.setVwitmList(vwitmList);
		}

		return qstn;
	}

	/**
     * 퀴즈문항삭제
     *
     * @param QstnVO
     * @throws Exception
     */
    @Override
    public void quizQstnDelete(QstnVO vo) throws Exception {
    	// 1. 문항 삭제여부 수정
    	qstnDAO.qstnDelynModify(vo);

    	// 2. 문항 미삭제 순번 수정
    	qstnDAO.qstnDelNSeqnoModify(vo);
    }

    /**
     * 퀴즈문항점수수정
     *
     * @param examDtlId		시험상세아이디
     * @throws Exception
     */
    @Override
    public void quizQstnScrModify(QstnVO vo) throws Exception {
    	qstnDAO.quizQstnScrModify(vo);
    }

    /**
	 * 퀴즈문항점수일괄수정
	 *
	 * @param examDtlId		시험상세아이디
	 * @throws Exception
	 */
    @Override
	public void quizQstnScrBulkModify(QstnVO vo) throws Exception {
    	qstnDAO.quizQstnScrBulkModify(vo);
	}

    /**
     * 교수문항복사퀴즈문항목록조회
     *
     * @param examDtlId 	시험상세아이디
     * @return 퀴즈문항목록
     * @throws Exception
     */
    @Override
	public List<EgovMap> profQstnCopyQuizQstnList(QstnVO vo) throws Exception {
    	return qstnDAO.profQstnCopyQuizQstnList(vo);
    }

}

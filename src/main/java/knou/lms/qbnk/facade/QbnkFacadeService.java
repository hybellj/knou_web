package knou.lms.qbnk.facade;

import knou.framework.context2.UserContext;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.web.view.QbnkMainView;
import knou.lms.qbnk.web.view.QbnkPageInfo;

public interface QbnkFacadeService {

	QbnkMainView loadProfQbnkListView(QbnkCtgrVO vo);

	QbnkMainView getProfQbnkCtgrList(QbnkCtgrVO vo);

	QbnkMainView getProfQbnkQstnList(QbnkPageInfo pageInfo);

	QbnkMainView loadProfQbnkQstnViewPopup(QbnkQstnVO vo);

	QbnkMainView loadProfQbnkQstnRegistView(QbnkCtgrVO vo, UserContext userCtx);

	void qbnkQstnRegist(QbnkQstnVO vo, String qstnsStr);

	QbnkMainView loadProfQbnkQstnModifyView(QbnkQstnVO vo, UserContext userCtx);

	void qbnkQstnModify(QbnkQstnVO vo, String qstnsStr);

	void qbnkQstnDelete(QbnkQstnVO vo);

	QbnkMainView loadProfQbnkCtgrMngView(QbnkCtgrVO vo);

	QbnkMainView getProfQbnkCtgrAllList(QbnkPageInfo pageInfo);

	Integer getQbnkNextCtgrSeqnoSelect(QbnkCtgrVO vo);

	void qbnkCtgrRegist(QbnkCtgrVO vo);

	QbnkMainView getQbnkCtgrSelect(QbnkCtgrVO vo);

	QbnkMainView getQbnkCtgrUseCntSelect(QbnkCtgrVO vo);

	void qbnkCtgrDelete(QbnkCtgrVO vo);

	QbnkMainView getProfQstnCopyQbnkQstnList(QbnkQstnVO vo);

}

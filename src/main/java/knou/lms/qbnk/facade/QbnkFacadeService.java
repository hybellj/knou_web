package knou.lms.qbnk.facade;

import knou.framework.context2.UserContext;
import knou.lms.qbnk.vo.QbnkCtgrVO;
import knou.lms.qbnk.vo.QbnkQstnVO;
import knou.lms.qbnk.web.view.QbnkMainView;

public interface QbnkFacadeService {

	public QbnkMainView loadProfQbnkListView(QbnkCtgrVO vo) throws Exception;

	public QbnkMainView loadProfQbnkQstnViewPopup(QbnkQstnVO vo) throws Exception;

	public QbnkMainView loadProfQbnkQstnRegistView(QbnkCtgrVO vo, UserContext userCtx) throws Exception;

	public QbnkMainView loadProfQbnkQstnModifyView(QbnkQstnVO vo, UserContext userCtx) throws Exception;

	public QbnkMainView loadProfQbnkCtgrMngView(QbnkCtgrVO vo) throws Exception;


}

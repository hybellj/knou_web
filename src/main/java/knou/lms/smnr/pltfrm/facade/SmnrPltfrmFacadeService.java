package knou.lms.smnr.pltfrm.facade;

import java.util.List;
import java.util.Map;

import knou.lms.smnr.pltfrm.vo.OnlnPltfrmStngVO;
import knou.lms.smnr.pltfrm.web.view.SmnrPltfrmMainView;
import knou.lms.smnr.web.view.SmnrPageInfo;

public interface SmnrPltfrmFacadeService {

	SmnrPltfrmMainView loadAdmZoomAuthrtUserMngView();

	SmnrPltfrmMainView getOnlnPltfrmAuthrtList(OnlnPltfrmStngVO vo, SmnrPageInfo pageInfo);

	SmnrPltfrmMainView loadAdmAcntRegistPopup();

	SmnrPltfrmMainView admAcntRegist(OnlnPltfrmStngVO vo);

	void admAtncDelete(OnlnPltfrmStngVO vo);

	int createZoomCntSelect(OnlnPltfrmStngVO vo);

	SmnrPltfrmMainView loadAdmZoomAuthrtListSyncPopup(OnlnPltfrmStngVO vo);

	int getPendingOnlnPltfrmUserCntSelect(List<Map<String, Object>> subSmnrs);

	int zoomUserBulkRegist(OnlnPltfrmStngVO vo);

}

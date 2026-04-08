package knou.lms.smnr.pltfrm.facade;

import java.util.List;
import java.util.Map;

public interface SmnrPltfrmFacadeService {

	int getPendingOnlnPltfrmUserCntSelect(List<Map<String, Object>> subSmnrs) throws Exception;

}

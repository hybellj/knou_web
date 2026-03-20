package knou.lms.dashboard.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.web.view.BoardViewModel;

public class DashboardViewModel extends BoardViewModel {
	
	List<EgovMap>	lctrSbjctSummaryList;

	public List<EgovMap> getLctrSbjctSummaryList() {
		return lctrSbjctSummaryList;
	}

	public void setLctrSbjctSummaryList(List<EgovMap> lctrSbjctSummaryList) {
		this.lctrSbjctSummaryList = lctrSbjctSummaryList;
	}
}
package knou.lms.dashboard.web.view;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.web.view.BoardViewModel;

public class DashboardViewModel extends BoardViewModel {
	
	List<EgovMap>	profLctrSbjctSummaryList;

	public List<EgovMap> getProfLctrSbjctSummaryList() {
		return profLctrSbjctSummaryList;
	}

	public void setProfLctrSbjctSummaryList(List<EgovMap> profLctrSbjctSummaryList) {
		this.profLctrSbjctSummaryList = profLctrSbjctSummaryList;
	}
}
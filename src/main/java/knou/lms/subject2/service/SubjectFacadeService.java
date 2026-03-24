package knou.lms.subject2.service;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.BaseParam;
import knou.lms.subject2.web.view.SubjectViewModel;

public interface SubjectFacadeService { 

	public SubjectViewModel getSubjectViewModel(UserContext userCtx, BaseParam param) throws Exception ;
	
	public SubjectViewModel cmmonSubjectViewModel(BaseParam param) throws Exception ;
	
	public SubjectViewModel stdntSubjectViewModel(BaseParam param) throws Exception ;
	
	public SubjectViewModel profSubjectViewModel(BaseParam param) throws Exception ;
}
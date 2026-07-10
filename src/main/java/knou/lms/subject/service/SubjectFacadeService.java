package knou.lms.subject.service;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.subject.web.view.SubjectViewModel;

public interface SubjectFacadeService { 

	public SubjectViewModel getSubjectViewModel(UserContext userCtx, String sbjctId);
	
	public SubjectViewModel cmmonSubjectViewModel(SubjectDTO sbjctDto);
	
	public SubjectViewModel stdntSubjectViewModel(SubjectDTO sbjctDto);
	
	public SubjectViewModel profSubjectViewModel(SubjectDTO sbjctDto);
}
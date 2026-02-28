package knou.lms.subject2.facade;

import knou.framework.context2.UserContext;
import knou.lms.subject2.web.view.SubjectMainResponse;

public interface SubjectFacadeService { 
	public SubjectMainResponse loadSubjectMainView(UserContext userCtx, String subjectId) throws Exception ;   
}
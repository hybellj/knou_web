package knou.lms.mrk.service;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.context2.UserContext;
import knou.lms.mrk.vo.MarkObjectionApplyView;
import knou.lms.mrk.vo.MarkSubjectDetailView;
import knou.lms.mrk.vo.MarkView;

public interface MarkFacadeService {
	
	EgovMap loadFilterOptions(UserContext userCtx);

    Map<String, String> getMrkObjctAplyPrd(String orgId);

    MarkSubjectDetailView getStdMrkSbjctDtl(String orgId, String sbjctId, String userId);

    MarkSubjectDetailView getStdMrkSbjctSts(String sbjctId, String userId);

    MarkObjectionApplyView getStdMrkObjctAply(String sbjctId, UserContext ctx, String mrkObjctAplyId);

	MarkView getMarkActvInfoSelect(String sbjctId, UserContext userCtx) ;	
}
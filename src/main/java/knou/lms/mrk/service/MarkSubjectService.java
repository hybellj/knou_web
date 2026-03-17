package knou.lms.mrk.service;

import knou.lms.mrk.vo.MarkSubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MarkSubjectService {

    List<EgovMap> stdMrkList(MarkSubjectVO mrkSbjctVO) throws Exception;
}

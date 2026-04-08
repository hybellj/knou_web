package knou.lms.mrk.service;

import knou.lms.mrk.vo.MarkObjectionApplyVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MarkObjectionApplyService {

    List<EgovMap> mrkObjctAplyList(String sbjctId);

    MarkObjectionApplyVO mrkObjctAplySelect(String mrkObjctAplyId) throws Exception;
}

package knou.lms.mrk.service.impl;

import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.service.impl.SysFileServiceImpl;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.mrk.dao.MarkObjectionApplyDAO;
import knou.lms.mrk.service.MarkObjectionApplyService;
import knou.lms.mrk.vo.MarkObjectionApplyVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service("markObjectApplyService")
public class MarkObjectionApplyServiceImpl implements MarkObjectionApplyService {

    @Resource(name = "markObjectionApplyDAO")
    private MarkObjectionApplyDAO markObjectionApplyDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    /**
     * 성적이의신청 목록 조회
     * @param sbjctId
     * @return
     */
    @Override
    public List<EgovMap> mrkObjctAplyList(String sbjctId) {
        return markObjectionApplyDAO.mrkObjctAplyList(sbjctId);
    }

    @Override
    public MarkObjectionApplyVO mrkObjctAplySelect(String mrkObjctAplyId) throws Exception {

        MarkObjectionApplyVO vo = markObjectionApplyDAO.mrkObjctAplySelect(mrkObjctAplyId);

        if (vo.getFileCnt() > 0) {
            AtflVO atflVO = new AtflVO();
            atflVO.setRefId(vo.getMrkObjctAplyId());

            List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
            vo.setFileList(fileList);
        }

        return vo;
    }
}

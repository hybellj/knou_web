package knou.lms.smnr.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.smnr.dao.SmnrFdbkDAO;
import knou.lms.smnr.service.SmnrFdbkService;
import knou.lms.smnr.vo.SmnrFdbkVO;

@Service("smnrFdbkService")
public class SmnrFdbkServiceImpl extends ServiceBase implements SmnrFdbkService {

	@Resource(name="smnrFdbkDAO")
	private SmnrFdbkDAO smnrFdbkDAO;

	@Resource(name="attachFileService")
    private AttachFileService attachFileService;

	/**
     * 세미나피드백등록
     *
     * @param SmnrFdbkVO	세미나피드백정보
     * @param fdbkUsersStr	피드백사용자목록
     */
	@Override
    public void smnrFdbkRegist(SmnrFdbkVO vo, String fdbkUsersStr) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> fdbkUserList = null;

		try {
			fdbkUserList = mapper.readValue(fdbkUsersStr, new TypeReference<List<Map<String, Object>>>() {});
        } catch(JsonProcessingException e) {
            e.printStackTrace();
        }

		// 세미나피드백일괄등록
		List<SmnrFdbkVO> fdbkList = new ArrayList<SmnrFdbkVO>();	// 일괄등록용
		for(Map<String, Object> user : fdbkUserList) {
			SmnrFdbkVO fdbk = new SmnrFdbkVO();
			fdbk.setSmnrFdbkId(IdGenUtil.genNewId(IdPrefixType.SMFDK));
			fdbk.setSmnrId((String) user.get("smnrId"));
			fdbk.setUserId((String) user.get("userId"));
			fdbk.setRgtrId(vo.getRgtrId());
			fdbk.setFdbkCts(vo.getFdbkCts());
			fdbkList.add(fdbk);
		}
		smnrFdbkDAO.smnrFdbkBulkRegist(fdbkList);

		List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());

		for(SmnrFdbkVO fdbk : fdbkList) {
			// 첨부파일
			if (uploadFileList.size() > 0) {
				for (AtflVO atflVO : uploadFileList) {
					atflVO.setRefId(fdbk.getSmnrFdbkId());
					atflVO.setRgtrId(vo.getRgtrId());
					atflVO.setMdfrId(vo.getMdfrId());
					atflVO.setAtflRepoId(CommConst.REPO_SMNR); // 첨부파일 저장소 아이디
				}

				// 첨부파일 저장
				attachFileService.insertAtflList(uploadFileList);
			}
		}
	}

	/**
	 * 세미나피드백목록
	 *
	 * @param  smnrId	세미나아이디
	 * @param  userId	사용자아이디
	 * @return List<SmnrFdbkVO>
	 */
	@Override
	public List<SmnrFdbkVO> smnrFdbkList(SmnrFdbkVO vo) {
		List<SmnrFdbkVO> fdbkList = smnrFdbkDAO.smnrFdbkList(vo);

		for(SmnrFdbkVO fdbk : fdbkList) {
			// 첨부파일
			if(fdbk.getFileCnt() > 0) {
				AtflVO atflVO = new AtflVO();
	            atflVO.setRefId(fdbk.getSmnrFdbkId());

	            List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
	            fdbk.setFileList(fileList);
			}
		}

		return fdbkList;
	}

	/**
     * 세미나피드백수정
     *
     * @param SmnrFdbkVO	세미나피드백정보
     */
	@Override
	public void smnrFdbkModify(SmnrFdbkVO vo) {
		if(vo.getSmnrFdbkId() == null || "".equals(vo.getSmnrFdbkId())) {
			vo.setSmnrFdbkId(IdGenUtil.genNewId(IdPrefixType.SMFDK));
		}
		// 세미나피드백수정
		smnrFdbkDAO.smnrFdbkModify(vo);

		List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());

		// 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setRefId(vo.getSmnrFdbkId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getMdfrId());
        		atflVO.setAtflRepoId(CommConst.REPO_SMNR);
        	}

        	// 첨부파일 저장
        	attachFileService.insertAtflList(uploadFileList);
        }

		try {
			// 첨부파일 삭제
			attachFileService.deleteAtflByAtflIds(vo.getDelFileIds());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 세미나피드백조회
	 *
	 * @param  smnrFdbkId	세미나피드백아이디
	 * @return SmnrFdbkVO
	 */
	@Override
	public SmnrFdbkVO smnrFdbkSelect(SmnrFdbkVO vo) {
		SmnrFdbkVO fdbk = smnrFdbkDAO.smnrFdbkSelect(vo);

		// 첨부파일
		if(fdbk != null && fdbk.getFileCnt() > 0) {
			AtflVO atflVO = new AtflVO();
		    atflVO.setRefId(fdbk.getSmnrFdbkId());

		    List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
		    fdbk.setFileList(fileList);
		}

		return fdbk;
	}

	/**
     * 세미나피드백삭제
     *
     * @param smnrFdbkId	세미나피드백아이디
     */
	@Override
	public void smnrFdbkDelete(SmnrFdbkVO vo) {
		smnrFdbkDAO.smnrFdbkDelete(vo);
	}

	/**
     * 세미나피드백일괄등록
     *
     * @param smnrId 	세미나아이디
	 * @param userId 	사용자아이디
	 * @param fdbkCts 	피드백내용
     */
	@Override
	public void smnrFdbkBulkRegist(List<Map<String, Object>> list) {
		// 세미나피드백일괄등록
		List<SmnrFdbkVO> fdbkList = new ArrayList<SmnrFdbkVO>();	// 일괄등록용
		for(Map<String, Object> user : list) {
			SmnrFdbkVO fdbk = new SmnrFdbkVO();
			fdbk.setSmnrFdbkId(IdGenUtil.genNewId(IdPrefixType.SMFDK));
			fdbk.setSmnrId((String) user.get("smnrId"));
			fdbk.setUserId((String) user.get("userId"));
			fdbk.setRgtrId((String) user.get("rgtrId"));
			fdbk.setFdbkCts((String) user.get("fdbkCts"));
			fdbkList.add(fdbk);
		}
		smnrFdbkDAO.smnrFdbkBulkRegist(fdbkList);
	}

}
package knou.lms.smnr.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.smnr.dao.SmnrDAO;
import knou.lms.smnr.dao.SmnrTeamDAO;
import knou.lms.smnr.dao.SmnrTrgtrDAO;
import knou.lms.smnr.pltfrm.dao.OnlnMeetngrmDAO;
import knou.lms.smnr.pltfrm.zoom.service.ZoomApiService;
import knou.lms.smnr.service.SmnrService;
import knou.lms.smnr.vo.SmnrTeamVO;
import knou.lms.smnr.vo.SmnrVO;
import knou.lms.smnr.web.view.SmnrPageInfo;
import knou.lms.team.dao.TeamDAO;
import knou.lms.team.vo.TeamVO;

@Service("smnrService")
public class SmnrServiceImpl extends ServiceBase implements SmnrService {

	@Resource(name="smnrDAO")
	private SmnrDAO smnrDAO;

	@Resource(name="smnrTeamDAO")
	private SmnrTeamDAO smnrTeamDAO;

	@Resource(name="smnrTrgtrDAO")
	private SmnrTrgtrDAO smnrTrgtrDAO;

	@Resource(name="onlnMeetngrmDAO")
	private OnlnMeetngrmDAO onlnMeetngrmDAO;

	@Resource(name="teamDAO")
	private TeamDAO teamDAO;

	@Resource(name="zoomApiService2")
	private ZoomApiService zoomApiService;

	@Resource(name="attachFileService")
	private AttachFileService attachFileService;

	/**
     * 교수세미나목록조회
     *
     * @param sbjctId	 	과목아이디
     * @param searchValue  	검색내용(세미나명)
     * @return 세미나목록 페이징
     */
	@Override
    public ResultDTO<EgovMap> profSmnrListPaging(SmnrPageInfo pageInfo) {
		ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(smnrDAO.profSmnrListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
     * 세미나등록
     *
     * @param SmnrVO				세미나정보
     * @param Map<String, String>	부가정보
     */
	@Override
	public void smnrRegist(SmnrVO vo, Map<String, String> subMap) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> subSmnrs = null;

		try {
			subSmnrs = mapper.readValue(subMap.get("subSmnrsStr"), new TypeReference<List<Map<String, Object>>>() {});	// 팀그룹부과제정보
        } catch(JsonProcessingException e) {
            e.printStackTrace();
        }
		List<String> teamGrpIds = new ArrayList<>(Arrays.asList(subMap.get("teamGrpIds").split(",")));					// 팀그룹아이디:과목아이디목록

		// 일괄등록용 목록
		List<SmnrVO> smnrList = new ArrayList<SmnrVO>();				// 세미나목록
		List<SmnrTeamVO> smnrTeamList = new ArrayList<SmnrTeamVO>();	// 세미나팀목록

		vo.setSmnrId(IdGenUtil.genNewId(IdPrefixType.SMNR));
		smnrList.add(vo);

		// 팀 세미나
		if("Y".equals(vo.getByteamSubsmnrUseyn())) {
			Map<Object, Map<String, Object>> idMap = subSmnrs.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
			for(String teamGrp : teamGrpIds) {
				if(teamGrp.split(":")[1].equals(vo.getSbjctId())) {
					TeamVO teamVO = new TeamVO();
                    teamVO.setTeamCtgrCd(teamGrp.split(":")[0]);
                    List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀목록조회
                    for(TeamVO team : teamList) {
                    	SmnrVO subSmnrVO = mapper.convertValue(vo, SmnrVO.class);
                    	subSmnrVO.setSmnrId(IdGenUtil.genNewId(IdPrefixType.SMNR));
                    	subSmnrVO.setUpSmnrId(vo.getSmnrId());
                        Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
                        if(target != null) {
                        	subSmnrVO.setSmnrnm((String) target.get("ttl"));
                        	subSmnrVO.setSmnrCts((String) target.get("cts"));
                        	subSmnrVO.setUploadFiles((String) target.get("uploadFiles"));
                        	subSmnrVO.setUploadPath((String) target.get("uploadPath"));
                        	subSmnrVO.setDelFileIdStr((String) target.get("delFileIdStr"));
                        } else {
                        	subSmnrVO.setUploadFiles(null);
                        	subSmnrVO.setUploadPath(null);
                        	subSmnrVO.setDelFileIdStr(null);
                        }
                        smnrList.add(subSmnrVO);

                        SmnrTeamVO smnrTeamVO = new SmnrTeamVO();
                        smnrTeamVO.setSmnrTeamId(IdGenUtil.genNewId(IdPrefixType.SMTE));
                        smnrTeamVO.setTeamId(team.getTeamId());
                        smnrTeamVO.setSmnrId(subSmnrVO.getSmnrId());
                        smnrTeamVO.setRgtrId(vo.getRgtrId());
                        smnrTeamVO.setSubParam(team.getTeamnm());
                        smnrTeamList.add(smnrTeamVO);
                    }
				}
			}
		}
		if(smnrList.size() > 0) {
			smnrDAO.smnrBulkRegist(smnrList); 	// 세미나일괄등록
			atflListRegist(smnrList);			// 첨부파일등록
			if(smnrTeamList.size() > 0) {
				smnrTeamDAO.smnrTeamBulkRegist(smnrTeamList); // 세미나팀일괄등록
			}
			// 온라인세미나
			if("ONLN_SMNR".equals(vo.getSmnrGbncd())) {
				// ZOOM회의실등록
				zoomApiService.zoomMeetingRegist(vo, smnrTeamList);
			}
		}

        if("EDU_SMNR".equals(vo.getSmnrTycd())) {
        	smnrMrkRfltrtModify(vo);	// 세미나 성적반영비율 수정
        }
	}

	/**
     * 세미나수정
     *
     * @param SmnrVO				세미나정보
     * @param Map<String, String>	부가정보
     */
	@Override
	public void smnrModify(SmnrVO vo, Map<String, String> subMap) {
		ObjectMapper mapper = new ObjectMapper();
		List<Map<String, Object>> subSmnrs = null;

		try {
			subSmnrs = mapper.readValue(subMap.get("subSmnrsStr"), new TypeReference<List<Map<String, Object>>>() {});	// 팀그룹부과제정보
        } catch(JsonProcessingException e) {
            e.printStackTrace();
        }
		List<String> teamGrpIds = new ArrayList<>(Arrays.asList(subMap.get("teamGrpIds").split(",")));					// 팀그룹아이디:과목아이디목록

		EgovMap bfrSmnr = smnrDAO.smnrSelect(vo);	// 기존세미나정보조회

		smnrDAO.smnrModify(vo);	// 세미나수정

		// 기존 온라인 세미나 && 신규 오프라인 세미나
		if("ONLN_SMNR".equals(StringUtil.nvl(bfrSmnr.get("smnrGbncd"))) && "OFLN_SMNR".equals(vo.getSmnrGbncd())) {
			String meetngrmId = subMap.get("meetngrmId").toString();
			zoomApiService.zoomMeetingDelete(vo, meetngrmId); 				// ZOOM회의실삭제
			smnrTrgtrDAO.smnrTrgtrBulkDelete(vo.getSmnrId()); 				// 기존 세미나대상자 삭제
			smnrTeamDAO.smnrTeamBulkDelete(vo.getSmnrId()); 				// 기존 세미나팀 삭제
			onlnMeetngrmDAO.onlnMeetngrmDelete(vo.getSmnrId(), meetngrmId); // 기존 온라인회의실 삭제
			smnrDAO.subSmnrDelete(vo.getSmnrId()); 							// 기존 하위세미나 삭제
		}

		// 일괄등록용 목록
		List<SmnrVO> smnrList = new ArrayList<SmnrVO>();				// 세미나목록
		List<SmnrTeamVO> smnrTeamList = new ArrayList<SmnrTeamVO>();	// 세미나팀목록
		// 신규 온라인 세미나
		if("ONLN_SMNR".equals(vo.getSmnrGbncd())) {
			smnrTeamDAO.smnrTeamBulkDelete(vo.getSmnrId()); // 기존 세미나팀 삭제
			smnrDAO.subSmnrDelete(vo.getSmnrId()); 			// 기존 하위세미나 삭제

			// 팀 세미나
			if("Y".equals(vo.getByteamSubsmnrUseyn())) {
				Map<Object, Map<String, Object>> idMap = subSmnrs.stream().collect(Collectors.toMap(map -> map.get("id"), map -> map));
				for(String teamGrp : teamGrpIds) {
					if(teamGrp.split(":")[1].equals(vo.getSbjctId())) {
						TeamVO teamVO = new TeamVO();
						teamVO.setTeamCtgrCd(teamGrp.split(":")[0]);
						List<TeamVO> teamList = teamDAO.list(teamVO);	// 팀목록조회
						for(TeamVO team : teamList) {
							SmnrVO subSmnrVO = mapper.convertValue(vo, SmnrVO.class);
							subSmnrVO.setSmnrId(IdGenUtil.genNewId(IdPrefixType.SMNR));
							subSmnrVO.setUpSmnrId(vo.getSmnrId());
							Map<String, Object> target = idMap.get(team.getTeamId());	// 팀아이디로 조회
							if(target != null) {
	                        	subSmnrVO.setSmnrnm((String) target.get("ttl"));
	                        	subSmnrVO.setSmnrCts((String) target.get("cts"));
	                        	subSmnrVO.setUploadFiles((String) target.get("uploadFiles"));
	                        	subSmnrVO.setUploadPath((String) target.get("uploadPath"));
	                        	subSmnrVO.setDelFileIdStr((String) target.get("delFileIdStr"));
	                        } else {
	                        	subSmnrVO.setUploadFiles(null);
	                        	subSmnrVO.setUploadPath(null);
	                        	subSmnrVO.setDelFileIdStr(null);
	                        }
							smnrList.add(subSmnrVO);

							SmnrTeamVO smnrTeamVO = new SmnrTeamVO();
							smnrTeamVO.setSmnrTeamId(IdGenUtil.genNewId(IdPrefixType.SMTE));
							smnrTeamVO.setTeamId(team.getTeamId());
							smnrTeamVO.setSmnrId(subSmnrVO.getSmnrId());
							smnrTeamVO.setRgtrId(vo.getRgtrId());
							smnrTeamVO.setSubParam(team.getTeamnm());
							smnrTeamList.add(smnrTeamVO);
						}
					}
				}
			}
		}

		if(smnrList.size() > 0) {
			smnrDAO.smnrBulkRegist(smnrList); 	// 세미나일괄등록
			atflListRegist(smnrList);			// 첨부파일등록
		}
		if(smnrTeamList.size() > 0) {
			smnrTeamDAO.smnrTeamBulkRegist(smnrTeamList); // 세미나팀일괄등록
		}
		// 신규 온라인세미나
		if("ONLN_SMNR".equals(vo.getSmnrGbncd())) {
			// 기존 오프라인 세미나
			if("OFLN_SMNR".equals(StringUtil.nvl(bfrSmnr.get("smnrGbncd")))) {
				// ZOOM회의실등록
				zoomApiService.zoomMeetingRegist(vo, smnrTeamList);
			// 기존 온라인 세미나
			} else {
				// ZOOM회의실수정
				String meetngrmId = subMap.get("meetngrmId").toString();
				zoomApiService.zoomMeetingModify(vo, meetngrmId, smnrTeamList);
			}
		}

		if("EDU_SMNR".equals(vo.getSmnrTycd())) {
			smnrMrkRfltrtModify(vo);	// 세미나 성적반영비율 수정
		}
	}

	// 첨부파일등록
    private void atflListRegist(List<SmnrVO> smnrList) {
    	for(SmnrVO vo : smnrList) {
    		List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());

    		// 첨부파일
    		if (uploadFileList.size() > 0) {
    			for (AtflVO atflVO : uploadFileList) {
    				atflVO.setRefId(vo.getSmnrId());
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
    }

	/**
     * 세미나삭제
     *
     * @param SmnrVO		세미나정보
     */
	@Override
    public void smnrDelete(SmnrVO vo) {
		EgovMap smnr = smnrDAO.smnrSelect(vo);	// 세미나정보조회

		// 온라인세미나
		if("ONLN_SMNR".equals(StringUtil.nvl(smnr.get("smnrGbncd")))) {
			zoomApiService.zoomMeetingDelete(vo, (String) smnr.get("meetngrmId")); 					// ZOOM회의실삭제
			smnrTrgtrDAO.smnrTrgtrBulkDelete(vo.getSmnrId()); 										// 기존 세미나대상자 삭제
			smnrTeamDAO.smnrTeamBulkDelete(vo.getSmnrId()); 										// 기존 세미나팀 삭제
			onlnMeetngrmDAO.onlnMeetngrmDelete(vo.getSmnrId(), (String) smnr.get("meetngrmId")); 	// 기존 온라인회의실 삭제
		}

		smnrDAO.smnrDelynModify(vo);	// 세미나삭제여부수정
	}

	/**
     * 세미나성적반영비율수정
     *
     * @param sbjctId		과목개설아이디
     * @param mdfrId		수정자아이디
     */
    @Override
    public void smnrMrkRfltrtModify(SmnrVO vo) {
    	List<SmnrVO> smnrList = smnrDAO.mrkRfltSmnrList(vo);	// 성적반영 세미나 목록 조회
        if(smnrList.size() > 0) {
        	BigDecimal totalMrk = new BigDecimal("100");
            BigDecimal mrkRfltrt = totalMrk.divide(BigDecimal.valueOf(smnrList.size()), 2, RoundingMode.FLOOR);
            for(int i = 0; i < smnrList.size(); i++) {
                if(i == smnrList.size() - 1) {
                    mrkRfltrt = totalMrk;
                }
                totalMrk = totalMrk.subtract(mrkRfltrt);
                SmnrVO smnrVO = smnrList.get(i);
                smnrVO.setMrkRfltrt(mrkRfltrt);
                smnrVO.setMdfrId(vo.getMdfrId());
            }
            smnrDAO.smnrMrkRfltrtListModify(smnrList);
        }
    }

    /**
	 * 세미나성적반영비율목록수정
	 *
	 * @param List<SrvyVO>
	 */
	@Override
	public void smnrMrkRfltrtListModify(List<SmnrVO> list) {
		smnrDAO.smnrMrkRfltrtListModify(list);
	}

	/**
     * 세미나세부정보수정
     *
     * @param SmnrVO	세미나정보
     */
	@Override
	public void smnrDtlModify(SmnrVO vo) {
		smnrDAO.smnrModify(vo);
	}

	/**
	 * 세미나대상수강생목록
	 *
	 * @param smnrId	세미나아이디
	 * @return 세미나대상수강생목록
	 */
	@Override
	public List<EgovMap> smnrTrgtAtndlcUserList(SmnrVO vo) {
		return smnrDAO.smnrTrgtAtndlcUserList(vo);
	}

	/**
	 * 세미나조회
	 *
	 * @param smnrId	세미나아이디
	 * @return 세미나정보
	 */
	@Override
	public EgovMap smnrSelect(SmnrVO vo) {
		EgovMap smnrMap = smnrDAO.smnrSelect(vo);
		// 첨부파일
        if(Integer.valueOf(smnrMap.get("fileCnt").toString()) > 0) {
        	AtflVO atflVO = new AtflVO();
            atflVO.setRefId(smnrMap.get("smnrId").toString());

            List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
            smnrMap.put("fileList", fileList);
        }
		return smnrMap;
	}

	/**
	* 세미나팀그룹부세미나목록조회
	*
	* @param teamGrpId 	팀그룹아이디
	* @param smnrId 	세미나아이디
	* @return 세미나팀그룹부세미나목록
	*/
	@Override
	public List<EgovMap> smnrTeamGrpSubSmnrList(Map<String, Object> params) {
		List<EgovMap> smnrList = smnrDAO.smnrTeamGrpSubSmnrList(params);
		for(EgovMap map : smnrList) {
    		// 첨부파일
    		if(Integer.valueOf(map.get("fileCnt").toString()) > 0) {
    			AtflVO atflVO = new AtflVO();
    			atflVO.setRefId(map.get("smnrId").toString());

    			List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
    			map.put("fileList", fileList);
    		}
    	}
		return smnrList;
	}

	/**
	 * 세미나아이디조회
	 *
	 * @param smnrId	세미나아이디
	 * @param userId	사용자아이디
	 * @return 세미나아이디
	 */
	@Override
	public String smnrIdSelect(SmnrVO vo) {
		return smnrDAO.smnrIdSelect(vo);
	}

	/*
	 * 과목별세미나목록조회
	 */
	@Override
	public List<EgovMap> bySubjectSmnrList(SmnrVO vo) {
		return smnrDAO.bySubjectSmnrList(vo);
	}

	/**
     * 학생세미나목록조회
     *
     * @param sbjctId	 	과목아이디
     * @param searchValue  	검색내용(세미나명)
     * @return 세미나목록 페이징
     */
	@Override
	public ResultDTO<EgovMap> stdntSmnrListPaging(SmnrPageInfo pageInfo) {
		ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>(pageInfo);
		resultDto.setReturnList(smnrDAO.stdntSmnrListPaging(pageInfo));
		if(resultDto.getReturnList().size() > 0) {
			resultDto.getPageInfo().setTotalRecordCount(Integer.parseInt(resultDto.getReturnList().get(0).get("totalCnt").toString()));
		} else {
			resultDto.getPageInfo().setTotalRecordCount(0);
		}

        return resultDto;
	}

	/**
     * 학생세미나조회
     *
     * @param sbjctId 		과목아이디
     * @param smnrId 		세미나아이디
     * @param upSmnrId 		상위세미나아이디
     * @param userId 		사용자아이디
     * @return 세미나정보
     */
	@Override
	public EgovMap stdntSmnrSelect(SmnrVO vo) {
		// 학생세미나조회
    	EgovMap map = smnrDAO.stdntSmnrSelect(vo);

    	// 첨부파일
        if(Integer.valueOf(map.get("fileCnt").toString()) > 0) {
        	AtflVO atflVO = new AtflVO();
            atflVO.setRefId(map.get("srvyId").toString());

            List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
            map.put("fileList", fileList);
        }

        return map;
	}
}
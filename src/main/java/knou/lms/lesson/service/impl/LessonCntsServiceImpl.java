package knou.lms.lesson.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.util.VideoUtil;
import knou.framework.vo.FileVO;
import knou.framework.vo.UploadFileVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.ErpLcdmsCntsVO;
import knou.lms.erp.vo.ErpLcdmsPageVO;
import knou.lms.file.service.FileBoxInfoService;
import knou.lms.file.vo.FileBoxInfoVO;
import knou.lms.lesson.dao.LessonCntsCmntDAO;
import knou.lms.lesson.dao.LessonCntsDAO;
import knou.lms.lesson.dao.LessonCntsRecomDAO;
import knou.lms.lesson.dao.LessonPageDAO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.dao.LessonTimeDAO;
import knou.lms.lesson.service.LessonCntsService;
import knou.lms.lesson.service.LessonStudyService;
import knou.lms.lesson.vo.LessonCntsCmntVO;
import knou.lms.lesson.vo.LessonCntsRecomVO;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonPageVO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.lesson.vo.LessonStudyRecordVO;
import knou.lms.lesson.vo.LessonTimeVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

@Service("lessonCntsService")
public class LessonCntsServiceImpl extends ServiceBase implements LessonCntsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(LessonCntsServiceImpl.class);

    @Resource(name="lessonCntsDAO")
    private LessonCntsDAO lessonCntsDAO;

    @Resource(name="lessonPageDAO")
    private LessonPageDAO lessonPageDAO;

    @Resource(name="lessonCntsCmntDAO")
    private LessonCntsCmntDAO lessonCntsCmntDAO;

    @Resource(name="lessonCntsRecomDAO")
    private LessonCntsRecomDAO lessonCntsRecomDAO;

    @Resource(name="lessonStudyService")
    private LessonStudyService lessonStudyService;

    @Resource(name="lessonTimeDAO")
    private LessonTimeDAO lessonTimeDAO;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="fileBoxInfoService")
    private FileBoxInfoService fileBoxInfoService;

    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;

    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;

    @Resource(name="erpService")
    private ErpService erpService;

    /*****************************************************
     * 학습 콘텐츠 정보
     * @param vo
     * @return LessonCntsVO
     * @throws Exception
     ******************************************************/
    public LessonCntsVO select(LessonCntsVO vo) throws Exception {
        return lessonCntsDAO.select(vo);
    }

    /*****************************************************
     * 학습 콘텐츠 목록
     * @param vo
     * @return List<LessonCntsVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<LessonCntsVO> list(LessonCntsVO vo) throws Exception {
        vo.setDelYn("N");
        return lessonCntsDAO.list(vo);
    }

    /*****************************************************
     * 학습 콘텐츠 등록
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    @Override
    public ProcessResultVO<LessonCntsVO> insert(LessonCntsVO vo) throws Exception {
        ProcessResultVO<LessonCntsVO> resultVO = new ProcessResultVO<>();
        resultVO.setResult(1);

        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String lessonScheduleId = vo.getLessonScheduleId();
        String lessonTimeId = vo.getLessonTimeId();
        String cntsGbn = vo.getCntsGbn();

        String lessonCntsNm = vo.getLessonCntsNm();
        Integer lessonCntsOrder = vo.getLessonCntsOrder();
        String prgrYn = vo.getPrgrYn();
        String rgtrId = vo.getRgtrId();

        // 주차 정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO = lessonScheduleDAO.select(lessonScheduleVO);

        if(lessonScheduleVO == null) {
            throw processException("lesson.error.not.exists.lesson.schedule"); // 주차 정보를 찾을 수 업습니다.
        }

        // 교시 정보 조회
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO = lessonTimeDAO.select(lessonTimeVO);

        if(lessonTimeVO == null) {
            throw processException("lesson.error.not.exists.lesson.time"); // 교시 정보를 찾을 수 없습니다.
        }

        String stdyMethod = lessonTimeVO.getStdyMethod();

        if(ValidationUtils.isEmpty(lessonCntsOrder)) {
            if("SEQ".equals(StringUtil.nvl(stdyMethod))) {
                throw processException("lesson.alert.input.lesson.cnts.order"); // 학습순번을 입력하세요.
            } else {
                LessonCntsVO lessonCntsVO = new LessonCntsVO();
                lessonCntsVO.setCrsCreCd(crsCreCd);
                lessonCntsVO.setLessonTimeId(lessonTimeId);
                lessonCntsOrder = lessonCntsDAO.selectLessonCntsOrderMax(lessonCntsVO);
            }
        }

        String lessonCntsId = IdGenerator.getNewId("LECN");

        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setLessonCntsId(lessonCntsId);
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setLessonTimeId(lessonTimeId);
        lessonCntsVO.setLessonScheduleId(lessonScheduleId);
        lessonCntsVO.setLessonTypeCd("ONLINE");
        lessonCntsVO.setLessonCntsNm(lessonCntsNm);
        lessonCntsVO.setLessonCntsOrder(lessonCntsOrder);
        lessonCntsVO.setCntsGbn(cntsGbn);
        lessonCntsVO.setPrgrYn(prgrYn);
        lessonCntsVO.setViewYn("Y");
        lessonCntsVO.setRgtrId(rgtrId);

        LOGGER.debug("lessonCntsVO.setCrsCreCd          : " + lessonCntsVO.getCrsCreCd());
        LOGGER.debug("lessonCntsVO.setLessonTimeId      : " + lessonCntsVO.getLessonTimeId());
        LOGGER.debug("lessonCntsVO.setLessonScheduleId  : " + lessonCntsVO.getLessonScheduleId());
        LOGGER.debug("lessonCntsVO.setLessonTypeCd      : " + lessonCntsVO.getLessonTypeCd());
        LOGGER.debug("lessonCntsVO.setLessonCntsNm      : " + lessonCntsVO.getLessonCntsNm());
        LOGGER.debug("lessonCntsVO.setLessonCntsOrder   : " + lessonCntsVO.getLessonCntsOrder());
        LOGGER.debug("lessonCntsVO.setCntsGbn           : " + lessonCntsVO.getCntsGbn());
        LOGGER.debug("lessonCntsVO.setPrgrYn            : " + lessonCntsVO.getPrgrYn());
        LOGGER.debug("lessonCntsVO.setViewYn            : " + lessonCntsVO.getViewYn());
        LOGGER.debug("lessonCntsVO.setRgtrId             : " + lessonCntsVO.getRgtrId());

        if("FILE_BOX".equals(cntsGbn)) {
            String fileBoxCd = vo.getFileBoxCd();

            if(ValidationUtils.isEmpty(fileBoxCd)) {
                throw processException("lesson.error.not.exists.file.box.cd"); // 파일함 파일 선택정보가 존재하지 않습니다.
            }

            // 1.파일박스 조회
            FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
            fileBoxInfoVO.setFileBoxCd(fileBoxCd);
            fileBoxInfoVO.setRgtrId(rgtrId);
            fileBoxInfoVO = fileBoxInfoService.selectFileBox(fileBoxInfoVO);

            String fileSn = fileBoxInfoVO.getFileSn();
            String[] fileSnList = {fileSn};

            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("FILE_BOX");
            fileVO.setFileSnList(fileSnList);

            // 2.파일박스의 파일정보 조회
            List<FileVO> originFileList = (List<FileVO>) sysFileService.list(fileVO).getReturnList();
            List<Map<String, String>> fileMapList = new ArrayList<>();
            for(FileVO fvo2 : originFileList) {
                Map<String, String> map = new HashMap<>();
                map.put("fileNm", fvo2.getFileNm());
                map.put("fileId", fvo2.getFileId());
                map.put("fileSize", fvo2.getFileSize().toString());
                fileMapList.add(map);
            }
            JSONArray copyFileJsonArray = JSONArray.fromObject(fileMapList);
            String copyFiles = copyFileJsonArray.toString();

            // 3.강의 컨텐츠 저장 폴더명 조회
            fileBoxInfoVO = new FileBoxInfoVO();
            fileBoxInfoVO.setCrsCreCd(crsCreCd);
            String contentFolderNm = fileBoxInfoService.getLessonCntsFolderNm(fileBoxInfoVO);

            // 4.강의 컨텐츠로 파일 복사
            FileVO copyFileVO = new FileVO();
            copyFileVO.setUploadFiles(copyFiles);
            copyFileVO.setFilePath("/lecture/" + contentFolderNm);
            copyFileVO.setRepoCd("LECTURE");
            copyFileVO.setRgtrId(rgtrId);
            copyFileVO.setFileBindDataSn(lessonCntsId);
            copyFileVO.setFileList(originFileList);

            try {
                copyFileVO = sysFileService.copyFile(copyFileVO);
            } catch (Exception e) {
                throw processException("filebox.error.file.copy"); // 파일을 가져오는중 오류가 발생하였습니다.
            }

            try {
                // 5.컨텐츠 구분 세팅
                String fileExt = StringUtil.nvl(copyFileVO.getFileExt()).toLowerCase();

                /*if("mp4".equals(fileExt)) {
                    cntsGbn = "VIDEO";
                } else */if("pdf".equals(fileExt)) {
                    cntsGbn = "PDF";
                } else {
                    cntsGbn = "FILE";
                }

                lessonCntsVO.setCntsGbn(cntsGbn);

                // 6.컨텐츠 재생 URL 세팅
                /*
                if("mp4".equals(fileExt)) {
                    String lessonCntsUrl = "/lecture/" + contentFolderNm + "/" + copyFileVO.getFileSaveNm();

                    lessonCntsVO.setLessonCntsUrl(lessonCntsUrl);
                }
                */
                // 7.저장
                lessonCntsDAO.insert(lessonCntsVO);

                // 순차 학습 정렬순서 수정
                if("SEQ".equals(stdyMethod)) {
                    LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
                    lessonCntsVO2.setLessonTimeId(lessonTimeId);
                    lessonCntsVO2.setLessonCntsId(lessonCntsId);
                    lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
                }
            } catch (Exception e) {
                LOGGER.debug("e: ", e);
                List<FileVO> copyFileList = (List<FileVO>) copyFileVO.getFileList();

                // 복사된 파일 제거
                if(copyFileList != null) {
                    for(FileVO fvo2 : copyFileList) {
                        String fileSaveNm = fvo2.getFileSaveNm();
                        FileUtil.deleteFile(fileSaveNm, "/lecture/" + contentFolderNm);
                    }
                }
                throw e;
            }
        } else if("VIDEO".equals(cntsGbn) || "PDF".equals(cntsGbn)  || "FILE".equals(cntsGbn)) {
            String uploadFiles = vo.getUploadFiles();
            String uploadPath = vo.getUploadPath();
            List<FileVO> uploadFileList = FileUtil.getUploadFileList(uploadFiles);
            String subtitFiles1 = StringUtil.nvl(vo.getSubtitFiles1());
            String subtitFiles2 = StringUtil.nvl(vo.getSubtitFiles2());
            String subtitFiles3 = StringUtil.nvl(vo.getSubtitFiles3());
            String scriptKoFiles = StringUtil.nvl(vo.getScriptKoFiles());
            List<FileVO> uploadedFileList = new ArrayList<>();

            if(uploadFileList.size() == 0) {
                throw processException("lesson.alert.input.lesson.cnts"); // 학습자료를 입력하세요.
            }

            try {
                if("VIDEO".equals(cntsGbn)) {
                    // 자막, 스크립트 설정
                    List<JSONObject> subList = new ArrayList<>();

                    if (!"".equals(subtitFiles1) && !"[]".equals(subtitFiles1)) {
                        String[] subLang = StringUtil.nvl(vo.getSubtitLang1()).split(":");
                        JSONArray fileInfo = (JSONArray) JSONSerializer.toJSON(subtitFiles1.replaceAll("\\\\", ""));
                        JSONObject fileObj = (JSONObject)fileInfo.get(0);
                        fileObj.put("saveNm", fileObj.getString("fileId") + "." + FileUtil.getFileExtention(fileObj.getString("fileNm")));
                        fileObj.put("label", subLang[0]);
                        fileObj.put("srclang", subLang[1]);
                        lessonCntsVO.setSubtit1(fileObj.toString());
                        subList.add(fileObj);
                    }
                    else {
                        lessonCntsVO.setSubtit1(StringUtil.nvl(vo.getSubtit1()).replace("&#034;", "\"") );
                    }

                    if (!"".equals(subtitFiles2) && !"[]".equals(subtitFiles2)) {
                        String[] subLang = StringUtil.nvl(vo.getSubtitLang2()).split(":");
                        JSONArray fileInfo = (JSONArray) JSONSerializer.toJSON(subtitFiles2.replaceAll("\\\\", ""));
                        JSONObject fileObj = (JSONObject)fileInfo.get(0);
                        fileObj.put("saveNm", fileObj.getString("fileId") + "." + FileUtil.getFileExtention(fileObj.getString("fileNm")));
                        fileObj.put("label", subLang[0]);
                        fileObj.put("srclang", subLang[1]);
                        lessonCntsVO.setSubtit2(fileObj.toString());
                        subList.add(fileObj);
                    }
                    else {
                        lessonCntsVO.setSubtit2(StringUtil.nvl(vo.getSubtit2()).replace("&#034;", "\"") );
                    }

                    if (!"".equals(subtitFiles3) && !"[]".equals(subtitFiles3)) {
                        String[] subLang = StringUtil.nvl(vo.getSubtitLang3()).split(":");
                        JSONArray fileInfo = (JSONArray) JSONSerializer.toJSON(subtitFiles3.replaceAll("\\\\", ""));
                        JSONObject fileObj = (JSONObject)fileInfo.get(0);
                        fileObj.put("saveNm", fileObj.getString("fileId") + "." + FileUtil.getFileExtention(fileObj.getString("fileNm")));
                        fileObj.put("label", subLang[0]);
                        fileObj.put("srclang", subLang[1]);
                        lessonCntsVO.setSubtit3(fileObj.toString());
                        subList.add(fileObj);
                    }
                    else {
                        lessonCntsVO.setSubtit3(StringUtil.nvl(vo.getSubtit3()).replace("&#034;", "\"") );
                    }

                    lessonCntsVO.setSubtitKo(subList.toString());

                    if (!"".equals(scriptKoFiles) && !"[]".equals(scriptKoFiles)) {
                        JSONArray fileInfo = (JSONArray) JSONSerializer.toJSON(scriptKoFiles.replaceAll("\\\\", ""));
                        JSONObject fileObj = (JSONObject)fileInfo.get(0);
                        fileObj.put("saveNm", fileObj.getString("fileId") + "." + FileUtil.getFileExtention(fileObj.getString("fileNm")));
                        lessonCntsVO.setScriptKo(fileObj.toString());
                    }
                    else {
                        lessonCntsVO.setScriptKo(StringUtil.nvl(vo.getScriptKo()).replace("&#034;", "\"") );
                    }

                    if("Y".equals(StringUtil.nvl(prgrYn))) {
                        String videoTimeCalcMethod = vo.getVideoTimeCalcMethod();
                        Integer recmmdStudyTime = vo.getRecmmdStudyTime();

                        if("MANUAL".equals(StringUtil.nvl(videoTimeCalcMethod))) {
                            if(recmmdStudyTime == null) {
                                // 동영상 길이를 입력하세요.
                                throw processException("lesson.alert.message.empty.recmmd.study.time");
                            }

                            if(recmmdStudyTime == 0) {
                                // 출결체크 대상인 경우  0분을 입력할 수 없습니다.
                                throw processException("lesson.error.not.allow.time0");
                            }

                            lessonCntsVO.setRecmmdStudyTime(recmmdStudyTime);

                            resultVO.setResult(2);
                            resultVO.setMessage(String.valueOf(recmmdStudyTime));
                        } else {
                            if(uploadFileList.size() > 0) {
                                if(uploadFileList.size() == 1) {
                                    int videoSecound = 0;

                                    for(FileVO fileVO : uploadFileList) {
                                        String path = uploadPath + "/" + fileVO.getFilePath();

                                        try {
                                            videoSecound = VideoUtil.getVideoSecound(path);
                                            videoSecound = videoSecound / 60;

                                            if(videoSecound == 0) {
                                                // 1분미만의 동영상은 출결체크 콘텐츠로 등록할 수 없습니다.
                                                throw processException("lesson.error.fail.upload.lower.1minute.video");
                                            }
                                            resultVO.setResult(2);
                                            resultVO.setMessage(String.valueOf(videoSecound));
                                        } catch (EgovBizException e) {
                                            throw e;
                                        } catch (Exception e) {
                                            LOGGER.debug("e: ", e);
                                            resultVO.setResult(-2); // -2: 동영상 시간계산 실패
                                            resultVO.setReturnVO(lessonCntsVO);
                                        }
                                    }

                                    lessonCntsVO.setRecmmdStudyTime(videoSecound);
                                } else {
                                    throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
                                }
                            }
                        }
                    } else {
                        lessonCntsVO.setRecmmdStudyTime(null);
                    }
                }

                // 3. 강의 컨텐츠 업로드
                FileVO uploadFileVO = new FileVO();
                uploadFileVO.setUploadFiles(vo.getUploadFiles());
                uploadFileVO.setFilePath(uploadPath);
                uploadFileVO.setRepoCd("LECTURE");
                uploadFileVO.setRgtrId(rgtrId);
                uploadFileVO.setFileBindDataSn(lessonCntsId);

                uploadFileVO = sysFileService.addFile(uploadFileVO);

                uploadedFileList.addAll((List<FileVO>) uploadFileVO.getFileList());

                // 4.컨텐츠 재생 URL 세팅
                String fileExt = StringUtil.nvl(uploadFileVO.getFileExt()).toLowerCase();

                if("mp4".equals(fileExt)) {
                    String lessonCntsUrl = uploadPath + "/" + uploadFileVO.getFileSaveNm();

                    lessonCntsVO.setLessonCntsUrl(lessonCntsUrl);
                }

                // 5.저장
                lessonCntsDAO.insert(lessonCntsVO);

                // 순차 학습 정렬순서 수정
                if("SEQ".equals(stdyMethod)) {
                    LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
                    lessonCntsVO2.setLessonTimeId(lessonTimeId);
                    lessonCntsVO2.setLessonCntsId(lessonCntsId);
                    lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
                }

                // 주차 학습시간 갱신
                if("VIDEO".equals(cntsGbn) && "Y".equals(StringUtil.nvl(prgrYn))) {
                    LessonScheduleVO updateLbnTmVO = new LessonScheduleVO();
                    updateLbnTmVO.setLessonScheduleId(lessonScheduleId);
                    updateLbnTmVO.setMdfrId(rgtrId);
                    lessonScheduleDAO.updateLbnTm(updateLbnTmVO);
                }

                if("VIDEO".equals(cntsGbn)) {
                    // 자막 업로드
                    List<UploadFileVO> subtitFileList = new ArrayList<>();

                    if(!"".equals(subtitFiles1)) {
                        subtitFileList.addAll(FileUtil.getUploadFileListV2(subtitFiles1));
                    }

                    if(!"".equals(subtitFiles2)) {
                        subtitFileList.addAll(FileUtil.getUploadFileListV2(subtitFiles2));
                    }

                    if(!"".equals(subtitFiles3)) {
                        subtitFileList.addAll(FileUtil.getUploadFileListV2(subtitFiles3));
                    }

                    if(subtitFileList.size() > 0) {
                        String subtitFiles = FileUtil.getUploadFileListToJsonString(subtitFileList);

                        uploadFileVO = new FileVO();
                        uploadFileVO.setUploadFiles(subtitFiles);
                        uploadFileVO.setFilePath(uploadPath);
                        uploadFileVO.setRepoCd("LECTURE_SUBTIT");
                        uploadFileVO.setRgtrId(rgtrId);
                        uploadFileVO.setFileBindDataSn(lessonCntsId);
                        //uploadFileVO = sysFileService.addFileWithObjectStorage(uploadFileVO);

                        uploadedFileList.addAll((List<FileVO>) uploadFileVO.getFileList());
                    }

                    // 스크립트 업로드
                    if(!"".equals(scriptKoFiles)) {
                        uploadFileVO = new FileVO();
                        uploadFileVO.setUploadFiles(scriptKoFiles);
                        uploadFileVO.setFilePath(uploadPath);
                        uploadFileVO.setRepoCd("LECTURE_SCRIPT");
                        uploadFileVO.setRgtrId(rgtrId);
                        uploadFileVO.setFileBindDataSn(lessonCntsId);
                        //uploadFileVO = sysFileService.addFileWithObjectStorage(uploadFileVO);

                        uploadedFileList.addAll((List<FileVO>) uploadFileVO.getFileList());
                    }
                }
            } catch (Exception e) {
                LOGGER.debug("e: ", e);

                if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(uploadFiles, uploadPath);
                }

                if(ValidationUtils.isNotEmpty(subtitFiles1) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(subtitFiles1, uploadPath);
                }

                if(ValidationUtils.isNotEmpty(subtitFiles2) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(subtitFiles2, uploadPath);
                }

                if(ValidationUtils.isNotEmpty(subtitFiles3) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(subtitFiles3, uploadPath);
                }

                if(ValidationUtils.isNotEmpty(scriptKoFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(scriptKoFiles, uploadPath);
                }

                if("Y".equals(CommConst.OBJECT_STORAGE_USE_YN)) {
                    if(uploadedFileList != null && uploadedFileList.size() > 0) {
                        for(FileVO fileVO : uploadedFileList) {
                            String objectStoragePath = fileVO.getObjectStoragePath();
							/*
							 * if(ValidationUtils.isNotEmpty(objectStoragePath)) {
							 * objectStorageService.deleteObject(fileVO); }
							 */
                        }
                    }
                }

                throw e;
            }
        }  else if("SOCIAL".equals(cntsGbn) || "LINK".equals(cntsGbn)) {
            String lessonCntsUrl = vo.getLessonCntsUrl();

            if(ValidationUtils.isEmpty(lessonCntsUrl)) {
                throw processException("lesson.alert.input.lesson.cnts"); // 학습자료를 입력하세요.
            }

            lessonCntsVO.setLessonCntsUrl(lessonCntsUrl);

            lessonCntsDAO.insert(lessonCntsVO);

            // 순차 학습 정렬순서 수정
            if("SEQ".equals(stdyMethod)) {
                LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
                lessonCntsVO2.setLessonTimeId(lessonTimeId);
                lessonCntsVO2.setLessonCntsId(lessonCntsId);
                lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
            }
        } else if("TEXT".equals(cntsGbn)) {
            String cntsText = vo.getCntsText();

            if(ValidationUtils.isEmpty(cntsText)) {
                throw processException("lesson.alert.input.lesson.cnts"); // 학습자료를 입력하세요.
            }

            lessonCntsVO.setCntsText(cntsText);

            lessonCntsDAO.insert(lessonCntsVO);

            // 순차 학습 정렬순서 수정
            if("SEQ".equals(stdyMethod)) {
                LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
                lessonCntsVO2.setLessonTimeId(lessonTimeId);
                lessonCntsVO2.setLessonCntsId(lessonCntsId);
                lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
            }
        } else if("VIDEO_LINK".equals(cntsGbn)) {
        	// 목차저장
        	lessonCntsVO.setRecmmdStudyTime(vo.getRecmmdStudyTime());
        	lessonCntsDAO.insert(lessonCntsVO);

        	List<LessonPageVO> pageList = new ArrayList<LessonPageVO>();
        	LessonPageVO lessonPageVO = null;
        	ErpLcdmsPageVO pageVO = new ErpLcdmsPageVO();
        	pageVO.setYear(vo.getYear());
        	pageVO.setSemester(vo.getSemester());
        	pageVO.setCourseCode(vo.getCourseCode());
        	pageVO.setWeek(vo.getWeek());

        	// 페이지 목록 조회
        	List<ErpLcdmsPageVO> erpPageList = erpService.listLcdmsPage(pageVO);

        	for (ErpLcdmsPageVO pageVO2 : erpPageList) {
                int videoTm = 0;
                if (!"".equals(StringUtil.nvl(pageVO2.getLbnTm()))) {
                    String lbnTm = pageVO2.getLbnTm();
                    if (lbnTm.indexOf(".") > -1) {
                        lbnTm = lbnTm.substring(0,lbnTm.indexOf("."));
                    }
                    String[] tm = lbnTm.split(":");

                    if (tm.length > 1) {
                        videoTm = "".equals(tm[0]) ? 0 : Integer.parseInt(tm[0]) * 60;
                        videoTm += "".equals(tm[1]) ? 0 : Integer.parseInt(tm[1]);
                    }
                    else {
                        videoTm = Integer.parseInt(tm[0]);
                    }
                }

                String pattern = "_\\d{2}_\\d{2}$";
                String pageNm = StringUtil.nvl(pageVO2.getPageNm());

                if(pageNm.matches(".*" + pattern)) {
                    pageNm = pageNm.replaceAll(pattern, "") + "_" + StringUtil.fillLeft("" + lessonScheduleVO.getLessonScheduleOrder(), 2, "0") + "_" + StringUtil.fillLeft("" + pageVO2.getPageCnt(), 2, "0");
                }

        		lessonPageVO = new LessonPageVO();
        		lessonPageVO.setLessonCntsId(lessonCntsId);
        		lessonPageVO.setPageCnt(pageVO2.getPageCnt());
        		lessonPageVO.setUploadGbn(pageVO2.getUploadGbn());
        		lessonPageVO.setPageNm(pageNm);
        		lessonPageVO.setUrl(pageVO2.getUrl());
        		lessonPageVO.setVideoTm(videoTm);
        		lessonPageVO.setAtndYn(pageVO2.getLmsAttendYn());
        		lessonPageVO.setOpenYn("Y");
        		lessonPageVO.setRgtrId(rgtrId);
        		pageList.add(lessonPageVO);
        	}

        	if (pageList.size() > 0) {
        		// 페이지목록 저장
        		lessonPageDAO.insertLessonPageList(pageList);
        	}

        	// 콘텐츠 조회
            ErpLcdmsCntsVO erpLcdmsCntsVO = new ErpLcdmsCntsVO();
            erpLcdmsCntsVO.setYear(vo.getYear());
            erpLcdmsCntsVO.setSemester(vo.getSemester());
            erpLcdmsCntsVO.setCourseCode(vo.getCourseCode());
            erpLcdmsCntsVO.setWeek(vo.getWeek());
            erpLcdmsCntsVO = erpService.selectLcdmsCnts(erpLcdmsCntsVO);

            String ltNote = "";
            String ltNoteOfferYn = "N";

            if(erpLcdmsCntsVO != null) {
                ltNote = erpLcdmsCntsVO.getLtNote();
                ltNoteOfferYn = StringUtil.nvl(erpLcdmsCntsVO.getLtNoteOfferYn(), "N");
            }

            // 강의노트 수정
            LessonScheduleVO updateLtNoteVO = new LessonScheduleVO();
            updateLtNoteVO.setLessonScheduleId(lessonScheduleId);
            updateLtNoteVO.setLtNoteOfferYn(ltNoteOfferYn);
            updateLtNoteVO.setLtNote(ltNote);
            updateLtNoteVO.setMdfrId(rgtrId);
            lessonScheduleDAO.update(updateLtNoteVO);

        	// 주차 학습시간 갱신
            LessonScheduleVO updateLbnTmVO = new LessonScheduleVO();
            updateLbnTmVO.setLessonScheduleId(lessonScheduleId);
            updateLbnTmVO.setRgtrId(rgtrId);
            lessonScheduleDAO.updateLbnTm(updateLbnTmVO);
        }

        return resultVO;
    }

    /*****************************************************
     * 학습 콘텐츠 수정
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/
    @SuppressWarnings("unchecked")
    @Override
    public ProcessResultVO<LessonCntsVO> update(LessonCntsVO vo) throws Exception {
        ProcessResultVO<LessonCntsVO> resultVO = new ProcessResultVO<>();
        resultVO.setResult(1);

        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String rgtrId = vo.getMdfrId();
        String lessonScheduleId = vo.getLessonScheduleId();
        String lessonTimeId = vo.getLessonTimeId();


        // 수정할 값
        String lessonCntsId = vo.getLessonCntsId();
        String lessonCntsNm = vo.getLessonCntsNm();
        Integer lessonCntsOrder = vo.getLessonCntsOrder();
        String prgrYn = vo.getPrgrYn();
        String cntsGbn = vo.getCntsGbn();
        String mdfrId = vo.getMdfrId();

        // 주차 정보 조회
        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO.setCrsCreCd(crsCreCd);
        lessonScheduleVO = lessonScheduleDAO.select(lessonScheduleVO);

        if(lessonScheduleVO == null) {
            throw processException("lesson.error.not.exists.lesson.schedule"); // 주차 정보를 찾을 수 업습니다.
        }

        // 교시 정보 조회
        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO = lessonTimeDAO.select(lessonTimeVO);

        if(lessonTimeVO == null) {
            throw processException("lesson.error.not.exists.lesson.time"); // 교시 정보를 찾을 수 없습니다.
        }

        // 순차학습 필수 값 체크
        String stdyMethod = lessonTimeVO.getStdyMethod();

        if("SEQ".equals(stdyMethod) && ValidationUtils.isEmpty(lessonCntsOrder)) {
            throw processException("lesson.alert.input.lesson.cnts.order"); // 학습순번을 입력하세요.
        }

        // 기존 학습콘텐츠 정보 조회
        LessonCntsVO oldLessonCntsVO = new LessonCntsVO();
        oldLessonCntsVO.setCrsCreCd(crsCreCd);
        oldLessonCntsVO.setLessonCntsId(lessonCntsId);
        oldLessonCntsVO = lessonCntsDAO.select(oldLessonCntsVO);

        if(oldLessonCntsVO == null) {
            throw processException("lesson.error.not.exists.lesson.cnts"); // 학습자료 정보를 찾을 수 없습니다.
        }

        if(ValidationUtils.isEmpty(lessonCntsOrder)) {
            lessonCntsOrder = oldLessonCntsVO.getLessonCntsOrder();
        }

        // 외부 링크 콘텐츠 교수가 수정 불가
        if("VIDEO_LINK".equals(StringUtil.nvl(oldLessonCntsVO.getCntsGbn())) && !"N".equals(vo.getLcdmsLinkYn())) {
            throw processException("lesson.error.no.auth.lesson.cnts.update"); // 수정할 수 없는 학습콘텐츠 입니다.
        }

        // 기존, 수정 폼의 파일업로더 사용여부
        boolean beforeUseFileUploader = "VIDEO".equals(oldLessonCntsVO.getCntsGbn()) || "PDF".equals(oldLessonCntsVO.getCntsGbn())  || "FILE".equals(oldLessonCntsVO.getCntsGbn());

        // 수정용 VO
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setLessonCntsId(lessonCntsId);
        lessonCntsVO.setLessonCntsNm(lessonCntsNm);
        lessonCntsVO.setLessonCntsOrder(lessonCntsOrder);
        lessonCntsVO.setPrgrYn(prgrYn);
        lessonCntsVO.setCntsGbn(cntsGbn);
        lessonCntsVO.setMdfrId(mdfrId);

        if("FILE_BOX".equals(cntsGbn)) {
            String fileBoxCd = vo.getFileBoxCd();

            if(ValidationUtils.isEmpty(fileBoxCd)) {
                throw processException("lesson.error.not.exists.file.box.cd"); // 파일함 파일 선택정보가 존재하지 않습니다.
            }

            // 1.파일박스 조회
            FileBoxInfoVO fileBoxInfoVO = new FileBoxInfoVO();
            fileBoxInfoVO.setFileBoxCd(fileBoxCd);
            fileBoxInfoVO.setRgtrId(rgtrId);
            fileBoxInfoVO = fileBoxInfoService.selectFileBox(fileBoxInfoVO);

            String fileSn = fileBoxInfoVO.getFileSn();
            String[] fileSnList = {fileSn};

            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("FILE_BOX");
            fileVO.setFileSnList(fileSnList);

            // 2.파일박스의 파일정보 조회
            List<FileVO> originFileList = (List<FileVO>) sysFileService.list(fileVO).getReturnList();
            List<Map<String, String>> fileMapList = new ArrayList<>();
            for(FileVO fvo2 : originFileList) {
                Map<String, String> map = new HashMap<>();
                map.put("fileNm", fvo2.getFileNm());
                map.put("fileId", fvo2.getFileId());
                map.put("fileSize", fvo2.getFileSize().toString());
                fileMapList.add(map);
            }
            JSONArray copyFileJsonArray = JSONArray.fromObject(fileMapList);
            String copyFiles = copyFileJsonArray.toString();

            // 3.강의 컨텐츠 저장 폴더명 조회
            fileBoxInfoVO = new FileBoxInfoVO();
            fileBoxInfoVO.setCrsCreCd(crsCreCd);
            String contentFolderNm = fileBoxInfoService.getLessonCntsFolderNm(fileBoxInfoVO);

            // 4.기존 업로드 파일 정보 조회
            List<FileVO> oldFileList = null;
            if(beforeUseFileUploader) {
                fileVO = new FileVO();
                fileVO.setRepoCd("LECTURE");
                fileVO.setFileBindDataSn(lessonCntsId);
                oldFileList = sysFileService.list(fileVO).getReturnList();
            }

            // 5.강의 컨텐츠로 파일 복사
            FileVO copyFileVO = new FileVO();
            copyFileVO.setUploadFiles(copyFiles);
            copyFileVO.setFilePath("/lecture/" + contentFolderNm);
            copyFileVO.setRepoCd("LECTURE");
            copyFileVO.setRgtrId(rgtrId);
            copyFileVO.setFileBindDataSn(lessonCntsId);
            copyFileVO.setFileList(originFileList);

            try {
                copyFileVO = sysFileService.copyFile(copyFileVO);
            } catch (Exception e) {
                throw processException("filebox.error.file.copy"); // 파일을 가져오는중 오류가 발생하였습니다.
            }

            try {
                // 6.컨텐츠 구분 세팅
                String fileExt = StringUtil.nvl(copyFileVO.getFileExt()).toLowerCase();

                /*if("mp4".equals(fileExt)) {
                    cntsGbn = "VIDEO";
                } else */if("pdf".equals(fileExt)) {
                    cntsGbn = "PDF";
                } else {
                    cntsGbn = "FILE";
                }

                lessonCntsVO.setCntsGbn(cntsGbn);

                // 7.수정
                lessonCntsDAO.update(lessonCntsVO);

                // 순차 학습 정렬순서 수정
                if("SEQ".equals(stdyMethod)) {
                    LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
                    lessonCntsVO2.setLessonTimeId(lessonTimeId);
                    lessonCntsVO2.setLessonCntsId(lessonCntsId);
                    lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
                }

                if(beforeUseFileUploader) {
                    // 기존 업로드 파일 삭제
                    if(oldFileList != null) {
                        for(FileVO fvo : oldFileList) {
                            sysFileService.removeFile(fvo.getFileSn());
                        }
                    }

                    if("VIDEO".equals(oldLessonCntsVO.getCntsGbn())) {
                        // 자막 삭제
                        fileVO = new FileVO();
                        fileVO.setRepoCd("LECTURE_SUBTIT");
                        fileVO.setFileBindDataSn(lessonCntsId);
                        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                        for(FileVO fvo : fileList) {
                            sysFileService.removeFile(fvo.getFileSn());
                        }

                        // 스크립트 삭제
                        fileVO = new FileVO();
                        fileVO.setRepoCd("LECTURE_SCRIPT");
                        fileVO.setFileBindDataSn(lessonCntsId);
                        fileList = sysFileService.list(fileVO).getReturnList();

                        for(FileVO fvo : fileList) {
                            sysFileService.removeFile(fvo.getFileSn());
                        }
                    }
                }
            } catch (Exception e) {
                LOGGER.debug("e: ", e);
                List<FileVO> copyFileList = (List<FileVO>) copyFileVO.getFileList();

                // 복사된 파일 제거
                if(copyFileList != null) {
                    for(FileVO fvo2 : copyFileList) {
                        String fileSaveNm = fvo2.getFileSaveNm();
                        FileUtil.deleteFile(fileSaveNm, "/lecture/" + contentFolderNm);
                    }
                }
                throw e;
            }
        } else if("VIDEO".equals(cntsGbn) || "PDF".equals(cntsGbn)  || "FILE".equals(cntsGbn)) {
            String uploadFiles = vo.getUploadFiles();
            String uploadPath = vo.getUploadPath();
            String[] delFileIds = vo.getDelFileIds();
            List<FileVO> uploadFileList = FileUtil.getUploadFileList(uploadFiles);
            String subtitFiles1 = StringUtil.nvl(vo.getSubtitFiles1());
            String subtitFiles2 = StringUtil.nvl(vo.getSubtitFiles2());
            String subtitFiles3 = StringUtil.nvl(vo.getSubtitFiles3());
            String scriptKoFiles = StringUtil.nvl(vo.getScriptKoFiles());
            List<FileVO> uploadedFileList = new ArrayList<>();

            try {
                if("VIDEO".equals(cntsGbn)) {
                    // 자막, 스크립트 설정
                    List<JSONObject> subList = new ArrayList<>();

                    if (!"".equals(subtitFiles1) && !"[]".equals(subtitFiles1)) {
                        String[] subLang = StringUtil.nvl(vo.getSubtitLang1()).split(":");
                        JSONArray fileInfo = (JSONArray) JSONSerializer.toJSON(subtitFiles1.replaceAll("\\\\", ""));
                        JSONObject fileObj = (JSONObject)fileInfo.get(0);
                        fileObj.put("saveNm", fileObj.getString("fileId") + "." + FileUtil.getFileExtention(fileObj.getString("fileNm")));
                        fileObj.put("label", subLang[0]);
                        fileObj.put("srclang", subLang[1]);
                        lessonCntsVO.setSubtit1(fileObj.toString());
                        subList.add(fileObj);
                    }
                    else if (!"".equals(StringUtil.nvl(vo.getSubtit1())) && "".equals(StringUtil.nvl(vo.getSubtitDelIds1()))) {
                        JSONObject fileObj = JSONObject.fromObject(JSONSerializer.toJSON(vo.getSubtit1().replace("&#034;", "\"")));
                        subList.add(fileObj);
                    }

                    if (!"".equals(subtitFiles2) && !"[]".equals(subtitFiles2)) {
                        String[] subLang = StringUtil.nvl(vo.getSubtitLang2()).split(":");
                        JSONArray fileInfo = (JSONArray) JSONSerializer.toJSON(subtitFiles2.replaceAll("\\\\", ""));
                        JSONObject fileObj = (JSONObject)fileInfo.get(0);
                        fileObj.put("saveNm", fileObj.getString("fileId") + "." + FileUtil.getFileExtention(fileObj.getString("fileNm")));
                        fileObj.put("label", subLang[0]);
                        fileObj.put("srclang", subLang[1]);
                        lessonCntsVO.setSubtit2(fileObj.toString());
                        subList.add(fileObj);
                    }
                    else if (!"".equals(StringUtil.nvl(vo.getSubtit2())) && "".equals(StringUtil.nvl(vo.getSubtitDelIds2()))) {
                        JSONObject fileObj = JSONObject.fromObject(JSONSerializer.toJSON(vo.getSubtit2().replace("&#034;", "\"")));
                        subList.add(fileObj);
                    }

                    if (!"".equals(subtitFiles3) && !"[]".equals(subtitFiles3)) {
                        String[] subLang = StringUtil.nvl(vo.getSubtitLang3()).split(":");
                        JSONArray fileInfo = (JSONArray) JSONSerializer.toJSON(subtitFiles3.replaceAll("\\\\", ""));
                        JSONObject fileObj = (JSONObject)fileInfo.get(0);
                        fileObj.put("saveNm", fileObj.getString("fileId") + "." + FileUtil.getFileExtention(fileObj.getString("fileNm")));
                        fileObj.put("label", subLang[0]);
                        fileObj.put("srclang", subLang[1]);
                        lessonCntsVO.setSubtit3(fileObj.toString());
                        subList.add(fileObj);
                    }
                    else if (!"".equals(StringUtil.nvl(vo.getSubtit3())) && "".equals(StringUtil.nvl(vo.getSubtitDelIds3()))) {
                        JSONObject fileObj = JSONObject.fromObject(JSONSerializer.toJSON(vo.getSubtit3().replace("&#034;", "\"")));
                        subList.add(fileObj);
                    }

                    lessonCntsVO.setSubtitKo(subList.toString());

                    if (!"".equals(scriptKoFiles) && !"[]".equals(scriptKoFiles)) {
                        JSONArray fileInfo = (JSONArray) JSONSerializer.toJSON(scriptKoFiles.replaceAll("\\\\", ""));
                        JSONObject fileObj = (JSONObject)fileInfo.get(0);
                        fileObj.put("saveNm", fileObj.getString("fileId") + "." + FileUtil.getFileExtention(fileObj.getString("fileNm")));
                        lessonCntsVO.setScriptKo(fileObj.toString());
                    }
                    else {
                        if(!"".equals(StringUtil.nvl(vo.getScriptKoDelIds()))) {
                            lessonCntsVO.setScriptKo(null);
                        } else {
                            lessonCntsVO.setScriptKo(StringUtil.nvl(vo.getScriptKo()).replace("&#034;", "\"") );
                        }
                    }

                    // 출결처리여부
                    if("Y".equals(StringUtil.nvl(prgrYn))) {
                        String videoTimeCalcMethod = vo.getVideoTimeCalcMethod();
                        Integer recmmdStudyTime = vo.getRecmmdStudyTime();

                        if("MANUAL".equals(StringUtil.nvl(videoTimeCalcMethod))) {
                            if(recmmdStudyTime == null) {
                                // 동영상 길이를 입력하세요.
                                throw processException("lesson.alert.message.empty.recmmd.study.time");
                            }

                            if(recmmdStudyTime == 0) {
                                // 출결체크 대상인 경우  0분을 입력할 수 없습니다.
                                throw processException("lesson.error.not.allow.time0");
                            }

                            lessonCntsVO.setRecmmdStudyTime(recmmdStudyTime);

                            resultVO.setResult(2);
                            resultVO.setMessage(String.valueOf(recmmdStudyTime));
                        } else {
                            if(uploadFileList.size() > 0) {
                                if(uploadFileList.size() == 1) {
                                    int videoSecound = 0;

                                    for(FileVO fileVO : uploadFileList) {
                                        String path = uploadPath + "/" + fileVO.getFilePath();

                                        try {
                                            videoSecound = VideoUtil.getVideoSecound(path);
                                            videoSecound = videoSecound / 60;

                                            if(videoSecound == 0) {
                                                // 1분미만의 동영상은 출결체크 콘텐츠로 등록할 수 없습니다.
                                                throw processException("lesson.error.fail.upload.lower.1minute.video");
                                            }
                                            resultVO.setResult(2);
                                            resultVO.setMessage(String.valueOf(videoSecound));
                                        } catch (EgovBizException e) {
                                            throw e;
                                        } catch (Exception e) {
                                            LOGGER.debug("e: ", e);
                                            resultVO.setResult(-2); // -2: 동영상 시간계산 실패
                                            resultVO.setReturnVO(lessonCntsVO);
                                        }
                                    }

                                    lessonCntsVO.setRecmmdStudyTime(videoSecound);
                                } else {
                                    throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
                                }
                            } else {
                                if("N".equals(oldLessonCntsVO.getPrgrYn())) {
                                    // 동영상 길이 재계산
                                    FileVO fileVO = new FileVO();
                                    fileVO.setRepoCd("LECTURE");
                                    fileVO.setFileBindDataSn(lessonCntsId);
                                    List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
                                    int videoSecound = 0;

                                    for(FileVO fileVO2 : fileList) {
                                        String path = uploadPath + "/" + fileVO2.getFileSaveNm();

                                        try {
                                            videoSecound = VideoUtil.getVideoSecound(path);
                                            videoSecound = videoSecound / 60;

                                            if(videoSecound == 0) {
                                                // 1분미만의 동영상은 출결체크 콘텐츠로 등록할 수 없습니다.
                                                throw processException("lesson.error.fail.upload.lower.1minute.video");
                                            }
                                            resultVO.setResult(2);
                                            resultVO.setMessage(String.valueOf(videoSecound));
                                        }  catch (EgovBizException e) {
                                            throw e;
                                        } catch (Exception e) {
                                            LOGGER.debug("e: ", e);
                                            resultVO.setResult(-2); // -2: 동영상 시간계산 실패
                                            resultVO.setReturnVO(lessonCntsVO);
                                        }
                                    }

                                    lessonCntsVO.setRecmmdStudyTime(videoSecound);
                                } else {
                                    lessonCntsVO.setRecmmdStudyTime(oldLessonCntsVO.getRecmmdStudyTime());
                                }
                            }
                        }
                    } else {
                        lessonCntsVO.setRecmmdStudyTime(null);
                    }
                }

                if(uploadFileList.size() > 0) {
                    // 3. 강의 컨텐츠 업로드
                    FileVO uploadFileVO = new FileVO();
                    uploadFileVO.setUploadFiles(uploadFiles);
                    uploadFileVO.setFilePath(uploadPath);
                    uploadFileVO.setRepoCd("LECTURE");
                    uploadFileVO.setRgtrId(rgtrId);
                    uploadFileVO.setFileBindDataSn(lessonCntsId);

                    uploadFileVO = sysFileService.addFile(uploadFileVO);

                    uploadedFileList.addAll((List<FileVO>) uploadFileVO.getFileList());

                    // 4.컨텐츠 재생 URL 세팅
                    String fileExt = StringUtil.nvl(uploadFileVO.getFileExt()).toLowerCase();

                    if("mp4".equals(fileExt)) {
                        String lessonCntsUrl = uploadPath + "/" + uploadFileVO.getFileSaveNm();
                        lessonCntsVO.setLessonCntsUrl(lessonCntsUrl);
                    }
                } else {
                    lessonCntsVO.setLessonCntsUrl(oldLessonCntsVO.getLessonCntsUrl());
                }

                // 수정
                lessonCntsDAO.update(lessonCntsVO);

                // 순차 학습 정렬순서 수정
                if("SEQ".equals(stdyMethod)) {
                    LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
                    lessonCntsVO2.setLessonTimeId(lessonTimeId);
                    lessonCntsVO2.setLessonCntsId(lessonCntsId);
                    lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
                }

                if("VIDEO".equals(cntsGbn)) {
                    // 주차 학습시간 갱신
                    LessonScheduleVO updateLbnTmVO = new LessonScheduleVO();
                    updateLbnTmVO.setLessonScheduleId(lessonScheduleId);
                    updateLbnTmVO.setMdfrId(mdfrId);
                    lessonScheduleDAO.updateLbnTm(updateLbnTmVO);

                    // 자막 업로드
                    List<UploadFileVO> subtitFileList = new ArrayList<>();

                    if(!"".equals(subtitFiles1)) {
                        subtitFileList.addAll(FileUtil.getUploadFileListV2(subtitFiles1));
                    }

                    if(!"".equals(subtitFiles2)) {
                        subtitFileList.addAll(FileUtil.getUploadFileListV2(subtitFiles2));
                    }

                    if(!"".equals(subtitFiles3)) {
                        subtitFileList.addAll(FileUtil.getUploadFileListV2(subtitFiles3));
                    }

                    if(subtitFileList.size() > 0) {
                        String subtitFiles = FileUtil.getUploadFileListToJsonString(subtitFileList);

                        FileVO uploadFileVO = new FileVO();
                        uploadFileVO.setUploadFiles(subtitFiles);
                        uploadFileVO.setFilePath(uploadPath);
                        uploadFileVO.setRepoCd("LECTURE_SUBTIT");
                        uploadFileVO.setRgtrId(rgtrId);
                        uploadFileVO.setFileBindDataSn(lessonCntsId);
                        //uploadFileVO = sysFileService.addFileWithObjectStorage(uploadFileVO);

                        uploadedFileList.addAll((List<FileVO>) uploadFileVO.getFileList());
                    }

                    // 스크립트 업로드
                    if(!"".equals(scriptKoFiles)) {
                        FileVO uploadFileVO = new FileVO();
                        uploadFileVO.setUploadFiles(scriptKoFiles);
                        uploadFileVO.setFilePath(uploadPath);
                        uploadFileVO.setRepoCd("LECTURE_SCRIPT");
                        uploadFileVO.setRgtrId(rgtrId);
                        uploadFileVO.setFileBindDataSn(lessonCntsId);
                        //uploadFileVO = sysFileService.addFileWithObjectStorage(uploadFileVO);

                        uploadedFileList.addAll((List<FileVO>) uploadFileVO.getFileList());
                    }

                    // 자막, 스크립트 삭제
                    String subtitDelIds1 = StringUtil.nvl(vo.getSubtitDelIds1());
                    String subtitDelIds2 = StringUtil.nvl(vo.getSubtitDelIds2());
                    String subtitDelIds3 = StringUtil.nvl(vo.getSubtitDelIds3());
                    String scriptKoDelIds = StringUtil.nvl(vo.getScriptKoDelIds());

                    if(!"".equals(subtitDelIds1) || !"".equals(subtitDelIds2) || !"".equals(subtitDelIds3)) {
                        FileVO fileVO = new FileVO();
                        fileVO.setRepoCd("LECTURE_SUBTIT");
                        fileVO.setFileBindDataSn(lessonCntsId);
                        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                        for(FileVO fvo : fileList) {
                            String fileId = fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf("."));
                            if(subtitDelIds1.equals(fileId) || subtitDelIds2.equals(fileId) || subtitDelIds3.equals(fileId)) {
                                sysFileService.removeFile(fvo.getFileSn());
                            }
                        }
                    }

                    if(!"".equals(scriptKoDelIds)) {
                        FileVO fileVO = new FileVO();
                        fileVO.setRepoCd("LECTURE_SCRIPT");
                        fileVO.setFileBindDataSn(lessonCntsId);
                        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                        for(FileVO fvo : fileList) {
                            String fileId = fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf("."));
                            if(scriptKoDelIds.equals(fileId)) {
                                sysFileService.removeFile(fvo.getFileSn());
                            }
                        }
                    }
                }

                // 선택 파일삭제
                if(delFileIds != null && delFileIds.length > 0) {
                    FileVO fileVO = new FileVO();
                    fileVO.setRepoCd("LECTURE");
                    fileVO.setFileBindDataSn(lessonCntsId);
                    List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                    for(String delFileId : delFileIds) {
                        for(FileVO fvo : fileList) {
                            if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                                sysFileService.removeFile(fvo.getFileSn());
                                break;
                            }
                        }
                    }
                }
            } catch (Exception e) {
                LOGGER.debug("e: ", e);

                if(ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(uploadFiles, uploadPath);
                }

                if(ValidationUtils.isNotEmpty(subtitFiles1) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(subtitFiles1, uploadPath);
                }

                if(ValidationUtils.isNotEmpty(subtitFiles2) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(subtitFiles2, uploadPath);
                }

                if(ValidationUtils.isNotEmpty(subtitFiles3) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(subtitFiles3, uploadPath);
                }

                if(ValidationUtils.isNotEmpty(scriptKoFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                    FileUtil.delUploadFileList(scriptKoFiles, uploadPath);
                }

                if("Y".equals(CommConst.OBJECT_STORAGE_USE_YN)) {
                    if(uploadedFileList != null && uploadedFileList.size() > 0) {
                        for(FileVO fileVO : uploadedFileList) {
                            String objectStoragePath = fileVO.getObjectStoragePath();

							/*
							 * if(ValidationUtils.isNotEmpty(objectStoragePath)) {
							 * objectStorageService.deleteObject(fileVO); }
							 */
                        }
                    }
                }

                throw e;
            }
        } else if("SOCIAL".equals(cntsGbn) || "LINK".equals(cntsGbn)) {
            String lessonCntsUrl = vo.getLessonCntsUrl();

            if(ValidationUtils.isEmpty(lessonCntsUrl)) {
                throw processException("lesson.alert.input.lesson.cnts"); // 학습자료를 입력하세요.
            }

            lessonCntsVO.setLessonCntsUrl(lessonCntsUrl);

            // 수정
            lessonCntsDAO.update(lessonCntsVO);

            // 순차 학습 정렬순서 수정
            if("SEQ".equals(stdyMethod)) {
                LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
                lessonCntsVO2.setLessonTimeId(lessonTimeId);
                lessonCntsVO2.setLessonCntsId(lessonCntsId);
                lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
            }

            // 기존 업로드 파일 삭제
            if(beforeUseFileUploader) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("LECTURE");
                fileVO.setFileBindDataSn(lessonCntsId);
                List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                for(FileVO fvo : fileList) {
                    sysFileService.removeFile(fvo.getFileSn());
                }

                if("VIDEO".equals(oldLessonCntsVO.getCntsGbn())) {
                    // 자막 삭제
                    fileVO = new FileVO();
                    fileVO.setRepoCd("LECTURE_SUBTIT");
                    fileVO.setFileBindDataSn(lessonCntsId);
                    fileList = sysFileService.list(fileVO).getReturnList();

                    for(FileVO fvo : fileList) {
                        sysFileService.removeFile(fvo.getFileSn());
                    }

                    // 스크립트 삭제
                    fileVO = new FileVO();
                    fileVO.setRepoCd("LECTURE_SCRIPT");
                    fileVO.setFileBindDataSn(lessonCntsId);
                    fileList = sysFileService.list(fileVO).getReturnList();

                    for(FileVO fvo : fileList) {
                        sysFileService.removeFile(fvo.getFileSn());
                    }
                }
            }
        } else if("TEXT".equals(cntsGbn)) {
            String cntsText = vo.getCntsText();

            if(ValidationUtils.isEmpty(cntsText)) {
                throw processException("lesson.alert.input.lesson.cnts"); // 학습자료를 입력하세요.
            }

            lessonCntsVO.setCntsText(cntsText);

            // 수정
            lessonCntsDAO.update(lessonCntsVO);

            // 순차 학습 정렬순서 수정
            if("SEQ".equals(stdyMethod)) {
                LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
                lessonCntsVO2.setLessonTimeId(lessonTimeId);
                lessonCntsVO2.setLessonCntsId(lessonCntsId);
                lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
            }

            // 기존 업로드 파일 삭제
            if(beforeUseFileUploader) {
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("LECTURE");
                fileVO.setFileBindDataSn(lessonCntsId);
                List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                for(FileVO fvo : fileList) {
                    sysFileService.removeFile(fvo.getFileSn());
                }

                if("VIDEO".equals(oldLessonCntsVO.getCntsGbn())) {
                    // 자막 삭제
                    fileVO = new FileVO();
                    fileVO.setRepoCd("LECTURE_SUBTIT");
                    fileVO.setFileBindDataSn(lessonCntsId);
                    fileList = sysFileService.list(fileVO).getReturnList();

                    for(FileVO fvo : fileList) {
                        sysFileService.removeFile(fvo.getFileSn());
                    }

                    // 스크립트 삭제
                    fileVO = new FileVO();
                    fileVO.setRepoCd("LECTURE_SCRIPT");
                    fileVO.setFileBindDataSn(lessonCntsId);
                    fileList = sysFileService.list(fileVO).getReturnList();

                    for(FileVO fvo : fileList) {
                        sysFileService.removeFile(fvo.getFileSn());
                    }
                }
            }
        } else if("VIDEO_LINK".equals(cntsGbn)) {
        	// 목차저장
        	lessonCntsVO.setRecmmdStudyTime(vo.getRecmmdStudyTime());
        	lessonCntsDAO.update(lessonCntsVO);

        	if (vo.getWeek() > 0) {
	        	List<LessonPageVO> pageList = new ArrayList<LessonPageVO>();
	        	LessonPageVO lessonPageVO = null;
	        	ErpLcdmsPageVO pageVO = new ErpLcdmsPageVO();
	        	pageVO.setYear(vo.getYear());
	        	pageVO.setSemester(vo.getSemester());
	        	pageVO.setCourseCode(vo.getCourseCode());
	        	pageVO.setWeek(vo.getWeek());

        		// 기존 페이지 삭제
	        	lessonPageVO = new LessonPageVO();
	        	lessonPageVO.setLessonCntsId(lessonCntsId);
        		lessonPageDAO.delete(lessonPageVO);

	        	// 페이지 목록 조회
	        	List<ErpLcdmsPageVO> erpPageList = erpService.listLcdmsPage(pageVO);

	        	for (ErpLcdmsPageVO pageVO2 : erpPageList) {
	                int videoTm = 0;
	                if (!"".equals(StringUtil.nvl(pageVO2.getLbnTm()))) {
	                    String lbnTm = pageVO2.getLbnTm();
	                    if (lbnTm.indexOf(".") > -1) {
	                        lbnTm = lbnTm.substring(0,lbnTm.indexOf("."));
	                    }
	                    String[] tm = lbnTm.split(":");

	                    if (tm.length > 1) {
	                        videoTm = "".equals(tm[0]) ? 0 : Integer.parseInt(tm[0]) * 60;
	                        videoTm += "".equals(tm[1]) ? 0 : Integer.parseInt(tm[1]);
	                    }
	                    else {
	                        videoTm = Integer.parseInt(tm[0]);
	                    }
	                }

	                String pattern = "_\\d{2}_\\d{2}$";
	                String pageNm = StringUtil.nvl(pageVO2.getPageNm());

	                if(pageNm.matches(".*" + pattern)) {
	                    pageNm = pageNm.replaceAll(pattern, "") + "_" + StringUtil.fillLeft("" + lessonScheduleVO.getLessonScheduleOrder(), 2, "0") + "_" + StringUtil.fillLeft("" + pageVO2.getPageCnt(), 2, "0");
	                }

	        		lessonPageVO = new LessonPageVO();
	        		lessonPageVO.setLessonCntsId(lessonCntsId);
	        		lessonPageVO.setPageCnt(pageVO2.getPageCnt());
	        		lessonPageVO.setUploadGbn(pageVO2.getUploadGbn());
	        		lessonPageVO.setPageNm(pageNm);
	        		lessonPageVO.setUrl(pageVO2.getUrl());
	        		lessonPageVO.setVideoTm(videoTm);
	        		lessonPageVO.setAtndYn(pageVO2.getLmsAttendYn());
	        		lessonPageVO.setOpenYn("Y");
	        		lessonPageVO.setRgtrId(rgtrId);
	        		pageList.add(lessonPageVO);
	        	}

	        	if (pageList.size() > 0) {
	        		// 페이지목록 저장
	        		lessonPageDAO.insertLessonPageList(pageList);
	        	}

	        	// 콘텐츠 조회
                ErpLcdmsCntsVO erpLcdmsCntsVO = new ErpLcdmsCntsVO();
                erpLcdmsCntsVO.setYear(vo.getYear());
                erpLcdmsCntsVO.setSemester(vo.getSemester());
                erpLcdmsCntsVO.setCourseCode(vo.getCourseCode());
                erpLcdmsCntsVO.setWeek(vo.getWeek());
                erpLcdmsCntsVO = erpService.selectLcdmsCnts(erpLcdmsCntsVO);

                String ltNote = "";
                String ltNoteOfferYn = "N";

                if(erpLcdmsCntsVO != null) {
                    ltNote = erpLcdmsCntsVO.getLtNote();
                    ltNoteOfferYn = StringUtil.nvl(erpLcdmsCntsVO.getLtNoteOfferYn(), "N");
                }

                // 강의노트 수정
                LessonScheduleVO updateLtNoteVO = new LessonScheduleVO();
                updateLtNoteVO.setLessonScheduleId(lessonScheduleId);
                updateLtNoteVO.setLtNoteOfferYn(ltNoteOfferYn);
                updateLtNoteVO.setLtNote(ltNote);
                updateLtNoteVO.setMdfrId(mdfrId);
                lessonScheduleDAO.update(updateLtNoteVO);
        	}

        	// 주차 학습시간 갱신
            LessonScheduleVO updateLbnTmVO = new LessonScheduleVO();
            updateLbnTmVO.setLessonScheduleId(lessonScheduleId);
            updateLbnTmVO.setMdfrId(mdfrId);
            lessonScheduleDAO.updateLbnTm(updateLbnTmVO);
        }

        return resultVO;
    }

    /*****************************************************
     * 학습 콘텐츠 삭제
     * @param LessonCntsVO
     * @return
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(LessonCntsVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String lessonCntsId = vo.getLessonCntsId();
        String mdfrId = vo.getMdfrId();

        // 기존 학습콘텐츠 정보 조회
        LessonCntsVO lessonCntsVO = new LessonCntsVO();
        lessonCntsVO.setCrsCreCd(crsCreCd);
        lessonCntsVO.setLessonCntsId(lessonCntsId);
        lessonCntsVO = lessonCntsDAO.select(lessonCntsVO);

        if(lessonCntsVO == null) {
            throw processException("lesson.error.not.exists.lesson.cnts"); // 학습자료 정보를 찾을 수 없습니다.
        }

        String lessonScheduleId = lessonCntsVO.getLessonScheduleId();

        // 교시 정보 조회
        String lessonTimeId = lessonCntsVO.getLessonTimeId();

        LessonTimeVO lessonTimeVO = new LessonTimeVO();
        lessonTimeVO.setLessonTimeId(lessonTimeId);
        lessonTimeVO = lessonTimeDAO.select(lessonTimeVO);

        String stdyMethod = lessonTimeVO.getStdyMethod();

        String cntsGbn = lessonCntsVO.getCntsGbn();
        String prgrYn = lessonCntsVO.getPrgrYn();

        // 외부 링크 콘텐츠 교수가 삭제 불가, LCDMS 미연동인 경우는 예외
        if("VIDEO_LINK".equals(StringUtil.nvl(cntsGbn)) && !"N".equals(vo.getLcdmsLinkYn())) {
            throw processException("lesson.error.no.auth.delete.lesson.cnts"); // 삭제할 수 없는 학습콘텐츠 입니다.
        }

        // 학습페이지 삭제
        LessonPageVO lessonPageVO = new LessonPageVO();
        lessonPageVO.setLessonCntsId(lessonCntsId);
        lessonPageDAO.delete(lessonPageVO);

        // 학습콘텐츠 댓글 삭제
        LessonCntsCmntVO lessonCntsCmntVO = new LessonCntsCmntVO();
        lessonCntsCmntVO.setLessonCntsId(lessonCntsId);
        lessonCntsCmntDAO.delete(lessonCntsCmntVO);

        // 학습콘텐츠 추천 삭제
        LessonCntsRecomVO lessonCntsRecomVO = new LessonCntsRecomVO();
        lessonCntsRecomVO.setLessonCntsId(lessonCntsId);
        lessonCntsRecomDAO.delete(lessonCntsRecomVO);

        // 수강생 학습기록 삭제
        LessonStudyRecordVO lessonStudyRecordVO = new LessonStudyRecordVO();
        lessonStudyRecordVO.setLessonCntsId(lessonCntsId);
        lessonStudyService.deleteLessonStudyRecord(lessonStudyRecordVO);

        // 학습콘텐츠 삭제
        lessonCntsDAO.delete(vo);

        // 순차 학습 정렬순서 수정
        if("SEQ".equals(stdyMethod)) {
            LessonCntsVO lessonCntsVO2 = new LessonCntsVO();
            lessonCntsVO2.setLessonTimeId(lessonTimeId);
            lessonCntsDAO.updateSeqLessonCntsOrder(lessonCntsVO2);
        }

        // 등록된 파일 삭제
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("LECTURE");
        fileVO.setFileBindDataSn(lessonCntsId);
        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

        for(FileVO fvo : fileList) {
            sysFileService.removeFile(fvo.getFileSn());
        }

        if("VIDEO".equals(cntsGbn)) {
            // 자막 삭제
            fileVO = new FileVO();
            fileVO.setRepoCd("LECTURE_SUBTIT");
            fileVO.setFileBindDataSn(lessonCntsId);
            fileList = sysFileService.list(fileVO).getReturnList();

            for(FileVO fvo : fileList) {
                sysFileService.removeFile(fvo.getFileSn());
            }

            // 스크립트 삭제
            fileVO = new FileVO();
            fileVO.setRepoCd("LECTURE_SCRIPT");
            fileVO.setFileBindDataSn(lessonCntsId);
            fileList = sysFileService.list(fileVO).getReturnList();

            for(FileVO fvo : fileList) {
                sysFileService.removeFile(fvo.getFileSn());
            }
        }

        // 출결체크 동영상인경우 주차 학습시간 갱신
        if(("VIDEO".equals(cntsGbn) || "VIDEO_LINK".equals(cntsGbn)) && "Y".equals(prgrYn)) {
            LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
            lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
            lessonScheduleVO.setMdfrId(mdfrId);
            lessonScheduleDAO.updateLbnTm(lessonScheduleVO);
        }
    }

    /*****************************************************
     * 학습 콘텐츠 순서 최대값
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int selectLessonCntsOrderMax(LessonCntsVO vo) throws Exception {
        return lessonCntsDAO.selectLessonCntsOrderMax(vo);
    }

    /*****************************************************
     * 학습 콘텐츠 학습자 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countLessonCntsStudyRecord(LessonCntsVO vo) throws Exception {
        return lessonCntsDAO.countLessonCntsStudyRecord(vo);
    }

    /*****************************************************
     * 강의실 접속 현황
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> selectStdEnterStatusList(LessonCntsVO vo) throws Exception {
        return lessonCntsDAO.selectStdEnterStatusList(vo);
    }

    /*****************************************************
     * 강의컨텐츠 페이지 저장
     * @param LessonCntsVO
     * @return
     * @throws Exception
     ******************************************************/
    public void saveLessonPage(LessonCntsVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String rgtrId = vo.getRgtrId();
        String crsCreCd = vo.getCrsCreCd();
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();
        String[] delFileIds = vo.getDelFileIds();

        CreCrsVO creCrsVO = new CreCrsVO();
        creCrsVO.setOrgId(orgId);
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO = crecrsDAO.select(creCrsVO);

        String crsTypeCd = StringUtil.nvl(creCrsVO.getCrsTypeCd(), "UNI");

        if("UNI".equals(crsTypeCd)) {
            // 학기제 과목은 등록할 수 없습니다.
            throw processException("lesson.error.not.allow.insert.uni");
        }

        // 기본 주차, 교시, 강의컨텐츠 조회
        creCrsVO = new CreCrsVO();
        creCrsVO.setCrsCreCd(crsCreCd);
        creCrsVO.setCrsTypeCd(crsTypeCd);
        creCrsVO = crecrsDAO.select(creCrsVO);

        String lessonScheduleId = creCrsVO.getLessonScheduleId();
        String lessonCntsId = creCrsVO.getLessonCntsId();

        if(ValidationUtils.isEmpty(lessonCntsId)) {
            // 학습자료 정보를 찾을 수 없습니다.
            throw processException("lesson.error.not.exists.lesson.cnts");
        }

        // 페이지에서 저장 파일명 추출
        LessonPageVO lessonPageVO = new LessonPageVO();
        lessonPageVO.setLessonCntsId(lessonCntsId);
        List<LessonPageVO> listLessonPage = lessonPageDAO.list(lessonPageVO);
        Map<String, LessonPageVO> lessonPageFileSaveNmMap = new HashMap<>();
        for(LessonPageVO lessonPageVO2 : listLessonPage) {
            String url = StringUtil.nvl(lessonPageVO2.getUrl());

            int lastIndex = url.lastIndexOf('/');
            String fileSaveName = url.substring(lastIndex + 1);

            if(!"".equals(fileSaveName)) {
                lessonPageFileSaveNmMap.put(fileSaveName, lessonPageVO2);
            }
        }

        // 선택 파일삭제
        if(delFileIds != null && delFileIds.length > 0) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("LECTURE");
            fileVO.setFileBindDataSn(crsCreCd);
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

            for(String delFileId : delFileIds) {
            	if ("".equals(StringUtil.nvl(delFileId))) {
            		continue;
            	}

                for(FileVO fvo : fileList) {
                    String fileSaveNm = fvo.getFileSaveNm();
                    if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                        LessonPageVO lessonPageVO2 = lessonPageFileSaveNmMap.get(fileSaveNm);

                        if(lessonPageVO2 != null) {
                            String pageCnt = lessonPageVO2.getPageCnt();

                            LessonPageVO deleteLessonPageVO = new LessonPageVO();
                            deleteLessonPageVO.setLessonCntsId(lessonCntsId);
                            deleteLessonPageVO.setPageCnt(pageCnt);

                            lessonPageDAO.deleteLessonStudyPage(deleteLessonPageVO); // 페이지 학습기록 삭제
                            lessonPageDAO.delete(deleteLessonPageVO); // 페이지 삭제
                        }

                        sysFileService.removeFile(fvo.getFileSn());
                        break;
                    }
                }
            }
        }

        if(ValidationUtils.isNotEmpty(uploadFiles)) {
            List<FileVO> uploadFileList = FileUtil.getUploadFileList(uploadFiles);

            if(uploadFileList.size() > 0) {
                FileVO uploadFileVO = new FileVO();
                uploadFileVO.setOrgId(orgId);
                uploadFileVO.setUploadFiles(uploadFiles);
                uploadFileVO.setFilePath(uploadPath);
                uploadFileVO.setRepoCd("LECTURE");
                uploadFileVO.setRgtrId(rgtrId);
                uploadFileVO.setFileBindDataSn(crsCreCd);
                uploadFileVO = sysFileService.addFile(uploadFileVO);

                @SuppressWarnings("unchecked")
                List<FileVO> uploadedFileList = (List<FileVO>) uploadFileVO.getFileList();

                for(FileVO fileVO : uploadedFileList) {
                    String fileExt = fileVO.getFileExt();

                    if(!"mp4".equals(StringUtil.nvl(fileExt))) {
                        // mp4 파일만 등록가능합니다.
                        throw processException("lesson.error.allow.mp4");
                    }

                    String url = uploadPath + "/" + fileVO.getFileSaveNm();

                    // 동영상 길이 계산
                    int videoTm = 0;
                    String path = url;

                    videoTm = VideoUtil.getVideoSecound(path);

                    // 페이지 등록
                    LessonPageVO insertLessonPageVO = new LessonPageVO();
                    insertLessonPageVO.setLessonCntsId(lessonCntsId);
                    insertLessonPageVO.setUploadGbn(fileExt);
                    insertLessonPageVO.setPageNm(creCrsVO.getCrsCreNm());
                    insertLessonPageVO.setUrl(url);
                    insertLessonPageVO.setVideoTm(videoTm);
                    if("OPEN".equals(crsTypeCd)) {
                        insertLessonPageVO.setAtndYn("N");
                    } else {
                        insertLessonPageVO.setAtndYn("Y");
                    }
                    insertLessonPageVO.setOpenYn("Y");
                    insertLessonPageVO.setRgtrId(rgtrId);
                    insertLessonPageVO.setMdfrId(rgtrId);

                    lessonPageDAO.insert(insertLessonPageVO);
                }
            }
        }

        // 페이지명 넘버 수정
        lessonPageVO = new LessonPageVO();
        lessonPageVO.setLessonCntsId(lessonCntsId);
        List<LessonPageVO> listLessonPage2 = lessonPageDAO.list(lessonPageVO);

        for(int i = 0; i < listLessonPage2.size(); i++) {
            String pageCnt = listLessonPage2.get(i).getPageCnt();
            String idx;

            if((i + 1) < 10) {
                idx = "0" + (i + 1);
            } else {
                idx = "" + (i + 1);
            }

            String pageNm = creCrsVO.getCrsCreNm() + "_" + idx;

            LessonPageVO updateLessonPageVO = new LessonPageVO();
            updateLessonPageVO.setLessonCntsId(lessonCntsId);
            updateLessonPageVO.setPageCnt(pageCnt);
            updateLessonPageVO.setPageNm(pageNm);
            updateLessonPageVO.setMdfrId(rgtrId);
            lessonPageDAO.update(updateLessonPageVO);
        }

        // 동영상 길이로 학습시간 수정
        FileVO fileVO = new FileVO();
        fileVO.setRepoCd("LECTURE");
        fileVO.setFileBindDataSn(crsCreCd);
        List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
        int totalVideoTm = 0;
        for(FileVO fvo : fileList) {
            String path = uploadPath + "/" + fvo.getFileSaveNm();

            LOGGER.info("동영상 길이 체크 START ===================================================");
            System.out.println("동영상 길이 체크 START ===================================================");
            totalVideoTm += VideoUtil.getVideoSecound(path);
            System.out.println("동영상 길이 체크 END ===================================================");
            LOGGER.info("동영상 길이 체크 END ===================================================");
        }

        totalVideoTm = totalVideoTm == 0 ? 0 : totalVideoTm / 60;

        LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
        lessonScheduleVO.setLessonScheduleId(lessonScheduleId);
        lessonScheduleVO.setLbnTmStr("" + totalVideoTm);
        lessonScheduleVO.setMdfrId(rgtrId);
        lessonScheduleDAO.update(lessonScheduleVO);
        System.out.println("최종 동영상 길이: " + totalVideoTm + " 초");
        LOGGER.info("최종 동영상 길이: " + totalVideoTm + " 초");
    }

    /*****************************************************
     * 학습 콘텐츠 복사
     * @param LessonCntsVO
     * @return
     * @throws Exception
     ******************************************************/
    @Override
    public void copyLessonCnts(LessonCntsVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String copyLessonCntsId = vo.getCopyLessonCntsId();
        String rgtrId = vo.getRgtrId();

        if(ValidationUtils.isEmpty(orgId)
            || ValidationUtils.isEmpty(crsCreCd)
            || ValidationUtils.isEmpty(copyLessonCntsId)
            || ValidationUtils.isEmpty(rgtrId)) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }

        // 복사대상 학습콘텐츠 조회
        LessonCntsVO originLessonCntsVO = new LessonCntsVO();
        originLessonCntsVO.setLessonCntsId(copyLessonCntsId);
        originLessonCntsVO = lessonCntsDAO.select(originLessonCntsVO);

        if(originLessonCntsVO == null) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }

        // 강의실의 주차 조회
        LessonScheduleVO searchLessonScheduleVO = new LessonScheduleVO();
        searchLessonScheduleVO.setCrsCreCd(crsCreCd);
        List<LessonScheduleVO> listLessonSchedule = lessonScheduleDAO.listLessonScheduleAll(searchLessonScheduleVO);
        LessonScheduleVO copyLessonScheduleVO = null;

        for(LessonScheduleVO lessonScheduleVO2 : listLessonSchedule) {
            String lessonScheduleOrder = lessonScheduleVO2.getLessonScheduleOrder().toString();

            if(lessonScheduleOrder.equals(originLessonCntsVO.getLessonScheduleOrder())) {
                copyLessonScheduleVO = lessonScheduleVO2;
            }
        }

        // 주차정보가 없는경우
        if(copyLessonScheduleVO == null) {
            throw processException("lesson.error.not.exists.lesson.schedule"); // 주차 정보를 찾을 수 업습니다.
        }

        LessonTimeVO copyLessonTimeVO = null;
        List<LessonTimeVO> listLessonTime = copyLessonScheduleVO.getListLessonTime();
        for(LessonTimeVO lessonTimeVO : listLessonTime) {
            String lessonTimeOrder = lessonTimeVO.getLessonTimeOrder().toString();
            if(lessonTimeOrder.equals(originLessonCntsVO.getLessonTimeOrder())) {
                copyLessonTimeVO = lessonTimeVO;
            }
        }

        // 교시정보가 없는경우 원본의 교시 복사
        if(copyLessonTimeVO == null) {
            String lessonTimeId = IdGenerator.getNewId("LSTM");

            copyLessonTimeVO = new LessonTimeVO();
            copyLessonTimeVO.setLessonTimeId(lessonTimeId);
            copyLessonTimeVO.setLessonScheduleId(copyLessonScheduleVO.getLessonScheduleId());
            copyLessonTimeVO.setCrsCreCd(crsCreCd);
            copyLessonTimeVO.setRgtrId(rgtrId);
            copyLessonTimeVO.setCopyLessonTimeId(originLessonCntsVO.getLessonTimeId());
            lessonTimeDAO.copyLessonTime(copyLessonTimeVO);
        }

        // 학습자료 복사
        String lessonCntsId = IdGenerator.getNewId("LECN");

        LessonCntsVO copyLessonCntsVO = new LessonCntsVO();
        copyLessonCntsVO.setLessonCntsId(lessonCntsId);
        copyLessonCntsVO.setCrsCreCd(crsCreCd);
        copyLessonCntsVO.setLessonTimeId(copyLessonTimeVO.getLessonTimeId());
        copyLessonCntsVO.setLessonScheduleId(copyLessonScheduleVO.getLessonScheduleId());
        copyLessonCntsVO.setRgtrId(rgtrId);
        copyLessonCntsVO.setCopyLessonCntsId(copyLessonCntsId);
        lessonCntsDAO.copyLessonCnts(copyLessonCntsVO);

        FileVO copyFileVO;
        copyFileVO = new FileVO();
        copyFileVO.setOrgId(orgId);
        copyFileVO.setRepoCd("LECTURE");
        copyFileVO.setFileBindDataSn(lessonCntsId);
        copyFileVO.setCopyFileBindDataSn(copyLessonCntsId);
        copyFileVO.setRgtrId(rgtrId);
        sysFileService.copyFileInfoFromOrigin(copyFileVO);

        // 출결체크 동영상인경우 주차 학습시간 갱신
        if("VIDEO".equals(originLessonCntsVO.getCntsGbn()) && "Y".equals(originLessonCntsVO.getPrgrYn())) {
            LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
            lessonScheduleVO.setLessonScheduleId(copyLessonScheduleVO.getLessonScheduleId());
            lessonScheduleVO.setMdfrId(rgtrId);
            lessonScheduleDAO.updateLbnTm(lessonScheduleVO);
        }
    }
}
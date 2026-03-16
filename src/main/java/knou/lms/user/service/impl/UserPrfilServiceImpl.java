package knou.lms.user.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.crs.semester.service.SemesterService;
import knou.lms.crs.semester.vo.SmstrChrtVO;
import knou.lms.user.dao.UserPrfilDAO;
import knou.lms.user.dao.UsrUserAuthGrpDAO;
import knou.lms.user.service.UserPrfilService;
import knou.lms.user.vo.UserPrfilVO;
import knou.lms.user.vo.UserTelnoChgHstryVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.imgscalr.Scalr;
import org.springframework.dao.DataRetrievalFailureException;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;

@Service("userPrfilService")
public class UserPrfilServiceImpl extends ServiceBase implements UserPrfilService {

    @Resource(name="userPrfilDAO")
    private UserPrfilDAO userPrfilDAO;
    @Resource(name="usrUserAuthGrpDAO")
    private UsrUserAuthGrpDAO usrUserAuthGrpDAO;
    @Resource(name="semesterService")
    private SemesterService semesterService;

    /**
     * 사용자프로필정보를 조회한다.
     *
     * @param vo UserPrfilVO
     * @return UserPrfilVO
     * @throws Exception
     */
    @Override
    public UserPrfilVO userPrfilSelect(UserPrfilVO vo) throws Exception {
        UserPrfilVO userPrfilVO = userPrfilDAO.userPrfilSelect(vo);
        if(userPrfilVO == null) {
            throw new DataRetrievalFailureException("Database Error!, There is no returned data.");
        }

        // 사진파일이 있으면 변환
        /*if(userPrfilVO.getPhtFileByte() != null && userPrfilVO.getPhtFileByte().length > 0) {
            userPrfilVO.setPhotoFileId("data:image/png;base64," + new String(Base64.getEncoder().encode(uuivo.getPhtFileByte())));
        }*/

        //this.getAuthGrp(vo);


        return userPrfilVO;
    }

    /**
     * 사용자프로필 알림수신여부 변경
     *
     * @param vo UserPrfilVO
     * @throws Exception
     */
    public void userPrfilAlimChange(UserPrfilVO vo) throws Exception {
        // 기존 플래그 조회
        String currentFlag = userPrfilDAO.pushTalkSmsFlagSelect(vo).getPushTalkSmsFlag();

        // 푸시톡 문자수신플래그 조립
        if(currentFlag == null || currentFlag.length() < 10) {
            currentFlag = "0000000000";
        } else if(currentFlag.length() > 10) {
            currentFlag = currentFlag.substring(0, 10);
        }

        char[] a = currentFlag.toCharArray();
        // 1번째: SMS
        a[0] = "Y".equals(vo.getSmsRcvyn()) ? '1' : '0';
        // 4번째: PUSH
        a[3] = "Y".equals(vo.getPushRcvyn()) ? '1' : '0';
        // 6번째: ALIM_TALK
        a[5] = "Y".equals(vo.getAlimTalkRcvyn()) ? '1' : '0';

        vo.setPushTalkSmsFlag(new String(a));

        userPrfilDAO.userPrfilAlimChange(vo);
    }

    /**
     * 사용자모든기관목록
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<UserPrfilVO> userAllOrgAuthrtList(UserPrfilVO vo) throws Exception {
        return userPrfilDAO.userAllOrgAuthrtList(vo);

    }

    /**
     * 현재학기 강의 기관 목록 조회
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<UserPrfilVO> nowSmstrLectOrgList(UserPrfilVO vo) throws Exception {
        return userPrfilDAO.nowSmstrLectOrgList(vo);
    }

    /**
     * 패스워드 일치여부 확인
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public boolean isPswdMtch(UserPrfilVO vo) throws Exception {
        return userPrfilDAO.isPswdMtch(vo) > 0;
    }

    /**
     * 사용자 기본정보 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void modifyUserBasic(UserPrfilVO vo) throws Exception {

        // 사용자 기본정보 수정
        userPrfilDAO.modifyUserBasic(vo);


    }

    /**
     * 사용자 연락처 수정
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void modifyUserCntct(UserPrfilVO vo) throws Exception {

        List<UserPrfilVO> list = new ArrayList<>();

        // 개인이메일
        if("INDV".equals(vo.getUseEmlGbncd()) && !ValidationUtils.isEmpty(vo.getIndvEml())) {
            UserPrfilVO cntct = new UserPrfilVO();
            cntct.setUserId(vo.getUserId());
            cntct.setCntctTycd("INDV_EML");
            cntct.setCntct(vo.getIndvEml());
            list.add(cntct);
        }

        // 모바일전화
        String oldMblPhn = null;
        String newMblPhn = null;
        boolean mobileChanged = false;

        if(!ValidationUtils.isEmpty(vo.getMblPhn())) {
            UserPrfilVO cntct = new UserPrfilVO();
            cntct.setUserId(vo.getUserId());
            cntct.setCntctTycd("MBL_PHN");
            cntct.setCntct(vo.getMblPhn());
            list.add(cntct);

            // 모바일전화번호 변경이력 저장
            oldMblPhn = userPrfilDAO.userCntctSelect(cntct);
            newMblPhn = vo.getMblPhn();
            String oldCompare = oldMblPhn == null ? "" : oldMblPhn.replace("-", "");
            String newCompare = newMblPhn == null ? "" : newMblPhn.replace("-", "");

            mobileChanged = !oldCompare.equals(newCompare);
        }

        for(UserPrfilVO c : list) {
            c.setRgtrId(vo.getUserId());
            c.setMdfrId(vo.getUserId());
            c.setUserCntctId(IdGenUtil.genNewId(IdPrefixType.USCTT));

            userPrfilDAO.mergeUserCntct(c);
        }

        // 모바일전화번호 변경 시 이력 저장
        if(mobileChanged) {
            insertUserTelnoChgHstry(vo, oldMblPhn, newMblPhn);
        }
    }

    /**
     * 사용자 기관권한 동기화
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void modifyUserOrgAuthrt(UserPrfilVO vo) throws Exception {
        List<String> newOrgIdList = vo.getOrgIdList() == null ? new ArrayList<>() : vo.getOrgIdList();

        // 기존 권한 목록
        List<UserPrfilVO> oldOrgAuthrtList = userPrfilDAO.userAllOrgAuthrtList(vo);

        List<String> oldOrgIdList = new ArrayList<>();
        List<String> deleteAuthrtIdList = new ArrayList<>();

        for(UserPrfilVO oldVO : oldOrgAuthrtList) {
            String oldOrgId = oldVO.getOrgId();
            oldOrgIdList.add(oldOrgId);

            if(!newOrgIdList.contains(oldOrgId)) {
                deleteAuthrtIdList.add(oldVO.getAuthrtId());
            }
        }

        /* -----------------------------
         * 삭제 대상 : 기존 - 신규
         * ----------------------------- */
        if(!deleteAuthrtIdList.isEmpty()) {
            UserPrfilVO delVO = new UserPrfilVO();
            delVO.setUserId(vo.getUserId());
            delVO.setAuthrtIdList(deleteAuthrtIdList);
            userPrfilDAO.deleteUserAuthrtByAuthrtIdList(delVO);
        }

        /* -----------------------------
         * 추가 대상 : 신규 - 기존
         * ----------------------------- */
        for(String newOrgId : newOrgIdList) {
            if(!oldOrgIdList.contains(newOrgId)) {
                UserPrfilVO ivo = new UserPrfilVO();
                ivo.setUserId(vo.getUserId());
                ivo.setOrgId(newOrgId);
                ivo.setAuthrtGrpcd(vo.getAuthrtGrpcd());
                ivo.setAuthrtCd(vo.getAuthrtCd());
                ivo.setRgtrId(vo.getUserId());
                ivo.setUserAuthrtId(IdGenUtil.genNewId(IdPrefixType.USAUT));

                userPrfilDAO.insertUserAuthrtByAuthrtSelect(ivo);

            }
        }
    }

    /**
     * 사용자 사진 업로드
     *
     * @param vo
     * @throws Exception
     */
    @Override
    public void uploadUserPhoto(UserPrfilVO vo) throws Exception {
        // 삭제 요청이면 우선 처리
        if("Y".equals(vo.getPhotoFileDelyn())) {
            vo.setPhotoFileId(null);
            return;
        }
        String uploadFiles = StringUtil.nvl(vo.getUploadFiles());
        String uploadPath = StringUtil.nvl(vo.getUploadPath());

        // 업로드 없으면 종료
        if(ValidationUtils.isEmpty(uploadFiles) || ValidationUtils.isEmpty(uploadPath)) {
            return;
        }

        // JSON escape 제거 후 파싱
        uploadFiles = StringUtil.nvl(uploadFiles.replaceAll("\\\\", ""));
        JSONArray fileArray = (JSONArray) net.sf.json.JSONSerializer.toJSON(uploadFiles);
        if(fileArray == null || fileArray.size() == 0) {
            return;
        }

        JSONObject fileObj = (JSONObject) fileArray.get(0);

        String fileNm = StringUtil.nvl(fileObj.optString("fileNm"));
        String fileId = StringUtil.nvl(fileObj.optString("fileId"));
        if(ValidationUtils.isEmpty(fileNm) || ValidationUtils.isEmpty(fileId)) {
            return;
        }

        String ext = StringUtil.getExtNoneDot(fileNm).toLowerCase();
        String fileDir = CommConst.WEBDATA_PATH + uploadPath + "/" + fileId + "." + ext;
        File phtFile = new File(fileDir);
        if(!phtFile.exists()) {
            return;
        }

        // 이미지로 읽어서 썸네일 생성(156x156)
        BufferedImage im = null;
        try {
            im = ImageIO.read(phtFile);
        } catch(IOException ignore) {
            im = null;
        }

        if(im != null) {
            int width = Math.min(156, im.getWidth());
            int height = Math.min(156, im.getHeight());

            BufferedImage thumbImg = Scalr.resize(im, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_WIDTH, width);
            if(thumbImg.getHeight() > height) {
                thumbImg = Scalr.resize(im, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, height);
            }

            ByteArrayOutputStream os = new ByteArrayOutputStream();
            if(ext.endsWith("png")) {
                ImageIO.write(thumbImg, "PNG", os);
            } else if(ext.endsWith("jpg") || ext.endsWith("jpeg")) {
                ImageIO.write(thumbImg, "JPG", os);
            } else {
                ImageIO.write(thumbImg, "GIF", os);
            }

            //vo.setPhtFileByte(os.toByteArray());  //
            vo.setPhotoFileId(fileId);
            return;
        }

        // 이미지 변환 실패 시: 원본 byte[] 그대로
        try(FileInputStream inputStream = new FileInputStream(phtFile)) {
            byte[] bytes = new byte[(int) phtFile.length()];
            int read = inputStream.read(bytes);
            if(read > 0) {
                //vo.setPhtFileByte(bytes);
            }
        }
    }

    /**
     * 핸드폰번호 변경 시 이력 저장
     *
     * @param vo
     * @param oldMblPhn 기존핸드폰번호
     * @param newMblPhn 새로입력한 핸드폰번호
     * @throws Exception
     */
    @Override
    public void insertUserTelnoChgHstry(UserPrfilVO vo, String oldMblPhn, String newMblPhn) throws Exception {
        LinkedHashSet<String> orgIdSet = new LinkedHashSet<String>();

        if(vo.getOrgIdList() != null) {
            for(String orgId : vo.getOrgIdList()) {
                if(!ValidationUtils.isEmpty(orgId)) {
                    orgIdSet.add(orgId);
                }
            }
        }

        if(orgIdSet.isEmpty() && !ValidationUtils.isEmpty(vo.getOrgId())) {
            orgIdSet.add(vo.getOrgId());
        }

        for(String orgId : orgIdSet) {
            // 학위년도, 학위학기기수 조회
            SmstrChrtVO tempVO = new SmstrChrtVO();
            tempVO.setOrgId(orgId);
            SmstrChrtVO smstrChrtVO = semesterService.selectCurrentSemester(tempVO);

            if(smstrChrtVO == null) {
                continue;
            }

            UserTelnoChgHstryVO histVo = new UserTelnoChgHstryVO();
            histVo.setOrgId(orgId);
            histVo.setUserTelnoChgHstryId(IdGenUtil.genNewId(IdPrefixType.USTHS));
            histVo.setUserId(vo.getUserId());
            histVo.setChgbfrMblTelno(oldMblPhn);
            histVo.setChgaftMblTelno(newMblPhn);
            histVo.setDgrsYr(smstrChrtVO.getDgrsYr());
            histVo.setDgrsSmstrChrt(smstrChrtVO.getDgrsSmstrChrt());

            histVo.setUserRprsId(vo.getUserRprsId());
            histVo.setStdntNo(vo.getStdntNo());
            histVo.setRgtrId(vo.getUserId());

            userPrfilDAO.telnoChgHstryRegist(histVo);
        }
    }

}

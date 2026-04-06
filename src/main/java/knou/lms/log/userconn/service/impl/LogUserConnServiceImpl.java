package knou.lms.log.userconn.service.impl;

import java.util.Base64;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.util.CommonUtil;
import knou.framework.util.StringUtil;
import knou.lms.log.userconn.dao.LogUserConnDAO;
import knou.lms.log.userconn.service.LogUserConnService;
import knou.lms.log.userconn.vo.LogUserConnStateVO;

@Service("logUserConnService")
public class LogUserConnServiceImpl implements LogUserConnService {
	
    /** dao */
    @Resource(name="logUserConnDAO")
    private LogUserConnDAO logUserConnDAO;
    

    /**
     * 사용자 접속 상태 저장
     * @param request
     * @param workLoc
     * @throws Exception
     */
    public void saveUserConnState(HttpServletRequest request) throws Exception {
        String uri   = request.getRequestURI();
        String workLoc = checkConnUri(uri);
        saveUserConnState(request, workLoc);
    }
    
    /**
     * 사용자접속이력갱신 - userCntnHstryUpdate
     * TODO: 리팩터링 필요, 일단은 SKIP, 405군데 사용. - jinkoon 260122
     * 
     * @param request
     * @param workLoc
     * @throws Exception
     */
    public void saveUserConnState(HttpServletRequest request, String workLoc) throws Exception {
    	String chkNo = (String)request.getSession().getAttribute("PREV_CONN_CHECK_NO");
        String chkLoc = request.getSession().getAttribute("PREV_CONN_CHECK_LOC") == null ? "" : (String)request.getSession().getAttribute("PREV_CONN_CHECK_LOC");
        long chkTime = request.getSession().getAttribute("PREV_CONN_CHECK_TIME") == null ? 0 : (long)request.getSession().getAttribute("PREV_CONN_CHECK_TIME");
        long curTime = (Calendar.getInstance()).getTimeInMillis();
        long chkTerm = 10000; //저장 최소 시간 간격(10초)
        boolean isChk = true;
        String chkLocVal = "";
        
        if (!SessionInfo.isVirtualLogin(request) && !"".equals(StringUtil.nvl(SessionInfo.getUserId(request)))) {
            if (workLoc != null) {
                LogUserConnStateVO vo = new LogUserConnStateVO();    
                vo.setUserId(SessionInfo.getUserId(request));
                vo.setConnGbn(StringUtil.nvl(SessionInfo.getClassUserType(request),"none"));
                vo.setCrsCreCd(StringUtil.nvl(SessionInfo.getCrsCreCd(request),"none"));
                vo.setDeviceTypeCd(CommonUtil.getClientOS(request));
                vo.setWorkLocCd(StringUtil.nvl(workLoc,"none"));
                vo.setRegIp(CommonUtil.getIpAddress(request));
                vo.setSessionId(request.getRequestedSessionId());
                
                if (CommConst.CONN_HOME.equals(vo.getWorkLocCd())) {
                    vo.setConnGbn("none");
                    vo.setCrsCreCd("none");
                }
                else if (CommConst.CONN_COR_HOME.equals(vo.getWorkLocCd()) && "none".equals(vo.getCrsCreCd())) {
                    isChk = false;
                }
                
                chkLocVal = vo.getCrsCreCd()+":"+vo.getWorkLocCd();
                
                // 위치가같고 60초이내이거나 저장최소시간보다 작으면 저장안함.
                if ((chkLoc.equals(chkLocVal) && (curTime-chkTime) < 60000) || (curTime-chkTime) < chkTerm) {
                    isChk = false;
                }
                
                /*
                if (isChk) {
                	if (chkNo != null && chkNo.equals(vo.getUserId())) {
                		logUserConnDAO.updateLogUserConnState(vo); // TODO: 사용자접속이력수정 - userCntnHstryModify
                	}
                	else {
	                	LogUserConnStateVO stateVO = logUserConnDAO.selectLogUserConnState(vo); // TODO: 사용자접속이력조회 - userCntnHstrySelect
	                	if (stateVO == null) {
	                		logUserConnDAO.insertLogUserConnState(vo); // TODO: 사용자접속이력등록 - userCntnHstryRegist
	                	}
	                	else {
	                		logUserConnDAO.updateLogUserConnState(vo); // TODO: 사용자접속이력수정 - userCntnHstryModify
	                	}
	                	
	                	request.getSession().setAttribute("PREV_CONN_CHECK_NO", vo.getUserId());
                	}
                    
                	request.getSession().setAttribute("PREV_CONN_CHECK_TIME", curTime);
                    request.getSession().setAttribute("PREV_CONN_CHECK_LOC", chkLocVal);
                }
                */
            }
        }
    }
    
    /**
     * 사용자 접속 상태 목록 조회
     * @param  LogUserConnStateVO
     * @return List<LogUserConnStateVO> 
     * @throws Exception
     */
    public List<LogUserConnStateVO> listLogUserConnState(LogUserConnStateVO vo) throws Exception {
        List<LogUserConnStateVO> connList = logUserConnDAO.listLogUserConnState(vo);
        
        for (LogUserConnStateVO stateVO : connList) {
            // 사진파일이 있으면 변환
            if (stateVO.getPhtFileByte() != null && stateVO.getPhtFileByte().length > 0) {
                stateVO.setPhtFile("data:image/png;base64," + new String(Base64.getEncoder().encode(stateVO.getPhtFileByte())));
            }
        }

        return connList;
    }
    
    /**
     * 사용자 접속 상태 최신 목록 조회
     * @param  LogUserConnStateVO
     * @return List<LogUserConnStateVO> 
     * @throws Exception
     */
    public List<LogUserConnStateVO> listTopLogUserConnState(LogUserConnStateVO vo) throws Exception {
        List<LogUserConnStateVO> connList = logUserConnDAO.listTopLogUserConnState(vo);
        
        for (LogUserConnStateVO stateVO : connList) {
            // 사진파일이 있으면 변환
            if (stateVO.getPhtFileByte() != null && stateVO.getPhtFileByte().length > 0) {
                stateVO.setPhtFile("data:image/png;base64," + new String(Base64.getEncoder().encode(stateVO.getPhtFileByte())));
            }
        }

        return connList;
    }
    
    
    
    // 사용자 접속상태 기록 URL 체크
    private String checkConnUri(String uri) throws Exception {
        for(int i=0; i<CommConst.CONN_CHECK_LIST.length; i++ ) {
            if (uri.contains(CommConst.CONN_CHECK_LIST[i][0])) {
                return CommConst.CONN_CHECK_LIST[i][1];
            }
        }
        System.out.println(">>>>>>>>>>>>>uri=" + uri + " 는 접속상태를 기록하지 않습니다.");
        return null;
    }

    /**
     * 과목 접속자 수 조회 
     * @param  LogUserConnStateVO
     * @return int
     * @throws Exception
     */
    @Override
    public int countLogUserConnState(LogUserConnStateVO vo) throws Exception {
        return logUserConnDAO.countLogUserConnState(vo);
    }
}

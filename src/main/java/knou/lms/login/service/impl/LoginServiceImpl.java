package knou.lms.login.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.lms.login.dao.LoginDAO;
import knou.lms.login.param.LoginParam;
import knou.lms.login.service.LoginService;
import knou.lms.login.vo.LoginVO;
import knou.lms.subject.service.SubjectService;
import knou.lms.user.service.UserService;
import knou.lms.user.vo.UserIdsDTO;
import knou.lms.user.vo.UserVO;

@Service("loginService")
public class LoginServiceImpl extends ServiceBase implements LoginService {
    
    @Resource(name="loginDAO")
    private LoginDAO loginDAO;
    
    @Autowired private UserService userService;
    @Autowired private SubjectService subjectService;
    
    @Override
    public List<LoginVO> selectOrgList() throws Exception {
        return loginDAO.selectOrgList();
    }
    
    /**
     * 전체 로그인 프로세스를 관리합니다.
     */
    public UserContext processLogin(LoginParam param) throws Exception {
        
        // 1. 기본 검증 (ID존재, 비번일치, 유효사용자)
        // 로직 내부에서 실패 시 사용자 정의 Exception을 던지면 컨트롤러가 더 깔끔해집니다.
        validateUser(param);

        // 2. 기본 사용자 정보 로드
        UserVO loginUser = userService.userSelect(param.getUserId());
        UserContext userCtx = new UserContext();
        userCtx.setLoginUser(loginUser);
        userCtx.setSelectedUser(loginUser);

        // 3. 연관 사용자(대표아이디 기준) 및 아이디 리스트 조회
        String rprsId = loginUser.getUserRprsId();
        List<UserVO> registeredUsersList = userService.registeredUsersSelect(rprsId);
        
        // 쿼리 한 방 방식 (UserIdsDTO)
        UserIdsDTO userIds = userService.userIdsSelect(rprsId);
        
        // 4. 아이디 보정 (값이 없을 경우 선택된 본인 아이디 추가)
        List<String> profIds = refineIds(userIds.getProfIds(), userCtx.getSelectedUser().getUserId());
        List<String> stdntIds = refineIds(userIds.getStdntIds(), userCtx.getSelectedUser().getUserId());        

        // 5. 기관 및 과목 정보 로드 (SubjectService 활용)
        List<EgovMap> userOrgIdsFromSubject = subjectService.subjectByUserOrgIdSelect(profIds, stdntIds);
        userCtx.setUserOrgIdsFromSubject(userOrgIdsFromSubject);

        // 6. 가공 데이터 세팅 (Map 변환 등)
        userCtx.setRegisteredUsers(convertToMap(registeredUsersList));

        return userCtx;
    }

    private List<String> refineIds(List<String> ids, String defaultId) {
        if (ids == null || ids.isEmpty()) {
            List<String> newList = new ArrayList<>();
            newList.add(defaultId);
            return newList;
        }
        return ids;
    }

    private Map<String, UserVO> convertToMap(List<UserVO> list) {
        Map<String, UserVO> map = new HashMap<>();
        if (list != null) {
            for (UserVO vo : list) {
                if (vo != null) map.put(vo.getUserId(), vo);
            }
        }
        return map;
    }
    
    private void validateUser(LoginParam param) {
        // 여기서 userService를 호출하여 체크하고 실패 시 예외 발생
        // if (!userService.existUserId(param)) throw new LoginFailedException();
    }
}

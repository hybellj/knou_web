package knou.lms.notification.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.notification.dao.NotificationDAO;
import knou.lms.notification.service.NotificationService;
import knou.lms.notification.vo.NotificationVO;

@Service("notificationService")
public class NotificationServiceImpl extends ServiceBase implements NotificationService{
	@Resource(name="notificationDAO")
	private NotificationDAO notificationDAO;

	@Override
	public ProcessResultVO<NotificationVO> listNotificationAll(NotificationVO vo) throws Exception {
		ProcessResultVO<NotificationVO> processResultVO = new ProcessResultVO<>();
		try {
            List<NotificationVO> resultList = notificationDAO.listNotification(vo);
            processResultVO.setReturnList(resultList);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        
        return processResultVO;
	}

	@Override
	public ProcessResultVO<NotificationVO> listPush(NotificationVO vo) throws Exception {
		ProcessResultVO<NotificationVO> processResultVO = new ProcessResultVO<>();
		try {
			vo.setNotiType("P");
            List<NotificationVO> resultList = notificationDAO.listNotification(vo);
            processResultVO.setReturnList(resultList);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        
        return processResultVO;
	}

	@Override
	public ProcessResultVO<NotificationVO> listSms(NotificationVO vo) throws Exception {
		ProcessResultVO<NotificationVO> processResultVO = new ProcessResultVO<>();
		try {
			vo.setNotiType("S");
            List<NotificationVO> resultList = notificationDAO.listNotification(vo);
            processResultVO.setReturnList(resultList);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        
        return processResultVO;
	}

	@Override
	public ProcessResultVO<NotificationVO> listMsg(NotificationVO vo) throws Exception {
		ProcessResultVO<NotificationVO> processResultVO = new ProcessResultVO<>();
		try {
			vo.setNotiType("M");
            List<NotificationVO> resultList = notificationDAO.listNotification(vo);
            processResultVO.setReturnList(resultList);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        
        return processResultVO;
	}

	@Override
	public ProcessResultVO<NotificationVO> listTalk(NotificationVO vo) throws Exception {
		ProcessResultVO<NotificationVO> processResultVO = new ProcessResultVO<>();
		try {
			vo.setNotiType("T");
            List<NotificationVO> resultList = notificationDAO.listNotification(vo);
            processResultVO.setReturnList(resultList);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        
        return processResultVO;
	}

}

package knou.lms.notification.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.notification.vo.NotificationVO;

@Mapper("notificationDAO")
public interface NotificationDAO {
	public List<NotificationVO> listNotification(NotificationVO vo) throws Exception;
}

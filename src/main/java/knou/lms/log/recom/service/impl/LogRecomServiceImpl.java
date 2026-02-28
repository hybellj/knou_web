package knou.lms.log.recom.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.log.recom.dao.LogRecomDAO;
import knou.lms.log.recom.service.LogRecomService;
import knou.lms.log.recom.vo.LogRecomVO;

@Service("logRecomService")
public class LogRecomServiceImpl extends ServiceBase implements LogRecomService {
    
    @Resource(name="logRecomDAO")
    private LogRecomDAO logRecomDAO ;
    
    @Override
    public void insert(LogRecomVO vo) throws Exception {
        logRecomDAO.insert(vo);
    }

    @Override
    public void delete(LogRecomVO vo) throws Exception {
        logRecomDAO.delete(vo);
    }

    @Override
    public int count(LogRecomVO vo) throws Exception {
        return logRecomDAO.count(vo);
    }

    @Override
    public int countRecomRgtrId(LogRecomVO vo) throws Exception {
        return logRecomDAO.countRecomRgtrId(vo);
    }

}
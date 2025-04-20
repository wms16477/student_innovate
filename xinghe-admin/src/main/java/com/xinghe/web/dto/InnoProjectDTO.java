package com.xinghe.web.dto;

import com.xinghe.web.domain.InnoProject;
import lombok.Data;

import java.util.Date;

@Data
public class InnoProjectDTO extends InnoProject {

    private Date startTime;

    private Date endTime;

}

package com.xinghe.web.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.core.page.TableDataInfo;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.web.domain.InnoProject;
import com.xinghe.web.domain.InnoProjectMember;
import com.xinghe.web.domain.Student;
import com.xinghe.web.service.InnoProjectMemberService;
import com.xinghe.web.service.InnoProjectService;
import com.xinghe.web.enums.StatusEnum;
import com.xinghe.web.enums.ProjectType;
import com.xinghe.web.service.StudentService;
import com.xinghe.web.service.TeacherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 大创项目Controller
 */
@RestController
@RequestMapping("/web/innoProject")
public class InnoProjectController extends BaseController {

    @Autowired
    private InnoProjectService innoProjectService;

    @Autowired
    private TeacherService teacherService;

    @Autowired
    private StudentService studentService;

    @Autowired
    private InnoProjectMemberService innoProjectMemberService;

    /**
     * 查询项目类型列表
     */
    @GetMapping("/projectType/list")
    public AjaxResult listProjectType() {
        List<String> list = Arrays.stream(ProjectType.values())
                .map(ProjectType::getName)
                .collect(Collectors.toList());
        return success(list);
    }

    /**
     * 查询大创项目列表
     */
    @GetMapping("/list")
    public TableDataInfo list(InnoProject innoProject, Date startTime, Date endTime) {
        startPage();
        LambdaQueryWrapper<InnoProject> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.like(StringUtils.isNotEmpty(innoProject.getProjectName()), InnoProject::getProjectName, innoProject.getProjectName())
                .ge(startTime != null, InnoProject::getCreateTime, startTime)
                .le(endTime != null, InnoProject::getCreateTime, endTime)
                .orderByDesc(InnoProject::getCreateTime);
        return getDataTable(innoProjectService.list(queryWrapper));
    }

    /**
     * 获取大创项目详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(innoProjectService.getById(id));
    }

    /**
     * 新增大创项目
     */
    @PostMapping
    public AjaxResult add(@RequestBody InnoProject innoProject, @RequestParam(value = "submit", required = false, defaultValue = "false") boolean submit) {
        if (submit) {
            innoProject.setStatus(StatusEnum.WAIT_APPROVE.name);
        } else {
            innoProject.setStatus(StatusEnum.DRAFT.name);
        }
        //获取导师姓名
        innoProject.setTeacherName(teacherService.getById(innoProject.getTeacherId()).getTeacherName());
        innoProjectService.save(innoProject);
        //成员列表
        List<Student> list = studentService.list();
        Map<String, String> studentMap = list.stream().collect(Collectors.toMap(Student::getStuNo, Student::getStuName));
        if (CollectionUtils.isEmpty(innoProject.getMemberList())) {
            innoProject.setMemberList(new ArrayList<>());
        }
//        InnoProjectMember self = new InnoProjectMember();
//        self.setProjectId(innoProject.getId());
//        String username = SecurityUtils.getLoginUser().getUsername();
//        String nickName = SecurityUtils.getLoginUser().getUser().getNickName();
//        self.setMemberUserCode(username);
//        self.setMemberUserName(nickName);
//        innoProject.getMemberList().add(self);
        innoProject.getMemberList().forEach(item -> {
            item.setProjectId(innoProject.getId());
            item.setMemberUserName(studentMap.get(item.getMemberUserCode()));
        });
        innoProjectMemberService.saveBatch(innoProject.getMemberList());
        return success();
    }

    /**
     * 修改大创项目
     */
    @PutMapping
    public AjaxResult edit(@RequestBody InnoProject innoProject, @RequestParam(value = "submit", required = false, defaultValue = "false") boolean submit) {
        InnoProject project = innoProjectService.getById(innoProject.getId());
        if (project == null) {
            return error("项目不存在");
        }
        if (submit) {
            innoProject.setStatus(StatusEnum.WAIT_APPROVE.name());
        } else {
            innoProject.setStatus(StatusEnum.DRAFT.name());
        }
        //获取导师姓名
        innoProject.setTeacherName(teacherService.getById(innoProject.getTeacherId()).getTeacherName());
        innoProjectService.save(innoProject);
        innoProjectService.updateById(innoProject);
        //成员列表
        List<Student> list = studentService.list();
        Map<String, String> studentMap = list.stream().collect(Collectors.toMap(Student::getStuNo, Student::getStuName));
        if (CollectionUtils.isEmpty(innoProject.getMemberList())) {
            innoProject.setMemberList(new ArrayList<>());
        }
//        InnoProjectMember self = new InnoProjectMember();
//        self.setProjectId(innoProject.getId());
//        String username = SecurityUtils.getLoginUser().getUsername();
//        String nickName = SecurityUtils.getLoginUser().getUser().getNickName();
//        self.setMemberUserCode(username);
//        self.setMemberUserName(nickName);
//        innoProject.getMemberList().add(self);
        innoProject.getMemberList().forEach(item -> {
            item.setProjectId(innoProject.getId());
            item.setMemberUserName(studentMap.get(item.getMemberUserCode()));
        });
        innoProjectMemberService.saveBatch(innoProject.getMemberList());
        return success();
    }

    /**
     * 删除大创项目
     */
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable Long id) {
        InnoProject project = innoProjectService.getById(id);
        if (project == null) {
            return error("项目不存在");
        }
        if (!StatusEnum.DRAFT.name().equals(project.getStatus()) && !StatusEnum.APPROVE_FAIL.name().equals(project.getStatus())) {
            return error("只有草稿和审批不通过状态的项目可以删除");
        }
        return toAjax(innoProjectService.removeById(id));
    }

    /**
     * 导师审批
     */
    @PostMapping("/approve/{agree}")
    public AjaxResult approve(@PathVariable("agree") boolean agree, @RequestBody InnoProject dto) {
        if (agree) {
            dto.setStatus(StatusEnum.APPROVED.name);
        } else {
            dto.setStatus(StatusEnum.APPROVE_FAIL.name);
        }
        innoProjectService.updateById(dto);
        return success();
    }


}

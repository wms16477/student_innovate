package com.xinghe.web.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.core.page.TableDataInfo;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.domain.SysUserRole;
import com.xinghe.system.mapper.SysUserMapper;
import com.xinghe.system.mapper.SysUserRoleMapper;
import com.xinghe.system.service.impl.SysUserServiceImpl;
import com.xinghe.web.constants.Constants;
import com.xinghe.web.domain.*;
import com.xinghe.web.dto.InnoProjectDTO;
import com.xinghe.web.mapper.InnoProjectMapper;
import com.xinghe.web.service.*;
import com.xinghe.web.enums.StatusEnum;
import com.xinghe.web.enums.ProjectType;
import com.xinghe.web.enums.SchoolApproveStatusEnum;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.math.RoundingMode;
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

    @Autowired
    private InnoProjectMapper innoProjectMapper;

    @Autowired
    private SysUserRoleMapper sysUserRoleMapper;

    @Autowired
    private ProfessionalService professionalService;

    @Autowired
    private SchoolService schoolService;

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
    public TableDataInfo list(InnoProjectDTO dto) {
        startPage();
        //获取当前登录用户
        Long userId = getUserId();
        //获取当前登录账号
        String username = SecurityUtils.getLoginUser().getUsername();
        Long teacherId = null;
        Long schoolId = null;
        //获取当前角色
        List<SysUserRole> roleList = sysUserRoleMapper.selectUserRoleByUserId(userId);
        Integer userType = null;
        String projectType = null;
        for (SysUserRole sysUserRole : roleList) {
            if (Objects.equals(sysUserRole.getRoleId(), Constants.STU_ROLE_ID)) {
                //学生
                userType = 1;
                break;
            } else if (Objects.equals(sysUserRole.getRoleId(), Constants.TEA_ROLE_ID)) {
                //教师
                userType = 2;
                Teacher one = teacherService.lambdaQuery().eq(Teacher::getAccount, username).one();
                teacherId = one.getId();
                break;
            } else if (Objects.equals(sysUserRole.getRoleId(), Constants.PRO_ROLE_ID)) {
                //专家
                userType = 3;
                Professional professional = professionalService.lambdaQuery().eq(Professional::getAccount, username)
                        .one();
                projectType = professional.getArea();
                break;
            } else if (Objects.equals(sysUserRole.getRoleId(), Constants.SCHOOL_ROLE_ID)) {
                //学校
                userType = 4;
                schoolId = schoolService.lambdaQuery().eq(School::getSchoolCode, username).one().getId();
            }
        }
        //按钮 查看
        List<InnoProject> list = innoProjectMapper.getTableList(dto, userId, username, userType, teacherId, schoolId, projectType);
        for (InnoProject innoProject : list) {
            if (userType != null) {
                if (userType == 1) {
                    //学生
                    if (StatusEnum.DRAFT.name.equals(innoProject.getStatus()) || StatusEnum.APPROVE_FAIL.name.equals(innoProject.getStatus())) {
                        innoProject.getButtonList().add("修改");
                        innoProject.getButtonList().add("删除");
                        innoProject.getButtonList().add("提交");
                    } else if (StatusEnum.APPROVED.name.equals(innoProject.getStatus())) {
                        innoProject.getButtonList().add("中期检查");
                    } else if (StatusEnum.WAIT_FINAL_CHECK.name.equals(innoProject.getStatus())) {
                        innoProject.getButtonList().add("结项");
                    }
                } else if (userType == 2) {
                    //导师
                    if (StatusEnum.WAIT_APPROVE.name.equals(innoProject.getStatus())) {
                        innoProject.getButtonList().add("通过");
                        innoProject.getButtonList().add("拒绝");
                    }
                } else if (userType == 3) {
                    //专家
                    if (StatusEnum.APPROVED.name.equals(innoProject.getStatus())) {
                        innoProject.getButtonList().add("中期评分");
                    } else if (StatusEnum.WAIT_FINAL_CHECK.name.equals(innoProject.getStatus())) {
                        innoProject.getButtonList().add("结项评分");
                    }
                }
            }

        }
        return getDataTable(list);
    }

    /**
     * 获取大创项目详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        InnoProject project = innoProjectService.getById(id);
        //查询项目成员
        List<InnoProjectMember> memberList = innoProjectMemberService.lambdaQuery().eq(InnoProjectMember::getProjectId, id).list();
        project.setMemberList(memberList);
        return success(project);
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
        innoProjectMemberService.lambdaUpdate().eq(InnoProjectMember::getProjectId, innoProject.getId()).remove();
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
            innoProject.setStatus(StatusEnum.WAIT_APPROVE.getName());
        } else {
            innoProject.setStatus(StatusEnum.DRAFT.getName());
        }
        //获取导师姓名
        innoProject.setTeacherName(teacherService.getById(innoProject.getTeacherId()).getTeacherName());
        innoProjectService.updateById(innoProject);
        //成员列表
        innoProjectMemberService.lambdaUpdate().eq(InnoProjectMember::getProjectId, innoProject.getId()).remove();
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
        if (!StatusEnum.DRAFT.getName().equals(project.getStatus()) && !StatusEnum.APPROVE_FAIL.getName().equals(project.getStatus())) {
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
            // 导师审批通过后，设置学校审批状态为待审批
            dto.setSchoolApproveStatus(SchoolApproveStatusEnum.WAIT_APPROVE.name);
        } else {
            dto.setStatus(StatusEnum.APPROVE_FAIL.name);
        }
        innoProjectService.updateById(dto);
        return success();
    }

    /**
     * 学校审批
     */
    @PostMapping("/school-approve/{agree}")
    public AjaxResult schoolApprove(@PathVariable("agree") boolean agree, @RequestBody InnoProject dto) {
        if (agree) {
            dto.setSchoolApproveStatus(SchoolApproveStatusEnum.APPROVE_SUCCESS.name);
        } else {
            dto.setSchoolApproveStatus(SchoolApproveStatusEnum.APPROVE_FAIL.name);
            // 学校审批不通过时，项目状态变为审批不通过
            dto.setStatus(StatusEnum.APPROVE_FAIL.name);
        }
        innoProjectService.updateById(dto);
        return success();
    }

    /**
     * 提交中期检查
     */
    @PostMapping("/midCheck")
    public AjaxResult midCheck(@RequestBody InnoProject innoProject) {
        if (innoProject.getId() == null) {
            return error("项目ID不能为空");
        }

        InnoProject project = innoProjectService.getById(innoProject.getId());
        if (project == null) {
            return error("项目不存在");
        }

        // 只更新中期检查相关字段
        InnoProject updateProject = new InnoProject();
        updateProject.setId(innoProject.getId());
        updateProject.setMidCheckFileName(innoProject.getMidCheckFileName());
        updateProject.setMidCheckFileUrl(innoProject.getMidCheckFileUrl());
        updateProject.setMidCheckDesc(innoProject.getMidCheckDesc());

        innoProjectService.updateById(updateProject);
        return success();
    }

    /**
     * 提交中期检查评分
     */
    @PostMapping("/midCheckScore")
    public AjaxResult midCheckScore(@RequestBody InnoProject innoProject) {
        if (innoProject.getId() == null) {
            return error("项目ID不能为空");
        }

        InnoProject project = innoProjectService.getById(innoProject.getId());
        if (project == null) {
            return error("项目不存在");
        }

        // 检查分数有效性
        if (innoProject.getMidScoreXtjz() == null || innoProject.getMidScoreXtjz() < 0 || innoProject.getMidScoreXtjz() > 100) {
            return error("选题价值分必须在0-100之间");
        }
        if (innoProject.getMidScoreYjjc() == null || innoProject.getMidScoreYjjc() < 0 || innoProject.getMidScoreYjjc() > 100) {
            return error("研究基础分必须在0-100之间");
        }
        if (innoProject.getMidScoreNrsj() == null || innoProject.getMidScoreNrsj() < 0 || innoProject.getMidScoreNrsj() > 100) {
            return error("内容设计分必须在0-100之间");
        }
        if (innoProject.getMidScoreYjff() == null || innoProject.getMidScoreYjff() < 0 || innoProject.getMidScoreYjff() > 100) {
            return error("研究方法分必须在0-100之间");
        }

        // 只更新中期检查评分相关字段
        InnoProject updateProject = new InnoProject();
        updateProject.setId(innoProject.getId());
        updateProject.setStatus(StatusEnum.WAIT_FINAL_CHECK.getName());
        updateProject.setMidScoreXtjz(innoProject.getMidScoreXtjz());
        updateProject.setMidScoreYjjc(innoProject.getMidScoreYjjc());
        updateProject.setMidScoreNrsj(innoProject.getMidScoreNrsj());
        updateProject.setMidScoreYjff(innoProject.getMidScoreYjff());

        innoProjectService.updateById(updateProject);
        return success();
    }

    /**
     * 计算中期检查总分
     */
    @GetMapping("/calculateMidScore")
    public AjaxResult calculateMidScore(Integer xtjz, Integer yjjc, Integer nrsj, Integer yjff) {
        if (xtjz == null || yjjc == null || nrsj == null || yjff == null) {
            return error("所有分数都必须提供");
        }

        // 计算总分（加权平均）
        // 选题价值分 权重0.2
        // 研究基础分 权重0.2
        // 内容设计分 权重0.5
        // 研究方法分 权重0.1
        double totalScore = xtjz * 0.2 + yjjc * 0.2 + nrsj * 0.5 + yjff * 0.1;

        // 保留两位小数
        BigDecimal bd = new BigDecimal(totalScore);
        bd = bd.setScale(2, RoundingMode.HALF_UP);

        return success(bd.doubleValue());
    }

    /**
     * 提交结项
     */
    @PostMapping("/endProject")
    public AjaxResult endProject(@RequestBody InnoProject innoProject) {
        if (innoProject.getId() == null) {
            return error("项目ID不能为空");
        }

        InnoProject project = innoProjectService.getById(innoProject.getId());
        if (project == null) {
            return error("项目不存在");
        }

        // 只更新结项相关字段
        InnoProject updateProject = new InnoProject();
        updateProject.setId(innoProject.getId());
        updateProject.setEndFileName(innoProject.getEndFileName());
        updateProject.setEndFileUrl(innoProject.getEndFileUrl());
        updateProject.setEndDesc(innoProject.getEndDesc());

        innoProjectService.updateById(updateProject);
        return success();
    }

    /**
     * 提交结项评分
     */
    @PostMapping("/endProjectScore")
    public AjaxResult endProjectScore(@RequestBody InnoProject innoProject) {
        if (innoProject.getId() == null) {
            return error("项目ID不能为空");
        }

        InnoProject project = innoProjectService.getById(innoProject.getId());
        if (project == null) {
            return error("项目不存在");
        }

        // 检查分数有效性
        if (innoProject.getEndScoreXtjz() == null || innoProject.getEndScoreXtjz() < 0 || innoProject.getEndScoreXtjz() > 100) {
            return error("选题价值分必须在0-100之间");
        }
        if (innoProject.getEndScoreYjjc() == null || innoProject.getEndScoreYjjc() < 0 || innoProject.getEndScoreYjjc() > 100) {
            return error("研究基础分必须在0-100之间");
        }
        if (innoProject.getEndScoreNrsj() == null || innoProject.getEndScoreNrsj() < 0 || innoProject.getEndScoreNrsj() > 100) {
            return error("内容设计分必须在0-100之间");
        }
        if (innoProject.getEndScoreYjff() == null || innoProject.getEndScoreYjff() < 0 || innoProject.getEndScoreYjff() > 100) {
            return error("研究方法分必须在0-100之间");
        }

        // 只更新结项评分相关字段
        InnoProject updateProject = new InnoProject();
        updateProject.setStatus(StatusEnum.FINAL_CHECKED.getName());
        updateProject.setId(innoProject.getId());
        updateProject.setEndScoreXtjz(innoProject.getEndScoreXtjz());
        updateProject.setEndScoreYjjc(innoProject.getEndScoreYjjc());
        updateProject.setEndScoreNrsj(innoProject.getEndScoreNrsj());
        updateProject.setEndScoreYjff(innoProject.getEndScoreYjff());

        innoProjectService.updateById(updateProject);
        return success();
    }

    /**
     * 计算结项总分
     */
    @GetMapping("/calculateEndScore")
    public AjaxResult calculateEndScore(Integer xtjz, Integer yjjc, Integer nrsj, Integer yjff) {
        if (xtjz == null || yjjc == null || nrsj == null || yjff == null) {
            return error("所有分数都必须提供");
        }

        // 计算总分（加权平均）
        // 选题价值分 权重0.2
        // 研究基础分 权重0.2
        // 内容设计分 权重0.5
        // 研究方法分 权重0.1
        double totalScore = xtjz * 0.2 + yjjc * 0.2 + nrsj * 0.5 + yjff * 0.1;

        // 保留两位小数
        BigDecimal bd = new BigDecimal(totalScore);
        bd = bd.setScale(2, RoundingMode.HALF_UP);

        return success(bd.doubleValue());
    }
}

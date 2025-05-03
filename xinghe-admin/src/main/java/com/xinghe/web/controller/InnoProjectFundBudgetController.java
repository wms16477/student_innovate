package com.xinghe.web.controller;

import com.xinghe.common.annotation.Log;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.core.page.TableDataInfo;
import com.xinghe.common.enums.BusinessType;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.system.domain.SysUserRole;
import com.xinghe.system.mapper.SysUserRoleMapper;
import com.xinghe.web.constants.Constants;
import com.xinghe.web.domain.InnoProjectFundBudget;
import com.xinghe.web.domain.School;
import com.xinghe.web.dto.InnoProjectFundBudgetDTO;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundBudgetMapper;
import com.xinghe.web.service.InnoProjectFundBudgetService;
import com.xinghe.web.service.SchoolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/**
 * 经费预算管理Controller
 * 
 * @author xinghe
 */
@RestController
@RequestMapping("/web/fundBudget")
public class InnoProjectFundBudgetController extends BaseController {
    
    @Autowired
    private InnoProjectFundBudgetService budgetService;
    
    @Autowired
    private InnoProjectFundBudgetMapper budgetMapper;
    
    @Autowired
    private SchoolService schoolService;
    
    @Autowired
    private SysUserRoleMapper sysUserRoleMapper;
    
    /**
     * 查询经费预算列表
     */
    @GetMapping("/list")
    public TableDataInfo list(InnoProjectFundBudgetDTO dto) {
        startPage();
        
        // 获取当前登录用户
        Long userId = getUserId();
        String username = SecurityUtils.getUsername();
        Long schoolId = null;
        boolean isAdmin = false;
        boolean isSchool = false;
        
        // 获取当前角色
        List<SysUserRole> roleList = sysUserRoleMapper.selectUserRoleByUserId(userId);
        for (SysUserRole sysUserRole : roleList) {
            if (Objects.equals(sysUserRole.getRoleId(), Constants.ADMIN_ROLE_ID)) {
                // 管理员
                isAdmin = true;
            } else if (Objects.equals(sysUserRole.getRoleId(), Constants.SCHOOL_ROLE_ID)) {
                // 学校
                isSchool = true;
                School school = schoolService.lambdaQuery().eq(School::getSchoolCode, username).one();
                if (school != null) {
                    schoolId = school.getId();
                    // 设置学校ID，用于过滤数据
                    dto.setSchoolId(schoolId);
                }
            }
        }
        
        List<InnoProjectFundBudget> list = budgetMapper.getTableList(dto);
        
        // 设置可操作按钮
        for (InnoProjectFundBudget budget : list) {
            if (budget.getButtonList() == null) {
                budget.setButtonList(new ArrayList<>());
            }
            
            // 所有用户都可以查看
            budget.getButtonList().add("查看");
            
            // 根据状态和角色设置按钮
            if (FundStatusEnum.DRAFT.name().equals(budget.getStatus()) || 
                FundStatusEnum.REJECTED.name().equals(budget.getStatus())) {
                budget.getButtonList().add("修改");
                budget.getButtonList().add("删除");
                budget.getButtonList().add("提交");
            }
            
            if (FundStatusEnum.SUBMITTED.name().equals(budget.getStatus())) {
                if (isAdmin) {
                    budget.getButtonList().add("批准");
                    budget.getButtonList().add("拒绝");
                }
                
                if (isSchool) {
                    budget.getButtonList().add("学校批准");
                    budget.getButtonList().add("学校拒绝");
                }
            }
        }
        
        return getDataTable(list);
    }
    
    /**
     * 获取经费预算详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(budgetService.getById(id));
    }
    
    /**
     * 新增经费预算
     */
    @Log(title = "经费预算管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody InnoProjectFundBudget budget, 
                         @RequestParam(value = "submit", required = false, defaultValue = "false") boolean submit) {
        if (budget.getProjectId() == null) {
            return error("项目ID不能为空");
        }
        
        // 确保初始剩余金额等于预算金额
        budget.setRemainingAmount(budget.getBudgetAmount());
        
        // 设置状态
        budget.setStatus(submit ? FundStatusEnum.SUBMITTED.name() : FundStatusEnum.DRAFT.name());
        
        return toAjax(budgetService.save(budget));
    }
    
    /**
     * 修改经费预算
     */
    @Log(title = "经费预算管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody InnoProjectFundBudget budget,
                          @RequestParam(value = "submit", required = false, defaultValue = "false") boolean submit) {
        if (budget.getId() == null) {
            return error("预算ID不能为空");
        }
        
        // 取得原数据
        InnoProjectFundBudget db = budgetService.getById(budget.getId());
        if (db == null) {
            return error("预算不存在");
        }
        
        // 检查状态是否允许修改
        if (!FundStatusEnum.DRAFT.name().equals(db.getStatus()) && 
            !FundStatusEnum.REJECTED.name().equals(db.getStatus())) {
            return error("只有草稿或已拒绝状态才能修改");
        }
        
        // 如果修改了预算金额，则相应调整剩余金额
        if (budget.getBudgetAmount() != null && 
            budget.getBudgetAmount().compareTo(db.getBudgetAmount()) != 0) {
            BigDecimal diff = budget.getBudgetAmount().subtract(db.getBudgetAmount());
            budget.setRemainingAmount(db.getRemainingAmount().add(diff));
        }
        
        // 如果提交，更新状态
        if (submit) {
            budget.setStatus(FundStatusEnum.SUBMITTED.name());
        }
        
        return toAjax(budgetService.updateById(budget));
    }
    
    /**
     * 删除经费预算
     */
    @Log(title = "经费预算管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(budgetService.removeBatchByIds(Arrays.asList(ids)));
    }
    
    /**
     * 提交经费预算
     */
    @Log(title = "经费预算管理", businessType = BusinessType.UPDATE)
    @PutMapping("/submit/{id}")
    public AjaxResult submit(@PathVariable("id") Long id) {
        return toAjax(budgetService.submitBudget(id));
    }
    
    /**
     * 审批经费预算
     */
    @Log(title = "经费预算管理", businessType = BusinessType.UPDATE)
    @PostMapping("/approve/{isApprove}")
    public AjaxResult approve(@PathVariable("isApprove") boolean isApprove, @RequestBody InnoProjectFundBudget budget) {
        if (budget.getId() == null) {
            return error("预算ID不能为空");
        }
        if (StringUtils.isEmpty(budget.getApproveDesc())) {
            return error("审批说明不能为空");
        }
        
        return toAjax(budgetService.approveBudget(isApprove, budget));
    }
    
    /**
     * 学校审批经费预算
     */
    @Log(title = "经费预算管理-学校审批", businessType = BusinessType.UPDATE)
    @PostMapping("/school-approve/{isApprove}")
    public AjaxResult schoolApprove(@PathVariable("isApprove") boolean isApprove, @RequestBody InnoProjectFundBudget budget) {
        if (budget.getId() == null) {
            return error("预算ID不能为空");
        }
        if (StringUtils.isEmpty(budget.getSchoolApproveDesc())) {
            return error("审批说明不能为空");
        }
        
        // 获取当前登录账号
        String username = SecurityUtils.getUsername();
        
        // 获取学校ID
        School school = schoolService.lambdaQuery().eq(School::getSchoolCode, username).one();
        if (school == null) {
            return error("当前用户不是学校管理员");
        }
        
        return toAjax(budgetService.schoolApproveBudget(isApprove, budget, school.getId()));
    }
} 
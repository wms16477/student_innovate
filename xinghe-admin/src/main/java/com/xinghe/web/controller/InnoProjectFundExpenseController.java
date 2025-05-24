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
import com.xinghe.web.domain.InnoProjectFundExpense;
import com.xinghe.web.domain.InnoProjectFundBudget;
import com.xinghe.web.domain.School;
import com.xinghe.web.dto.InnoProjectFundExpenseDTO;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundExpenseMapper;
import com.xinghe.web.service.InnoProjectFundExpenseService;
import com.xinghe.web.service.InnoProjectFundBudgetService;
import com.xinghe.web.service.SchoolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/**
 * 经费支出管理Controller
 * 
 * @author xinghe
 */
@RestController
@RequestMapping("/web/fundExpense")
public class InnoProjectFundExpenseController extends BaseController {
    
    @Autowired
    private InnoProjectFundExpenseService expenseService;
    
    @Autowired
    private InnoProjectFundExpenseMapper expenseMapper;
    
    @Autowired
    private SchoolService schoolService;
    
    @Autowired
    private SysUserRoleMapper sysUserRoleMapper;
    
    @Autowired
    private InnoProjectFundBudgetService budgetService;
    
    /**
     * 查询经费支出列表
     */
    @GetMapping("/list")
    public TableDataInfo list(InnoProjectFundExpenseDTO dto) {
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
        
        List<InnoProjectFundExpense> list = expenseMapper.getTableList(dto);
        
        // 设置可操作按钮
        for (InnoProjectFundExpense expense : list) {
            if (expense.getButtonList() == null) {
                expense.setButtonList(new ArrayList<>());
            }
            
            // 所有用户都可以查看
            expense.getButtonList().add("查看");
            
            // 根据状态和角色设置按钮
            if (FundStatusEnum.DRAFT.name().equals(expense.getStatus()) || 
                FundStatusEnum.REJECTED.name().equals(expense.getStatus())) {
                expense.getButtonList().add("修改");
                expense.getButtonList().add("删除");
                expense.getButtonList().add("提交");
            }
            
            if (FundStatusEnum.SUBMITTED.name().equals(expense.getStatus())) {
                if (isAdmin) {
                    expense.getButtonList().add("批准");
                    expense.getButtonList().add("拒绝");
                }
                
                if (isSchool) {
                    expense.getButtonList().add("学校批准");
                    expense.getButtonList().add("学校拒绝");
                }
            }
            
            if (FundStatusEnum.APPROVED.name().equals(expense.getStatus())) {
                if (isAdmin) {
                    expense.getButtonList().add("标记已支付");
                }
            }
        }
        
        return getDataTable(list);
    }
    
    /**
     * 获取经费支出详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(expenseService.getById(id));
    }
    
    /**
     * 新增经费支出
     */
    @Log(title = "经费支出管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody InnoProjectFundExpense expense, 
                          @RequestParam(value = "submit", required = false, defaultValue = "false") boolean submit) {
        if (expense.getProjectId() == null) {
            return error("项目ID不能为空");
        }
        
        // 如果选择了预算，检查预算剩余金额是否足够
        if (expense.getBudgetId() != null) {
            InnoProjectFundBudget budget = budgetService.getById(expense.getBudgetId());
            if (budget == null) {
                return error("预算不存在");
            }
            
            // 检查预算是否已批准
            if (!FundStatusEnum.APPROVED.name().equals(budget.getStatus())) {
                return error("只能关联已批准的预算");
            }
            
            // 检查预算剩余金额是否足够
            if (budget.getRemainingAmount().compareTo(expense.getExpenseAmount()) < 0) {
                return error("预算剩余金额不足，剩余" + budget.getRemainingAmount() + "元，支出" + expense.getExpenseAmount() + "元");
            }
        }
        
        // 设置状态
        expense.setStatus(submit ? FundStatusEnum.SUBMITTED.name() : FundStatusEnum.DRAFT.name());
        
        return toAjax(expenseService.save(expense));
    }
    
    /**
     * 修改经费支出
     */
    @Log(title = "经费支出管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody InnoProjectFundExpense expense,
                           @RequestParam(value = "submit", required = false, defaultValue = "false") boolean submit) {
        if (expense.getId() == null) {
            return error("支出ID不能为空");
        }
        
        // 取得原数据
        InnoProjectFundExpense db = expenseService.getById(expense.getId());
        if (db == null) {
            return error("支出不存在");
        }
        
        // 检查状态是否允许修改
        if (!FundStatusEnum.DRAFT.name().equals(db.getStatus()) && 
            !FundStatusEnum.REJECTED.name().equals(db.getStatus())) {
            return error("只有草稿或已拒绝状态才能修改");
        }
        
        // 如果更改了预算或金额，检查预算剩余金额是否足够
        if (expense.getBudgetId() != null && 
            (db.getBudgetId() == null || !db.getBudgetId().equals(expense.getBudgetId()) ||
             expense.getExpenseAmount().compareTo(db.getExpenseAmount()) != 0)) {
            
            InnoProjectFundBudget budget = budgetService.getById(expense.getBudgetId());
            if (budget == null) {
                return error("预算不存在");
            }
            
            // 检查预算是否已批准
            if (!FundStatusEnum.APPROVED.name().equals(budget.getStatus())) {
                return error("只能关联已批准的预算");
            }
            
            // 检查预算剩余金额是否足够
            if (budget.getRemainingAmount().compareTo(expense.getExpenseAmount()) < 0) {
                return error("预算剩余金额不足，剩余" + budget.getRemainingAmount() + "元，支出" + expense.getExpenseAmount() + "元");
            }
        }
        
        // 如果提交，更新状态
        if (submit) {
            expense.setStatus(FundStatusEnum.SUBMITTED.name());
        }
        
        return toAjax(expenseService.updateById(expense));
    }
    
    /**
     * 删除经费支出
     */
    @Log(title = "经费支出管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(expenseService.removeBatchByIds(Arrays.asList(ids)));
    }
    
    /**
     * 提交经费支出
     */
    @Log(title = "经费支出管理", businessType = BusinessType.UPDATE)
    @PutMapping("/submit/{id}")
    public AjaxResult submit(@PathVariable("id") Long id) {
        return toAjax(expenseService.submitExpense(id));
    }
    
    /**
     * 审批经费支出
     */
    @Log(title = "经费支出管理", businessType = BusinessType.UPDATE)
    @PostMapping("/approve/{isApprove}")
    public AjaxResult approve(@PathVariable("isApprove") boolean isApprove, @RequestBody InnoProjectFundExpense expense) {
        if (expense.getId() == null) {
            return error("支出ID不能为空");
        }
        if (StringUtils.isEmpty(expense.getApproveDesc())) {
            return error("审批说明不能为空");
        }
        
        return toAjax(expenseService.approveExpense(isApprove, expense));
    }
    
    /**
     * 学校审批经费支出
     */
    @Log(title = "经费支出管理-学校审批", businessType = BusinessType.UPDATE)
    @PostMapping("/school-approve/{isApprove}")
    public AjaxResult schoolApprove(@PathVariable("isApprove") boolean isApprove, @RequestBody InnoProjectFundExpense expense) {
        if (expense.getId() == null) {
            return error("支出ID不能为空");
        }
        if (StringUtils.isEmpty(expense.getSchoolApproveDesc())) {
            return error("审批说明不能为空");
        }
        
        // 获取当前登录账号
        String username = SecurityUtils.getUsername();
        
        // 获取学校ID
        School school = schoolService.lambdaQuery().eq(School::getSchoolCode, username).one();
        if (school == null) {
            return error("当前用户不是学校管理员");
        }
        
        return toAjax(expenseService.schoolApproveExpense(isApprove, expense, school.getId()));
    }
} 
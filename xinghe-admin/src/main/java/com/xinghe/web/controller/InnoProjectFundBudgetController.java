package com.xinghe.web.controller;

import com.xinghe.common.annotation.Log;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.core.page.TableDataInfo;
import com.xinghe.common.enums.BusinessType;
import com.xinghe.common.utils.SecurityUtils;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.web.domain.InnoProjectFundBudget;
import com.xinghe.web.domain.School;
import com.xinghe.web.dto.InnoProjectFundBudgetDTO;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundBudgetMapper;
import com.xinghe.web.service.InnoProjectFundBudgetService;
import com.xinghe.web.service.SchoolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

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
    
    /**
     * 查询经费预算列表
     */
    @GetMapping("/list")
    public TableDataInfo list(InnoProjectFundBudgetDTO dto) {
        startPage();
        List<InnoProjectFundBudget> list = budgetMapper.getTableList(dto);
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
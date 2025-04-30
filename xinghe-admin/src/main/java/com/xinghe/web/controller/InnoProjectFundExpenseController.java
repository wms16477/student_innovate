package com.xinghe.web.controller;

import com.xinghe.common.annotation.Log;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.core.page.TableDataInfo;
import com.xinghe.common.enums.BusinessType;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.web.domain.InnoProjectFundExpense;
import com.xinghe.web.dto.InnoProjectFundExpenseDTO;
import com.xinghe.web.enums.FundStatusEnum;
import com.xinghe.web.mapper.InnoProjectFundExpenseMapper;
import com.xinghe.web.service.InnoProjectFundExpenseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

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
    
    /**
     * 查询经费支出列表
     */
    @GetMapping("/list")
    public TableDataInfo list(InnoProjectFundExpenseDTO dto) {
        startPage();
        List<InnoProjectFundExpense> list = expenseMapper.getTableList(dto);
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
     * 标记为已支付
     */
    @Log(title = "经费支出管理", businessType = BusinessType.UPDATE)
    @PutMapping("/markAsPaid/{id}")
    public AjaxResult markAsPaid(@PathVariable("id") Long id) {
        return toAjax(expenseService.markAsPaid(id));
    }
} 
package com.xinghe.web.controller;

import com.xinghe.common.annotation.Log;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.core.page.TableDataInfo;
import com.xinghe.common.enums.BusinessType;
import com.xinghe.web.domain.InnoProjectFundExpense;
import com.xinghe.web.domain.InnoProjectFundPayment;
import com.xinghe.web.dto.InnoProjectFundPaymentDTO;
import com.xinghe.web.mapper.InnoProjectFundPaymentMapper;
import com.xinghe.web.service.InnoProjectFundExpenseService;
import com.xinghe.web.service.InnoProjectFundPaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

/**
 * 经费支付记录管理Controller
 * 
 * @author xinghe
 */
@RestController
@RequestMapping("/web/fundPayment")
public class InnoProjectFundPaymentController extends BaseController {
    
    @Autowired
    private InnoProjectFundPaymentService paymentService;
    
    @Autowired
    private InnoProjectFundExpenseService expenseService;
    
    @Autowired
    private InnoProjectFundPaymentMapper paymentMapper;
    
    /**
     * 查询经费支付记录列表
     */
    @GetMapping("/list")
    public TableDataInfo list(InnoProjectFundPaymentDTO dto) {
        startPage();
        List<InnoProjectFundPayment> list = paymentMapper.getTableList(dto);
        return getDataTable(list);
    }
    
    /**
     * 获取经费支付记录详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(paymentService.getById(id));
    }
    
    /**
     * 新增经费支付记录
     */
    @Log(title = "经费支付记录管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody InnoProjectFundPayment payment) {
        if (payment.getExpenseId() == null) {
            return error("支出ID不能为空");
        }
        
        // 获取支出信息
        InnoProjectFundExpense expense = expenseService.getById(payment.getExpenseId());
        if (expense == null) {
            return error("支出信息不存在");
        }
        
        // 设置项目ID
        payment.setProjectId(expense.getProjectId());
        
        // 保存支付记录并更新支出状态
        return toAjax(paymentService.savePaymentAndUpdateExpense(payment));
    }
    
    /**
     * 删除经费支付记录
     */
    @Log(title = "经费支付记录管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(paymentService.removeBatchByIds(Arrays.asList(ids)));
    }
} 
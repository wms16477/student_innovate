//package com.xinghe.web.controller;
//
//import com.xinghe.common.annotation.Log;
//import com.xinghe.common.core.controller.BaseController;
//import com.xinghe.common.core.domain.AjaxResult;
//import com.xinghe.common.core.page.TableDataInfo;
//import com.xinghe.common.enums.BusinessType;
//import com.xinghe.common.utils.SecurityUtils;
//import com.xinghe.system.domain.SysUserRole;
//import com.xinghe.system.mapper.SysUserRoleMapper;
//import com.xinghe.web.constants.Constants;
//import com.xinghe.web.domain.InnoProjectFundExpense;
//import com.xinghe.web.domain.InnoProjectFundPayment;
//import com.xinghe.web.domain.School;
//import com.xinghe.web.dto.InnoProjectFundPaymentDTO;
//import com.xinghe.web.mapper.InnoProjectFundPaymentMapper;
//import com.xinghe.web.service.InnoProjectFundExpenseService;
//import com.xinghe.web.service.InnoProjectFundPaymentService;
//import com.xinghe.web.service.SchoolService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.List;
//import java.util.Objects;
//
///**
// * 经费支付记录管理Controller
// *
// * @author xinghe
// */
//@RestController
//@RequestMapping("/web/fundPayment")
//public class InnoProjectFundPaymentController extends BaseController {
//
//    @Autowired
//    private InnoProjectFundPaymentService paymentService;
//
//    @Autowired
//    private InnoProjectFundExpenseService expenseService;
//
//    @Autowired
//    private InnoProjectFundPaymentMapper paymentMapper;
//
//    @Autowired
//    private SchoolService schoolService;
//
//    @Autowired
//    private SysUserRoleMapper sysUserRoleMapper;
//
//    /**
//     * 查询经费支付记录列表
//     */
//    @GetMapping("/list")
//    public TableDataInfo list(InnoProjectFundPaymentDTO dto) {
//        startPage();
//
//        // 获取当前登录用户
//        Long userId = getUserId();
//        String username = SecurityUtils.getUsername();
//        Long schoolId = null;
//        boolean isAdmin = false;
//
//        // 获取当前角色
//        List<SysUserRole> roleList = sysUserRoleMapper.selectUserRoleByUserId(userId);
//        for (SysUserRole sysUserRole : roleList) {
//            if (Objects.equals(sysUserRole.getRoleId(), Constants.ADMIN_ROLE_ID)) {
//                // 管理员
//                isAdmin = true;
//            } else if (Objects.equals(sysUserRole.getRoleId(), Constants.SCHOOL_ROLE_ID)) {
//                // 学校
//                School school = schoolService.lambdaQuery().eq(School::getSchoolCode, username).one();
//                if (school != null) {
//                    schoolId = school.getId();
//                    // 设置学校ID，用于过滤数据
//                    dto.setSchoolId(schoolId);
//                }
//            }
//        }
//
//        List<InnoProjectFundPayment> list = paymentMapper.getTableList(dto);
//
//        // 设置可操作按钮
//        for (InnoProjectFundPayment payment : list) {
//            if (payment.getButtonList() == null) {
//                payment.setButtonList(new ArrayList<>());
//            }
//
//            // 所有用户都可以查看
//            payment.getButtonList().add("查看");
//
//            // 只有管理员可以删除
//            if (isAdmin) {
//                payment.getButtonList().add("删除");
//            }
//        }
//
//        return getDataTable(list);
//    }
//
//    /**
//     * 获取经费支付记录详细信息
//     */
//    @GetMapping(value = "/{id}")
//    public AjaxResult getInfo(@PathVariable("id") Long id) {
//        InnoProjectFundPayment payment = paymentService.getById(id);
//        if (payment != null && payment.getExpenseId() != null) {
//            // 获取关联的支出信息
//            InnoProjectFundExpense expense = expenseService.getById(payment.getExpenseId());
//            payment.setExpense(expense);
//
//            // 记录日志，便于调试
//            System.out.println("支付记录ID: " + id + ", 关联支出ID: " + payment.getExpenseId() +
//                              ", 支出类型: " + (expense != null ? expense.getExpenseType() : "无") +
//                              ", 支出状态: " + (expense != null ? expense.getStatus() : "无"));
//        }
//        return success(payment);
//    }
//
//    /**
//     * 新增经费支付记录
//     */
//    @Log(title = "经费支付记录管理", businessType = BusinessType.INSERT)
//    @PostMapping
//    public AjaxResult add(@RequestBody InnoProjectFundPayment payment) {
//        if (payment.getExpenseId() == null) {
//            return error("支出ID不能为空");
//        }
//
//        // 获取支出信息
//        InnoProjectFundExpense expense = expenseService.getById(payment.getExpenseId());
//        if (expense == null) {
//            return error("支出信息不存在");
//        }
//
//        // 设置项目ID
//        payment.setProjectId(expense.getProjectId());
//
//        // 保存支付记录并更新支出状态
//        return toAjax(paymentService.savePaymentAndUpdateExpense(payment));
//    }
//
//    /**
//     * 删除经费支付记录
//     */
//    @Log(title = "经费支付记录管理", businessType = BusinessType.DELETE)
//    @DeleteMapping("/{ids}")
//    public AjaxResult remove(@PathVariable Long[] ids) {
//        return toAjax(paymentService.removeBatchByIds(Arrays.asList(ids)));
//    }
//}

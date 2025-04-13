package com.xinghe.sman.controller.controller;

import com.xinghe.common.annotation.Log;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.core.page.TableDataInfo;
import com.xinghe.common.enums.BusinessType;
import com.xinghe.common.utils.poi.ExcelUtil;
import com.xinghe.sman.domain.TestStudent;
import com.xinghe.sman.service.ITestStudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;

/**
 * 测试-学生Controller
 * 
 * @author ruoyi
 * @date 2025-03-13
 */
@RestController
@RequestMapping("/sman/student")
public class TestStudentController extends BaseController
{
    @Autowired
    private ITestStudentService testStudentService;

    /**
     * 查询测试-学生列表
     */
    @PreAuthorize("@ss.hasPermi('sman:student:list')")
    @GetMapping("/list")
    public TableDataInfo list(TestStudent testStudent)
    {
        startPage();
        List<TestStudent> list = testStudentService.selectList(testStudent);
        return getDataTable(list);
    }

    /**
     * 导出测试-学生列表
     */
    @PreAuthorize("@ss.hasPermi('sman:student:export')")
    @Log(title = "测试-学生", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TestStudent testStudent)
    {
        List<TestStudent> list = testStudentService.selectList(testStudent);
        ExcelUtil<TestStudent> util = new ExcelUtil<TestStudent>(TestStudent.class);
        util.exportExcel(response, list, "测试-学生数据");
    }

    /**
     * 获取测试-学生详细信息
     */
    @PreAuthorize("@ss.hasPermi('sman:student:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(testStudentService.getById(id));
    }

    /**
     * 新增测试-学生
     */
    @PreAuthorize("@ss.hasPermi('sman:student:add')")
    @Log(title = "测试-学生", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody TestStudent testStudent)
    {
        return toAjax(testStudentService.save(testStudent));
    }

    /**
     * 修改测试-学生
     */
    @PreAuthorize("@ss.hasPermi('sman:student:edit')")
    @Log(title = "测试-学生", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody TestStudent testStudent)
    {
        return toAjax(testStudentService.updateById(testStudent));
    }

    /**
     * 删除测试-学生
     */
    @PreAuthorize("@ss.hasPermi('sman:student:remove')")
    @Log(title = "测试-学生", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(testStudentService.removeByIds(Arrays.asList(ids)));
    }
}

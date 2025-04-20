package com.xinghe.web.controller;

import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.xinghe.common.annotation.Log;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.enums.BusinessType;
import com.xinghe.web.domain.Student;
import com.xinghe.web.service.StudentService;
import com.xinghe.common.utils.poi.ExcelUtil;
import com.xinghe.common.core.page.TableDataInfo;

/**
 * 学生Controller
 *
 * @author ruoyi
 * @date 2025-04-17
 */
@RestController
@RequestMapping("/student/student")
public class StudentController extends BaseController {
    @Autowired
    private StudentService studentService;

    /**
     * 查询学生列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Student student) {
        startPage();
        List<Student> list = studentService.selectList(student, false);
        return getDataTable(list);
    }

    /**
     * 查询学生列表
     */
    @GetMapping("/options")
    public AjaxResult options(Student student) {
        List<Student> list = studentService.selectList(student, true);
        return success(list);
    }


//    /**
//     * 查询学生map
//     */
//    @PreAuthorize("@ss.hasPermi('student:student:list')")
//    @GetMapping("/map")
//    public TableDataInfo map(Student student) {
//        List<Student> list = studentService.selectList(student);
//        return getDataTable(list);
//    }

    /**
     * 导出学生列表
     */
    @Log(title = "学生", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, Student student) {
        List<Student> list = studentService.selectList(student, false);
        ExcelUtil<Student> util = new ExcelUtil<Student>(Student.class);
        util.exportExcel(response, list, "学生数据");
    }

    /**
     * 获取学生详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(studentService.getById(id));
    }

    /**
     * 新增学生
     */
    @Log(title = "学生", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody Student student) {
        studentService.addStudent(student);
        return success();
    }

    /**
     * 修改学生
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Student student) {
        return toAjax(studentService.updateById(student));
    }

    /**
     * 删除学生
     */
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(studentService.removeByIds(Arrays.asList(ids)));
    }
}

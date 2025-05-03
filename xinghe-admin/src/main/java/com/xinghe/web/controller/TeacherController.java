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
import com.xinghe.web.domain.Teacher;
import com.xinghe.web.service.TeacherService;
import com.xinghe.common.utils.poi.ExcelUtil;
import com.xinghe.common.core.page.TableDataInfo;
import org.springframework.web.multipart.MultipartFile;

/**
 * 老师Controller
 *
 * @author ruoyi
 * @date 2025-04-19
 */
@RestController
@RequestMapping("/person/teacher")
public class TeacherController extends BaseController {


    @Autowired
    private TeacherService teacherService;

    /**
     * 查询老师列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Teacher teacher) {
        startPage();
        List<Teacher> list = teacherService.selectList(teacher);
        return getDataTable(list);
    }

    /**
     * 导出老师列表
     */
    @PostMapping("/export")
    public void export(HttpServletResponse response, Teacher teacher) {
        List<Teacher> list = teacherService.selectList(teacher);
        ExcelUtil<Teacher> util = new ExcelUtil<Teacher>(Teacher.class);
        util.exportExcel(response, list, "老师数据");
    }

    /**
     * 获取导入模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<Teacher> util = new ExcelUtil<Teacher>(Teacher.class);
        util.importTemplateExcel(response, "老师数据");
    }

    /**
     * 批量导入老师数据
     */
    @Log(title = "老师", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file) throws Exception {
        ExcelUtil<Teacher> util = new ExcelUtil<Teacher>(Teacher.class);
        List<Teacher> teacherList = util.importExcel(file.getInputStream());
        
        String message = teacherService.importTeachers(teacherList);
        return success(message);
    }

    /**
     * 获取老师详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(teacherService.getById(id));
    }

    /**
     * 新增老师
     */
    @PostMapping
    public AjaxResult add(@RequestBody Teacher teacher) {
        teacherService.addTeacher(teacher);
        return success();
    }

    /**
     * 修改老师
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Teacher teacher) {
        return toAjax(teacherService.updateById(teacher));
    }

    /**
     * 删除老师
     */
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(teacherService.removeByIds(Arrays.asList(ids)));
    }
}

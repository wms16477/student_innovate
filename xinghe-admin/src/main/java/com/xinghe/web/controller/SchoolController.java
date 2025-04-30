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
import com.xinghe.web.domain.School;
import com.xinghe.web.service.SchoolService;
import com.xinghe.common.utils.poi.ExcelUtil;
import com.xinghe.common.core.page.TableDataInfo;

/**
 * 学校Controller
 *
 * @date 2025-04-20
 */
@RestController
@RequestMapping("/school")
public class SchoolController extends BaseController {

    @Autowired
    private SchoolService schoolService;

    /**
     * 查询学校列表
     */
    @GetMapping("/list")
    public TableDataInfo list(School school) {
        startPage();
        List<School> list = schoolService.selectList(school);
        return getDataTable(list);
    }

    /**
     * 导出学校列表
     */
    @PostMapping("/export")
    public void export(HttpServletResponse response, School school) {
        List<School> list = schoolService.selectList(school);
        ExcelUtil<School> util = new ExcelUtil<School>(School.class);
        util.exportExcel(response, list, "学校数据");
    }

    /**
     * 获取学校详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(schoolService.getById(id));
    }

    /**
     * 新增学校
     */
    @PostMapping
    public AjaxResult add(@RequestBody School school) {
        schoolService.addSchool(school);
        return success();
    }

    /**
     * 修改学校
     */
    @PutMapping
    public AjaxResult edit(@RequestBody School school) {
        return toAjax(schoolService.updateById(school));
    }

    /**
     * 删除学校
     */
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(schoolService.removeByIds(Arrays.asList(ids)));
    }
} 
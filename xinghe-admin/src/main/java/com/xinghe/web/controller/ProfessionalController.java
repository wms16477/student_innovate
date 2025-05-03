package com.xinghe.web.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.xinghe.common.core.controller.BaseController;
import com.xinghe.common.core.domain.AjaxResult;
import com.xinghe.common.core.page.TableDataInfo;
import com.xinghe.common.utils.StringUtils;
import com.xinghe.web.domain.Professional;
import com.xinghe.web.service.ProfessionalService;
import com.xinghe.web.enums.ProjectType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.multipart.MultipartFile;
import com.xinghe.common.annotation.Log;
import com.xinghe.common.enums.BusinessType;
import com.xinghe.common.utils.poi.ExcelUtil;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 专家Controller
 */
@RestController
@RequestMapping("/web/professional")
public class ProfessionalController extends BaseController {

    @Autowired
    private ProfessionalService professionalService;

    /**
     * 查询领域列表
     */
    @GetMapping("/area/list")
    public AjaxResult listArea() {
        List<String> list = Arrays.stream(ProjectType.values())
                .map(ProjectType::getName)
                .collect(Collectors.toList());
        return success(list);
    }

    /**
     * 查询专家列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Professional professional) {
        startPage();
        List<Professional> list = professionalService.selectList(professional);
        return getDataTable(list);
    }

    /**
     * 导出专家列表
     */
    @PostMapping("/export")
    public void export(HttpServletResponse response, Professional professional) {
        List<Professional> list = professionalService.selectList(professional);
        ExcelUtil<Professional> util = new ExcelUtil<Professional>(Professional.class);
        util.exportExcel(response, list, "专家数据");
    }

    /**
     * 获取导入模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<Professional> util = new ExcelUtil<Professional>(Professional.class);
        util.importTemplateExcel(response, "专家数据");
    }

    /**
     * 批量导入专家数据
     */
    @Log(title = "专家", businessType = BusinessType.IMPORT)
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file) throws Exception {
        ExcelUtil<Professional> util = new ExcelUtil<Professional>(Professional.class);
        List<Professional> professionalList = util.importExcel(file.getInputStream());
        
        String message = professionalService.importProfessionals(professionalList);
        return success(message);
    }

    /**
     * 获取专家详细信息
     */
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(professionalService.getById(id));
    }

    /**
     * 新增专家
     */
    @PostMapping
    public AjaxResult add(@RequestBody Professional professional) {
        professionalService.addProfessional(professional);
        return success();
    }

    /**
     * 修改专家
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Professional professional) {
        return toAjax(professionalService.updateById(professional));
    }

    /**
     * 删除专家
     */
    @DeleteMapping("/{id}")
    public AjaxResult remove(@PathVariable Long id) {
        return toAjax(professionalService.removeById(id));
    }
} 
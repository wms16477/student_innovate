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
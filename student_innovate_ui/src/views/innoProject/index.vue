<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="项目名称" prop="projectName">
        <el-input
          v-model="queryParams.projectName"
          placeholder="请输入项目名称"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          v-model="dateRange"
          size="small"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
        >项目申报
        </el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="projectList">
      <el-table-column label="项目名称" align="center" prop="projectName"/>
      <el-table-column label="项目类型" align="center" prop="projectType"/>
      <el-table-column label="导师" align="center" prop="teacherName"/>
      <el-table-column label="状态" align="center" prop="status"/>
      <el-table-column label="申报时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleDetail(scope.row)"
          >详情
          </el-button>
          <el-button
            v-if="scope.row.status === 'DRAFT' || scope.row.status === 'APPROVE_FAIL'"
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
          >修改
          </el-button>
          <el-button
            v-if="scope.row.status === 'DRAFT' || scope.row.status === 'APPROVE_FAIL'"
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
          >删除
          </el-button>
          <el-button
            v-if="scope.row.status === 'DRAFT'"
            size="mini"
            type="text"
            icon="el-icon-upload2"
            @click="handleSubmit(scope.row)"
          >提交
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 添加或修改大创项目对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="项目名称" prop="projectName">
          <el-input v-model="form.projectName" placeholder="请输入项目名称"/>
        </el-form-item>
        <el-form-item label="项目类型" prop="projectType">
          <el-select v-model="form.projectType" placeholder="请选择项目类型">
            <el-option
              v-for="item in projectTypeList"
              :key="item"
              :label="item"
              :value="item"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="项目简介" prop="projectDesc">
          <el-input v-model="form.projectDesc" type="textarea" placeholder="请输入项目简介"/>
        </el-form-item>
        <el-form-item label="导师" prop="teacherId">
          <el-select v-model="form.teacherId" placeholder="请选择导师">
            <el-option
              v-for="teacher in teacherOptions"
              :key="teacher.id"
              :label="teacher.teacherName"
              :value="teacher.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="申报材料" prop="submitFileUrl">
          <file-upload v-model="form.submitFileUrl"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="handleSave">暂 存</el-button>
        <el-button type="success" @click="handleSubmitForm">提 交</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 项目详情对话框 -->
    <el-dialog title="项目详情" :visible.sync="detailOpen" width="700px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="项目名称">{{ detail.projectName }}</el-descriptions-item>
        <el-descriptions-item label="项目类型">
          <dict-tag :options="projectTypeList" :value="detail.projectType"/>
        </el-descriptions-item>
        <el-descriptions-item label="项目简介">{{ detail.projectDesc }}</el-descriptions-item>
        <el-descriptions-item label="导师">{{ detail.teacherName }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="statusOptions" :value="detail.status"/>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ parseTime(detail.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="申报材料" :span="2">
<!--          <file-download :fileUrl="detail.submitFileUrl" :fileName="detail.submitFileName"/>-->
          <el-link href="https://element.eleme.io" target="_blank">默认链接</el-link>
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
import {
  listInnoProject,
  getInnoProject,
  delInnoProject,
  addInnoProject,
  updateInnoProject,
  submitInnoProject
} from "@/api/innoProject";
import {listTeacher} from "@/api/person/teacher";
import {listProjectType} from "@/api/system/projectType";

export default {
  name: "InnoProject",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 大创项目表格数据
      projectList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否显示详情弹出层
      detailOpen: false,
      // 日期范围
      dateRange: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        projectName: undefined
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        projectName: [
          {required: true, message: "项目名称不能为空", trigger: "blur"}
        ],
        projectType: [
          {required: true, message: "项目类型不能为空", trigger: "change"}
        ],
        projectDesc: [
          {required: true, message: "项目简介不能为空", trigger: "blur"}
        ],
        teacherId: [
          {required: true, message: "导师不能为空", trigger: "change"}
        ],
        submitFileUrl: [
          {required: true, message: "申报材料不能为空", trigger: "change"}
        ]
      },
      // 项目类型选项
      projectTypeOptions: [],
      // 状态选项
      statusOptions: [],
      // 导师选项
      teacherOptions: [],
      // 详情数据
      detail: {},
      // 项目类型列表
      projectTypeList: [],
    };
  },
  created() {
    this.getList();
    this.getProjectTypeList();
    this.getDicts("project_status").then(response => {
      this.statusOptions = response.data;
    });
    this.getTeacherList();
  },
  methods: {
    /** 查询大创项目列表 */
    getList() {
      this.loading = true;
      listInnoProject(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.projectList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 查询项目类型列表 */
    getProjectTypeList() {
      listProjectType().then(response => {
        this.projectTypeList = response.data;
      });
    },
    /** 查询导师列表 */
    getTeacherList() {
      listTeacher().then(response => {
        this.teacherOptions = response.rows;
      });
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
      this.reset();
    },
    /** 表单重置 */
    reset() {
      this.form = {
        id: undefined,
        projectName: undefined,
        projectType: undefined,
        projectDesc: undefined,
        teacherId: undefined,
        submitFileUrl: undefined
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加大创项目";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getInnoProject(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改大创项目";
      });
    },
    /** 暂存按钮 */
    handleSave() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id !== undefined && this.form.id !== null) {
            updateInnoProject(this.form, false).then(response => {
              this.$modal.msgSuccess("暂存成功");
              this.open = false;
              this.getList();
            });
          } else {
            addInnoProject(this.form, false).then(response => {
              this.$modal.msgSuccess("暂存成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 提交按钮 */
    handleSubmitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id !== undefined && this.form.id !== null) {
            updateInnoProject(this.form, true).then(response => {
              this.$modal.msgSuccess("暂存成功");
              this.open = false;
              this.getList();
            });
          } else {
            addInnoProject(this.form, true).then(response => {
              this.$modal.msgSuccess("暂存成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除大创项目编号为"' + ids + '"的数据项？').then(function () {
        return delInnoProject(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 详情按钮操作 */
    handleDetail(row) {
      getInnoProject(row.id).then(response => {
        this.detail = response.data;
        this.detailOpen = true;
      });
    },
    /** 提交按钮操作 */
    handleSubmit(row) {
      this.$modal.confirm('是否确认提交大创项目编号为"' + row.id + '"的数据项？').then(function () {
        return submitInnoProject(row.id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("提交成功");
      }).catch(() => {
      });
    }
  }
};
</script>

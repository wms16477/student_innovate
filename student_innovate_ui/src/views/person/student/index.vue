<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="学号" prop="stuNo">
        <el-input
          v-model="queryParams.stuNo"
          placeholder="请输入学号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="学生姓名" prop="stuName">
        <el-input
          v-model="queryParams.stuName"
          placeholder="请输入学生姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="专业" prop="speciality">
<!--        <el-input-->
<!--          v-model="queryParams.speciality"-->
<!--          placeholder="请输入专业"-->
<!--          clearable-->
<!--          @keyup.enter.native="handleQuery"-->
<!--        />-->
        <el-select v-model="queryParams.speciality" placeholder="请选择" clearable>
          <el-option
            v-for="item in specialityOptions()"
            :key="item"
            :label="item"
            :value="item">
          </el-option>
        </el-select>
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
        >新增
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
        >导出
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-upload2"
          size="mini"
          @click="handleImport"
        >导入
        </el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="studentList" @selection-change="handleSelectionChange">
<!--      <el-table-column label="id" align="center" prop="id"/>-->
      <el-table-column label="学号" align="center" prop="stuNo"/>
      <el-table-column label="学生姓名" align="center" prop="stuName"/>
      <el-table-column label="专业" align="center" prop="speciality"/>
      <el-table-column label="联系电话" align="center" prop="phoneNum"/>
      <el-table-column label="邮箱" align="center" prop="email"/>
      <el-table-column label="入学时间" align="center" prop="inTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.inTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="身份证号" align="center" prop="userId"/>
      <el-table-column label="学校" align="center" prop="schoolName"/>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            style="color: #f56c6c"
          >删除
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

    <!-- 添加或修改学生对话框 -->
    <el-drawer :title="title" :visible.sync="open" size="420px" append-to-body @close="cancel">
      <el-form ref="form" :model="form" :rules="rules" label-width="80px" style="padding: 20px">
        <el-form-item label="学号" prop="stuNo">
          <el-input v-model="form.stuNo" placeholder="请输入学号"/>
        </el-form-item>
        <el-form-item label="学生姓名" prop="stuName">
          <el-input v-model="form.stuName" placeholder="请输入学生姓名"/>
        </el-form-item>
        <el-form-item label="专业" prop="speciality">
          <el-select v-model="form.speciality" placeholder="请选择" clearable>
            <el-option
              v-for="item in specialityOptions()"
              :key="item"
              :label="item"
              :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="联系电话" prop="phoneNum">
          <el-input v-model="form.phoneNum" placeholder="请输入联系电话"/>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱"/>
        </el-form-item>
        <el-form-item label="入学时间" prop="inTime">
          <el-date-picker clearable
                          v-model="form.inTime"
                          type="date"
                          value-format="yyyy-MM-dd"
                          placeholder="请选择入学时间">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="身份证号" prop="userId">
          <el-input v-model="form.userId" placeholder="请输入身份证号"/>
        </el-form-item>
        <el-form-item label="学校" prop="schoolId">
          <el-select v-model="form.schoolId" placeholder="请选择学校" clearable>
            <el-option
              v-for="item in schoolOptions"
              :key="item.id"
              :label="item.schoolName"
              :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <div class="drawer-footer">
          <el-form-item label-width="0">
            <el-button type="primary" @click="submitForm">提 交</el-button>
            <el-button @click="cancel">取 消</el-button>
          </el-form-item>
        </div>
      </el-form>
    </el-drawer>

    <!-- 导入对话框 -->
    <el-dialog :title="upload.title" :visible.sync="upload.open" width="400px" append-to-body>
      <el-upload
        ref="upload"
        :limit="1"
        accept=".xlsx, .xls"
        :headers="upload.headers"
        :action="upload.url + '?updateSupport=' + upload.updateSupport"
        :disabled="upload.isUploading"
        :on-progress="handleFileUploadProgress"
        :on-success="handleFileSuccess"
        :auto-upload="false"
        drag
      >
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip text-center" slot="tip">
<!--          <div class="el-upload__tip" slot="tip">-->
<!--            <el-checkbox v-model="upload.updateSupport" />是否更新已经存在的学生数据-->
<!--          </div>-->
          <span>仅允许导入xls、xlsx格式文件。</span>
          <el-link type="primary" :underline="false" style="font-size:12px;vertical-align: baseline;" @click="importTemplate">下载模板</el-link>
        </div>
      </el-upload>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitFileForm">确 定</el-button>
        <el-button @click="upload.open = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listStudent, getStudent, delStudent, addStudent, updateStudent, exportStudent, importTemplate, importData} from "@/api/person/student";
import { getSchoolOptions } from "@/api/school";
import { specialityOptions} from "@/constants/DictConstants";
import { getToken } from "@/utils/auth";

export default {
  name: "Student",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 学生表格数据
      studentList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        stuNo: null,
        stuName: null,
        speciality: null,
        phoneNum: null,
        email: null,
        inTime: null,
        userId: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        stuNo: [
          {required: true, message: "学号不能为空", trigger: "blur"}
        ],
        stuName: [
          {required: true, message: "学生姓名不能为空", trigger: "blur"}
        ],
        speciality: [
          {required: true, message: "专业不能为空", trigger: "blur"}
        ],
        phoneNum: [
          {required: true, message: "联系电话不能为空", trigger: "blur"}
        ],
        email: [
          {required: true, message: "邮箱不能为空", trigger: "blur"}
        ],
        inTime: [
          {required: true, message: "入学时间不能为空", trigger: "blur"}
        ],
        userId: [
          {required: true, message: "身份证号不能为空", trigger: "blur"}
        ],
        schoolId: [
          {required: true, message: "学校不能为空", trigger: "change"}
        ]
      },
      // 学校选项
      schoolOptions: [],
      // 导入参数
      upload: {
        // 是否显示弹出层（导入）
        open: false,
        // 弹出层标题（导入）
        title: "导入学生数据",
        // 是否禁用上传
        isUploading: false,
        // 设置上传的请求头部
        headers: { Authorization: "Bearer " + getToken() },
        // 上传的地址
        url: process.env.VUE_APP_BASE_API + "/student/student/importData",
        // 是否更新已存在数据
        updateSupport: 0
      },
    };
  },
  created() {
    this.getList();
    this.getSchoolOptions();
  },
  methods: {
    specialityOptions() {
      return specialityOptions
    },
    /** 查询学生列表 */
    getList() {
      this.loading = true;
      listStudent(this.queryParams).then(response => {
        this.studentList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        stuNo: null,
        stuName: null,
        speciality: null,
        phoneNum: null,
        email: null,
        inTime: null,
        userId: null,
        schoolId: null,
        createTime: null
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
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加学生";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getStudent(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改学生";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateStudent(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addStudent(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
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
      this.$modal.confirm('是否确认删除学生编号为"' + ids + '"的数据项？').then(function () {
        return delStudent(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      // exportStudent(this.queryParams).then(response => {
      //   this.download(response);
      // });
      this.download('/student/student/export', {
      }, `学生导出.xlsx`)
    },
    /** 获取学校选项 */
    getSchoolOptions() {
      getSchoolOptions().then(response => {
        this.schoolOptions = response.rows;
      });
    },
    // 导入按钮操作
    handleImport() {
      this.upload.open = true;
    },
    // 文件上传中处理
    handleFileUploadProgress(event, file, fileList) {
      this.upload.isUploading = true;
    },
    // 文件上传成功处理
    handleFileSuccess(response, file, fileList) {
      this.upload.open = false;
      this.upload.isUploading = false;
      this.$refs.upload.clearFiles();
      this.$alert("<div style='overflow: auto;overflow-x: hidden;max-height: 70vh;padding: 10px 20px 0;'>" + response.msg + "</div>", "导入结果", { dangerouslyUseHTMLString: true });
      this.getList();
    },
    // 提交上传文件
    submitFileForm() {
      this.$refs.upload.submit();
    },
    // 下载模板
    importTemplate() {
      // importTemplate().then(response => {
      //   console.log(this.download);
      //   this.download(response);
      // });
      this.download('student/student/importTemplate', {
      }, `学生导入模版.xlsx`)
    },
  }
};
</script>

<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="账号" prop="account">
        <el-input
          v-model="queryParams.account"
          placeholder="请输入账号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="老师姓名" prop="teacherName">
        <el-input
          v-model="queryParams.teacherName"
          placeholder="请输入老师姓名"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="性别" prop="gender">
        <el-select v-model="queryParams.gender" placeholder="请选择性别" clearable>
          <el-option label="男" value="男"></el-option>
          <el-option label="女" value="女"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="级别" prop="level">
        <el-select v-model="queryParams.level" placeholder="请选择级别" clearable>
          <el-option
            v-for="item in levelOptions"
            :key="item"
            :label="item"
            :value="item">
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="学历" prop="degree">
        <el-select v-model="queryParams.degree" placeholder="请选择学历" clearable>
          <el-option
            v-for="item in degreeOptions"
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
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
        >修改
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
        >删除
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

    <el-table v-loading="loading" :data="teacherList" @selection-change="handleSelectionChange">
      <el-table-column label="id" align="center" prop="id"/>
      <el-table-column label="账号" align="center" prop="account"/>
      <el-table-column label="老师姓名" align="center" prop="teacherName"/>
      <el-table-column label="性别" align="center" prop="gender"/>
      <el-table-column label="级别" align="center" prop="level"/>
      <el-table-column label="学历" align="center" prop="degree"/>
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

    <!-- 添加或修改老师对话框 -->
    <el-drawer :title="title" :visible.sync="open" size="420px" append-to-body @close="cancel">
      <el-form ref="form" :model="form" :rules="rules" label-width="80px" style="padding: 20px">
        <el-form-item label="账号" prop="account">
          <el-input v-model="form.account" placeholder="请输入账号"/>
        </el-form-item>
        <el-form-item label="老师姓名" prop="teacherName">
          <el-input v-model="form.teacherName" placeholder="请输入老师姓名"/>
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-select v-model="form.gender" placeholder="请选择性别">
            <el-option label="男" value="男"></el-option>
            <el-option label="女" value="女"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="级别" prop="level">
          <el-select v-model="form.level" placeholder="请选择级别">
            <el-option
              v-for="item in levelOptions"
              :key="item"
              :label="item"
              :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="学历" prop="degree">
          <el-select v-model="form.degree" placeholder="请选择学历">
            <el-option
              v-for="item in degreeOptions"
              :key="item"
              :label="item"
              :value="item">
            </el-option>
          </el-select>
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
<!--            <el-checkbox v-model="upload.updateSupport"/>-->
<!--            是否更新已经存在的教师数据-->
<!--          </div>-->
          <span>仅允许导入xls、xlsx格式文件。</span>
          <el-link type="primary" :underline="false" style="font-size:12px;vertical-align: baseline;"
                   @click="importTemplate">下载模板
          </el-link>
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
import {
  listTeacher,
  getTeacher,
  delTeacher,
  addTeacher,
  updateTeacher,
  exportTeacher,
  importTemplate,
  importData
} from "@/api/person/teacher";
import {getSchoolOptions} from "@/api/school";
import {getToken} from "@/utils/auth";

export default {
  name: "Teacher",
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
      // 老师表格数据
      teacherList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        account: null,
        teacherName: null,
        gender: null,
        level: null,
        degree: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        account: [
          {required: true, message: "账号不能为空", trigger: "blur"}
        ],
        teacherName: [
          {required: true, message: "老师姓名不能为空", trigger: "blur"}
        ],
        gender: [
          {required: true, message: "性别不能为空", trigger: "blur"}
        ],
        level: [
          {required: true, message: "级别不能为空", trigger: "blur"}
        ],
        degree: [
          {required: true, message: "学历不能为空", trigger: "blur"}
        ],
      },
      // 学校选项
      schoolOptions: [],
      // 级别选项
      levelOptions: ['助教', '讲师', '副教授', '教授'],
      // 学历选项
      degreeOptions: ['学士', '硕士', '博士', '博士后'],
      // 导入相关参数
      upload: {
        title: "导入教师数据",
        open: false,
        url: process.env.VUE_APP_BASE_API + "/person/teacher/importData",
        headers: {Authorization: "Bearer " + getToken()},
        isUploading: false,
        updateSupport: 0
      },
    };
  },
  created() {
    this.getList();
    this.getSchoolOptions();
  },
  methods: {
    /** 查询老师列表 */
    getList() {
      this.loading = true;
      listTeacher(this.queryParams).then(response => {
        this.teacherList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 获取学校选项 */
    getSchoolOptions() {
      getSchoolOptions().then(response => {
        this.schoolOptions = response.rows;
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
        account: null,
        teacherName: null,
        gender: null,
        level: null,
        degree: null,
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
      this.title = "添加老师";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids
      getTeacher(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改老师";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateTeacher(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addTeacher(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除老师编号为"' + ids + '"的数据项？').then(function () {
        return delTeacher(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      // exportTeacher(this.queryParams).then(response => {
      //   this.download(response.msg);
      // });
      this.download('/person/teacher/export', {
      }, `教师导出.xlsx`)
    },
    // 导入相关方法
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
      this.$alert("<div style='overflow: auto;overflow-x: hidden;max-height: 70vh;padding: 10px 20px 0;'>" + response.msg + "</div>", "导入结果", {dangerouslyUseHTMLString: true});
      this.getList();
    },
    // 提交上传文件
    submitFileForm() {
      this.$refs.upload.submit();
    },
    importTemplate() {
      // importTemplate().then(response => {
      //   this.download(response.msg);
      // });
      this.download('person/teacher/importTemplate', {}, `教师导入模版.xlsx`)
    },
  }
};
</script>

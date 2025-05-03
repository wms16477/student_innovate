<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="账号" prop="account">
        <el-input
          v-model="queryParams.account"
          placeholder="请输入账号"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="姓名" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入姓名"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="领域" prop="area">
        <el-select v-model="queryParams.area" placeholder="请选择领域" clearable size="small">
          <el-option
            v-for="item in areaOptions"
            :key="item"
            :label="item"
            :value="item"
          />
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
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
        >导出</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-upload2"
          size="mini"
          @click="handleImport"
        >导入</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="professionalList">
      <el-table-column label="账号" align="center" prop="account" />
      <el-table-column label="姓名" align="center" prop="name" />
      <el-table-column label="领域" align="center" prop="area" />
      <el-table-column label="性别" align="center" prop="gender" />
      <el-table-column label="所属单位" align="center" prop="company" />
      <el-table-column label="职务" align="center" prop="job" />
      <el-table-column label="联系方式" align="center" prop="phoneNum" />
      <el-table-column label="研究方向" align="center" prop="researchDirection" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
          >删除</el-button>
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

    <!-- 添加或修改专家对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="账号" prop="account">
          <el-input v-model="form.account" placeholder="请输入账号" />
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="form.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="领域" prop="area">
          <el-select v-model="form.area" placeholder="请选择领域">
            <el-option
              v-for="item in areaOptions"
              :key="item"
              :label="item"
              :value="item"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-select v-model="form.gender" placeholder="请选择性别">
            <el-option label="男" value="男" />
            <el-option label="女" value="女" />
          </el-select>
        </el-form-item>
        <el-form-item label="所属单位" prop="company">
          <el-input v-model="form.company" placeholder="请输入所属单位" />
        </el-form-item>
        <el-form-item label="职务" prop="job">
          <el-input v-model="form.job" placeholder="请输入职务" />
        </el-form-item>
        <el-form-item label="联系方式" prop="phoneNum">
          <el-input v-model="form.phoneNum" placeholder="请输入联系方式" />
        </el-form-item>
        <el-form-item label="研究方向" prop="researchDirection">
          <el-input v-model="form.researchDirection" type="textarea" placeholder="请输入研究方向" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

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
<!--            <el-checkbox v-model="upload.updateSupport" />是否更新已经存在的专家数据-->
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
import { listProfessional, getProfessional, delProfessional, addProfessional, updateProfessional, getAreaList, exportProfessional, importTemplate, importData } from "@/api/professional";
import { getToken } from "@/utils/auth";

export default {
  name: "Professional",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 专家表格数据
      professionalList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 领域选项
      areaOptions: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        account: null,
        name: null,
        area: null
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        account: [
          { required: true, message: "账号不能为空", trigger: "blur" }
        ],
        name: [
          { required: true, message: "姓名不能为空", trigger: "blur" }
        ],
        area: [
          { required: true, message: "领域不能为空", trigger: "change" }
        ],
        gender: [
          { required: true, message: "性别不能为空", trigger: "change" }
        ],
        company: [
          { required: true, message: "所属单位不能为空", trigger: "blur" }
        ],
        job: [
          { required: true, message: "职务不能为空", trigger: "blur" }
        ],
        phoneNum: [
          { required: true, message: "联系方式不能为空", trigger: "blur" }
        ],
        researchDirection: [
          { required: true, message: "研究方向不能为空", trigger: "blur" }
        ]
      },
      // 导入相关参数
      upload: {
        title: "导入专家数据",
        open: false,
        url: process.env.VUE_APP_BASE_API + "/professional/professional/importData",
        headers: { Authorization: "Bearer " + getToken() },
        isUploading: false,
        updateSupport: 0
      }
    };
  },
  created() {
    this.getList();
    this.getAreaOptions();
  },
  methods: {
    /** 查询专家列表 */
    getList() {
      this.loading = true;
      listProfessional(this.queryParams).then(response => {
        this.professionalList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 获取领域选项 */
    getAreaOptions() {
      getAreaList().then(response => {
        this.areaOptions = response.data;
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
        name: null,
        area: null,
        gender: null,
        company: null,
        job: null,
        phoneNum: null,
        researchDirection: null
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
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加专家";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getProfessional(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改专家";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateProfessional(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addProfessional(this.form).then(response => {
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
      this.$modal.confirm('是否确认删除专家编号为"' + ids + '"的数据项？').then(function() {
        return delProfessional(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    // 导出功能
    handleExport() {
      exportProfessional(this.queryParams).then(response => {
        this.download(response.msg);
      });
    },
    // 导入功能
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
      this.download('web/professional/importTemplate', {}, `专家导入模版.xlsx`)
    }
  }
};
</script>

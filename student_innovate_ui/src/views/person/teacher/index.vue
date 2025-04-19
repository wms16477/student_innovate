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
        <el-input
          v-model="queryParams.gender"
          placeholder="请输入性别"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="级别" prop="level">
        <el-input
          v-model="queryParams.level"
          placeholder="请输入级别"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="学历" prop="degree">
        <el-input
          v-model="queryParams.degree"
          placeholder="请输入学历"
          clearable
          @keyup.enter.native="handleQuery"
        />
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
          v-hasPermi="['person:teacher:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['person:teacher:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['person:teacher:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['person:teacher:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="teacherList" @selection-change="handleSelectionChange">
      <el-table-column label="id" align="center" prop="id" />
      <el-table-column label="账号" align="center" prop="account" />
      <el-table-column label="老师姓名" align="center" prop="teacherName" />
      <el-table-column label="性别" align="center" prop="gender" />
      <el-table-column label="级别" align="center" prop="level" />
      <el-table-column label="学历" align="center" prop="degree" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['person:teacher:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['person:teacher:remove']"
            style="color: #f56c6c"
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

    <!-- 添加或修改老师对话框 -->
    <el-drawer :title="title" :visible.sync="open" size="420px" append-to-body @close="cancel">
      <el-form ref="form" :model="form" :rules="rules" label-width="80px" style="padding: 20px">
        <el-form-item label="账号" prop="account">
          <el-input v-model="form.account" placeholder="请输入账号" />
        </el-form-item>
        <el-form-item label="老师姓名" prop="teacherName">
          <el-input v-model="form.teacherName" placeholder="请输入老师姓名" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-input v-model="form.gender" placeholder="请输入性别" />
        </el-form-item>
        <el-form-item label="级别" prop="level">
          <el-input v-model="form.level" placeholder="请输入级别" />
        </el-form-item>
        <el-form-item label="学历" prop="degree">
          <el-input v-model="form.degree" placeholder="请输入学历" />
        </el-form-item>
        <div class="drawer-footer">
          <el-form-item label-width="0">
            <el-button type="primary" @click="submitForm">提 交</el-button>
            <el-button @click="cancel">取 消</el-button>
          </el-form-item>
        </div>
      </el-form>
    </el-drawer>
  </div>
</template>

<script>
import { listTeacher, getTeacher, delTeacher, addTeacher, updateTeacher } from "@/api/person/teacher";

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
          { required: true, message: "账号不能为空", trigger: "blur" }
        ],
        teacherName: [
          { required: true, message: "老师姓名不能为空", trigger: "blur" }
        ],
        gender: [
          { required: true, message: "性别不能为空", trigger: "blur" }
        ],
        level: [
          { required: true, message: "级别不能为空", trigger: "blur" }
        ],
        degree: [
          { required: true, message: "学历不能为空", trigger: "blur" }
        ],
      }
    };
  },
  created() {
    this.getList();
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
      this.single = selection.length!==1
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
      this.$modal.confirm('是否确认删除老师编号为"' + ids + '"的数据项？').then(function() {
        return delTeacher(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('person/teacher/export', {
        ...this.queryParams
      }, `teacher_${new Date().getTime()}.xlsx`)
    }
  }
};
</script>

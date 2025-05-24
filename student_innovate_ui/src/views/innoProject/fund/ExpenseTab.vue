<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="项目名称" prop="projectName">
        <el-input v-model="queryParams.projectName" placeholder="请输入项目名称" clearable size="small" @keyup.enter.native="handleQuery" />
      </el-form-item>
<!--      <el-form-item label="支出类型" prop="expenseType">-->
<!--        <el-select v-model="queryParams.expenseType" placeholder="请选择支出类型" clearable size="small">-->
<!--          <el-option v-for="dict in expenseTypeOptions" :key="dict.value" :label="dict.label" :value="dict.value" />-->
<!--        </el-select>-->
<!--      </el-form-item>-->
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable size="small">
          <el-option v-for="dict in statusOptions" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5" v-if="isTeacherRole">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="expenseList">
      <el-table-column label="项目名称" align="center" prop="projectName" :show-overflow-tooltip="true" />
      <el-table-column label="支出名称" align="center" prop="expenseName" :show-overflow-tooltip="true" />
<!--      <el-table-column label="支出类型" align="center" prop="expenseType">-->
<!--        <template slot-scope="scope">-->
<!--          <dict-tag :options="expenseTypeOptions" :value="scope.row.expenseType"/>-->
<!--        </template>-->
<!--      </el-table-column>-->
      <el-table-column label="支出金额" align="center" prop="expenseAmount" />
      <el-table-column label="支出日期" align="center" prop="expenseDate" width="100">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.expenseDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="statusOptions" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="100">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
          <el-button v-if="scope.row.buttonList && scope.row.buttonList.includes('修改') && isTeacherRole" size="mini" type="text" icon="el-icon-edit" @click="handleUpdate(scope.row)">修改</el-button>
          <el-button v-if="scope.row.buttonList && scope.row.buttonList.includes('删除') && isTeacherRole" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          <el-button v-if="scope.row.buttonList && scope.row.buttonList.includes('提交') && isTeacherRole" size="mini" type="text" icon="el-icon-upload2" @click="handleSubmit(scope.row)">提交</el-button>
          <el-button v-if="scope.row.buttonList && scope.row.buttonList.includes('批准')" size="mini" type="text" icon="el-icon-check" @click="handleApprove(scope.row, true)">批准</el-button>
          <el-button v-if="scope.row.buttonList && scope.row.buttonList.includes('拒绝')" size="mini" type="text" icon="el-icon-close" @click="handleApprove(scope.row, false)">拒绝</el-button>
          <el-button v-if="scope.row.buttonList && scope.row.buttonList.includes('学校批准')" size="mini" type="text" icon="el-icon-check" @click="handleSchoolApprove(scope.row, true)">批准</el-button>
          <el-button v-if="scope.row.buttonList && scope.row.buttonList.includes('学校拒绝')" size="mini" type="text" icon="el-icon-close" @click="handleSchoolApprove(scope.row, false)">拒绝</el-button>
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

    <!-- 添加或修改支出对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="650px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="项目" prop="projectId">
          <el-select v-model="form.projectId" placeholder="请选择项目" @change="handleProjectChange" :disabled="form.id !== undefined && form.id !== null">
            <el-option
              v-for="item in projectOptions"
              :key="item.id"
              :label="item.projectName"
              :value="item.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="支出名称" prop="expenseName">
          <el-input v-model="form.expenseName" placeholder="请输入支出名称" />
        </el-form-item>
        <el-form-item label="预算" prop="budgetId">
          <el-select v-model="form.budgetId" placeholder="请选择预算" @change="handleBudgetChange">
            <el-option
              v-for="item in budgetOptions"
              :key="item.id"
              :label="item.budgetName + '（剩余' + item.remainingAmount + '元）'"
              :value="item.id"
            ></el-option>
          </el-select>
        </el-form-item>

        <el-divider content-position="left">各类型支出金额</el-divider>

        <el-form-item label="材料费" prop="materialAmount">
          <el-input-number v-model="form.materialAmount" :precision="2" :min="0" :step="100" @change="calculateTotal" />
          <span v-if="selectedBudget.materialAmount" class="amount-limit">限额: {{ selectedBudget.materialAmount }}</span>
        </el-form-item>
        <el-form-item label="差旅费" prop="travelAmount">
          <el-input-number v-model="form.travelAmount" :precision="2" :min="0" :step="100" @change="calculateTotal" />
          <span v-if="selectedBudget.travelAmount" class="amount-limit">限额: {{ selectedBudget.travelAmount }}</span>
        </el-form-item>
        <el-form-item label="会议费" prop="meetingAmount">
          <el-input-number v-model="form.meetingAmount" :precision="2" :min="0" :step="100" @change="calculateTotal" />
          <span v-if="selectedBudget.meetingAmount" class="amount-limit">限额: {{ selectedBudget.meetingAmount }}</span>
        </el-form-item>
        <el-form-item label="印刷费" prop="printAmount">
          <el-input-number v-model="form.printAmount" :precision="2" :min="0" :step="100" @change="calculateTotal" />
          <span v-if="selectedBudget.printAmount" class="amount-limit">限额: {{ selectedBudget.printAmount }}</span>
        </el-form-item>
        <el-form-item label="其他费用" prop="otherAmount">
          <el-input-number v-model="form.otherAmount" :precision="2" :min="0" :step="100" @change="calculateTotal" />
          <span v-if="selectedBudget.otherAmount" class="amount-limit">限额: {{ selectedBudget.otherAmount }}</span>
        </el-form-item>
        <el-form-item label="合计金额">
          <el-input v-model="totalAmount" readonly :disabled="true" />
        </el-form-item>

        <el-form-item label="支出日期" prop="expenseDate">
          <el-date-picker
            v-model="form.expenseDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="支出说明" prop="expenseDesc">
          <el-input v-model="form.expenseDesc" type="textarea" placeholder="请输入支出说明" />
        </el-form-item>
        <el-form-item label="上传票据" prop="fileUrl">
          <el-upload
            class="upload-demo"
            :action="uploadFileUrl"
            :headers="headers"
            :file-list="fileList"
            :on-success="handleFileSuccess"
            :before-upload="beforeFileUpload"
            :on-remove="handleFileRemove"
            :limit="1"
            :on-exceed="handleExceed"
            list-type="picture-card"
            accept=".jpg,.jpeg,.png"
          >
            <i v-if="!form.fileUrl && fileList.length === 0" class="el-icon-plus"></i>
            <div slot="tip" class="el-upload__tip">只能上传jpg/jpeg/png格式的票据文件，且不超过10MB</div>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm(false)">保存草稿</el-button>
        <el-button type="success" @click="submitForm(true)">保存并提交</el-button>
      </div>
    </el-dialog>

    <!-- 查看支出对话框 -->
    <el-dialog title="支出详情" :visible.sync="viewOpen" width="600px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="项目名称">{{ viewForm.projectName }}</el-descriptions-item>
        <el-descriptions-item label="支出名称">{{ viewForm.expenseName }}</el-descriptions-item>
<!--        <el-descriptions-item label="支出类型">-->
<!--          <dict-tag :options="expenseTypeOptions" :value="viewForm.expenseType"/>-->
<!--        </el-descriptions-item>-->
        <el-descriptions-item label="支出金额">{{ viewForm.expenseAmount }}</el-descriptions-item>
        <el-descriptions-item label="支出日期">{{ parseTime(viewForm.expenseDate, '{y}-{m}-{d}') }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="statusOptions" :value="viewForm.status"/>
        </el-descriptions-item>
        <el-descriptions-item label="创建人">{{ viewForm.createByName }}</el-descriptions-item>
        <el-descriptions-item :span="2" label="支出说明">{{ viewForm.expenseDesc }}</el-descriptions-item>
        <el-descriptions-item :span="2" label="票据附件" v-if="viewForm.fileUrl">
          <el-image
            style="max-width: 100%; max-height: 300px"
            :src="viewForm.fileUrl"
            :preview-src-list="[viewForm.fileUrl]">
          </el-image>
        </el-descriptions-item>
        <el-descriptions-item v-if="viewForm.approveByName" label="审批人">{{ viewForm.approveByName }}</el-descriptions-item>
        <el-descriptions-item v-if="viewForm.approveTime" label="审批时间">{{ parseTime(viewForm.approveTime) }}</el-descriptions-item>
        <el-descriptions-item v-if="viewForm.approveDesc" :span="2" label="审批说明">{{ viewForm.approveDesc }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>

    <!-- 审批对话框 -->
    <el-dialog :title="isApprove ? '批准' : '拒绝'" :visible.sync="approveOpen" width="500px" append-to-body>
      <el-form ref="approveForm" :model="approveForm" :rules="approveRules" label-width="100px">
        <el-form-item label="审批说明" prop="approveDesc">
          <el-input v-model="approveForm.approveDesc" type="textarea" placeholder="请输入审批说明" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="approveOpen = false">取 消</el-button>
        <el-button type="primary" @click="submitApprove">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 学校审批对话框 -->
    <el-dialog :title="isApprove ? '学校批准' : '学校拒绝'" :visible.sync="schoolApproveOpen" width="500px" append-to-body>
      <el-form ref="schoolApproveForm" :model="schoolApproveForm" :rules="approveRules" label-width="100px">
        <el-form-item label="审批说明" prop="schoolApproveDesc">
          <el-input v-model="schoolApproveForm.schoolApproveDesc" type="textarea" placeholder="请输入审批说明" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="schoolApproveOpen = false">取 消</el-button>
        <el-button type="primary" @click="submitSchoolApprove">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listFundExpense, getFundExpense, addFundExpense, updateFundExpense, delFundExpense, submitFundExpense, approveFundExpense, markAsPaidFundExpense } from "@/api/fundExpense";
import { schoolApproveFundExpense } from "@/api/fund";
import { listInnoProject } from "@/api/innoProject";
import { listFundBudget } from "@/api/fundBudget";
import { getToken } from "@/utils/auth";

export default {
  name: "ExpenseTab",
  filters: {
    budgetTypeFilter(type) {
      const typeMap = {
        'MATERIAL': '材料费',
        'TRAVEL': '差旅费',
        'MEETING': '会议费',
        'PRINT': '印刷费',
        'OTHER': '其他费用'
      }
      return typeMap[type] || type
    }
  },
  data() {
    return {
      // 是否为教师角色
      isTeacherRole: false,
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 提交操作禁用
      submitDisabled: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 支出表格数据
      expenseList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否显示查看弹出层
      viewOpen: false,
      // 是否显示审批弹出层
      approveOpen: false,
      // 是否显示学校审批弹出层
      schoolApproveOpen: false,
      // 是否为批准操作
      isApprove: true,
      // 查看表单
      viewForm: {},
      // 审批表单
      approveForm: {
        id: null,
        approveDesc: ""
      },
      // 学校审批表单
      schoolApproveForm: {
        id: null,
        schoolApproveDesc: ""
      },
      // 项目选项
      projectOptions: [],
      // 预算选项
      budgetOptions: [],
      // 文件列表
      fileList: [],
      // 上传地址
      uploadFileUrl: process.env.VUE_APP_BASE_API + "/common/upload",
      // 上传头
      headers: {
        Authorization: "Bearer " + getToken()
      },
      // 支出类型选项
      expenseTypeOptions: [
        { value: "MATERIAL", label: "材料费", raw: { listClass: 'primary', cssClass: '' } },
        { value: "TRAVEL", label: "差旅费", raw: { listClass: 'success', cssClass: '' } },
        { value: "MEETING", label: "会议费", raw: { listClass: 'info', cssClass: '' } },
        { value: "PRINT", label: "印刷费", raw: { listClass: 'warning', cssClass: '' } },
        { value: "OTHER", label: "其他费用", raw: { listClass: 'danger', cssClass: '' } }
      ],
      // 状态选项
      statusOptions: [
        { value: "DRAFT", label: "草稿",raw: { listClass: 'primary', cssClass: '' } },
        { value: "SUBMITTED", label: "已提交",raw: { listClass: 'primary', cssClass: '' } },
        { value: "APPROVED", label: "已批准",raw: { listClass: 'primary', cssClass: '' } },
        { value: "REJECTED", label: "已拒绝",raw: { listClass: 'primary', cssClass: '' } },
        { value: "PAID", label: "已支付",raw: { listClass: 'primary', cssClass: '' } }
      ],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        projectName: null,
        expenseType: null,
        status: null
      },
      // 合计金额
      totalAmount: 0,

      // 已选预算
      selectedBudget: {},

      // 表单参数
      form: {
        id: null,
        projectId: null,
        expenseName: null,
        budgetId: null,
        expenseType: null,
        expenseAmount: 0,
        materialAmount: 0,
        travelAmount: 0,
        meetingAmount: 0,
        printAmount: 0,
        otherAmount: 0,
        expenseDesc: null,
        expenseDate: null,
        fileUrl: null,
        status: null
      },
      // 表单校验
      rules: {
        projectId: [
          { required: true, message: "项目不能为空", trigger: "blur" }
        ],
        expenseName: [
          { required: true, message: "支出名称不能为空", trigger: "blur" }
        ],
        budgetId: [
          { required: true, message: "预算不能为空", trigger: "blur" }
        ],
        expenseType: [
          { required: true, message: "支出类型不能为空", trigger: "blur" }
        ],
        expenseAmount: [
          { required: true, message: "支出金额不能为空", trigger: "blur" }
        ],
        expenseDate: [
          { required: true, message: "支出日期不能为空", trigger: "blur" }
        ]
      },
      // 审批表单校验
      approveRules: {
        approveDesc: [
          { required: true, message: "审批说明不能为空", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
    this.getProjectOptions();
    this.checkUserRole();
  },
  methods: {
    /** 检查用户角色 */
    checkUserRole() {
      // 通过读取用户角色信息，判断是否为教师角色
      const roles = this.$store.getters && this.$store.getters.roles;
      this.isTeacherRole = roles.includes('teacher');
    },
    /** 查询支出列表 */
    getList() {
      this.loading = true;
      listFundExpense(this.queryParams).then(response => {
        this.expenseList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 获取项目选项 */
    getProjectOptions() {
      listInnoProject({ status: 'APPROVED' }).then(response => {
        if (response.rows && response.rows.length > 0) {
          this.projectOptions = response.rows;
          console.log("加载项目列表成功:", this.projectOptions);
        } else {
          console.warn("没有找到已批准的项目");
          // 尝试获取所有项目
          listInnoProject().then(allResponse => {
            this.projectOptions = allResponse.rows || [];
            console.log("加载所有项目:", this.projectOptions);
          });
        }
      }).catch(error => {
        console.error("加载项目列表失败:", error);
      });
    },
    /** 获取预算选项 */
    getBudgetOptions(projectId) {
      console.log("获取项目预算，项目ID:", projectId);

      if (!projectId) {
        this.budgetOptions = [];
        return;
      }

      // 只获取已批准状态的预算
      listFundBudget({ projectId: projectId, status: 'APPROVED' }).then(response => {
        console.log("获取到预算列表:", response.rows);
        this.budgetOptions = response.rows || [];
      }).catch(error => {
        console.error("获取预算列表失败:", error);
        this.$message.error("获取预算列表失败");
      });
    },
    /** 处理项目变更 */
    handleProjectChange(val) {
      this.form.budgetId = null;
      this.getBudgetOptions(val);
    },
    /** 处理预算变更 */
    handleBudgetChange(budgetId) {
      if (budgetId) {
        const budget = this.budgetOptions.find(item => item.id === budgetId);
        if (budget) {
          this.selectedBudget = budget;
          // 重置各类型金额
          this.form.materialAmount = 0;
          this.form.travelAmount = 0;
          this.form.meetingAmount = 0;
          this.form.printAmount = 0;
          this.form.otherAmount = 0;
          this.calculateTotal();
        }
      } else {
        this.selectedBudget = {};
      }
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
        projectId: null,
        expenseName: null,
        budgetId: null,
        expenseType: null,
        expenseAmount: 0,
        materialAmount: 0,
        travelAmount: 0,
        meetingAmount: 0,
        printAmount: 0,
        otherAmount: 0,
        expenseDesc: null,
        expenseDate: null,
        fileUrl: null,
        status: null
      };
      this.totalAmount = 0;
      this.selectedBudget = {};
      this.fileList = [];
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
    /** 文件上传成功处理 */
    handleFileSuccess(response, file, fileList) {
      console.log("票据上传成功，返回数据:", response);
      if (response.code === 200) {
        // 直接保存后端返回的文件URL
        this.form.fileUrl = response.url || response.data;
        console.log("设置fileUrl成功:", this.form.fileUrl);

        // 确保fileList中的文件也有正确的URL
        if (fileList && fileList.length > 0) {
          fileList[0].url = this.form.fileUrl;
        }

        this.$message.success('票据上传成功');
      } else {
        this.$message.error('票据上传失败: ' + response.msg);
      }
      this.fileList = fileList;
    },
    /** 文件删除处理 - el-upload组件触发 */
    handleFileRemove(file, fileList) {
      this.form.fileUrl = null;
      this.fileList = [];
    },
    /** 手动删除文件 - 按钮触发 */
    handleManualRemove() {
      this.form.fileUrl = null;
      this.fileList = [];
      this.$message.success('票据已删除');
    },
    /** 文件上传前检查 */
    beforeFileUpload(file) {
      const isValidFormat = file.type === 'image/jpeg' || file.type === 'image/png' || file.type === 'image/jpg';
      const isLt10M = file.size / 1024 / 1024 < 10;

      if (!isValidFormat) {
        this.$message.error('只能上传JPG/JPEG/PNG格式的票据文件!');
        return false;
      }
      if (!isLt10M) {
        this.$message.error('上传票据文件大小不能超过10MB!');
        return false;
      }
      return true;
    },
    /** 超出文件上传限制处理 */
    handleExceed(files, fileList) {
      this.$message.warning('最多只能上传1张票据图片，请先删除已有票据后再上传');
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      console.log("新增初始化form:", JSON.stringify(this.form));
      console.log("新增初始化fileList:", this.fileList);
      this.open = true;
      this.title = "添加支出";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getFundExpense(id).then(response => {
        this.form = response.data;
        this.form.materialAmount = this.form.materialAmount || 0;
        this.form.travelAmount = this.form.travelAmount || 0;
        this.form.meetingAmount = this.form.meetingAmount || 0;
        this.form.printAmount = this.form.printAmount || 0;
        this.form.otherAmount = this.form.otherAmount || 0;
        this.calculateTotal();

        if (this.form.fileUrl) {
          this.fileList = [
            { name: "票据文件", url: this.form.fileUrl }
          ];
        }
        this.open = true;
        this.title = "修改支出";

        // 加载预算选项
        this.getBudgetOptions(this.form.projectId);
        if (this.form.budgetId) {
          setTimeout(() => {
            this.handleBudgetChange(this.form.budgetId);
          }, 500);
        }
      });
    },
    /** 查看按钮操作 */
    handleView(row) {
      getFundExpense(row.id).then(response => {
        this.viewForm = response.data;
        // 确保项目名称显示
        if (!this.viewForm.projectName && row.projectName) {
          this.viewForm.projectName = row.projectName;
        }
        console.log("查看支出详情:", this.viewForm);
        this.viewOpen = true;
      });
    },
    /** 提交按钮操作 */
    handleSubmit(row) {
      const id = row.id || this.ids[0];
      // 先获取完整的支出数据(包含fileUrl)
      getFundExpense(id).then(response => {
        const expenseData = response.data;
        this.$modal.confirm('是否确认提交该支出？').then(() => {
          return submitFundExpense(id);
        }).then(() => {
          this.getList();
          this.$modal.msgSuccess("提交成功");
        }).catch(error => {
          // 只有当error不是空对象时才显示错误信息（用户取消不会有具体错误对象）
          if (error && (error.message || error.stack || error.name)) {
            console.error("提交支出失败:", error);
            this.$message.error("提交支出失败，请检查网络或联系管理员");
          }
        });
      }).catch(error => {
        console.error("获取支出详情失败:", error);
        this.$message.error("获取支出详情失败，请检查网络或联系管理员");
      });
    },
    /** 审批按钮操作 */
    handleApprove(row, isApprove) {
      this.approveForm = {
        id: row.id,
        approveDesc: ""
      };
      this.isApprove = isApprove;
      this.approveOpen = true;
    },
    /** 学校审批按钮操作 */
    handleSchoolApprove(row, isApprove) {
      this.schoolApproveForm = {
        id: row.id,
        schoolApproveDesc: ""
      };
      this.isApprove = isApprove;
      this.schoolApproveOpen = true;
    },
    /** 计算合计金额 */
    calculateTotal() {
      let total = 0;
      total += parseFloat(this.form.materialAmount || 0);
      total += parseFloat(this.form.travelAmount || 0);
      total += parseFloat(this.form.meetingAmount || 0);
      total += parseFloat(this.form.printAmount || 0);
      total += parseFloat(this.form.otherAmount || 0);
      this.totalAmount = total.toFixed(2);
    },
    /** 提交审批 */
    submitApprove() {
      this.$refs["approveForm"].validate(valid => {
        if (valid) {
          approveFundExpense(this.isApprove, this.approveForm).then(response => {
            this.$modal.msgSuccess(this.isApprove ? "批准成功" : "拒绝成功");
            this.approveOpen = false;
            this.getList();
          });
        }
      });
    },
    /** 提交学校审批 */
    submitSchoolApprove() {
      this.$refs["schoolApproveForm"].validate(valid => {
        if (valid) {
          schoolApproveFundExpense(this.isApprove, this.schoolApproveForm).then(response => {
            this.$modal.msgSuccess(this.isApprove ? "学校批准成功" : "学校拒绝成功");
            this.schoolApproveOpen = false;
            this.getList();
          });
        }
      });
    },
    /** 提交按钮 */
    submitForm(isSubmit) {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 设置支出金额为合计金额
          this.form.expenseAmount = parseFloat(this.totalAmount);

          if (this.form.id != null) {
            updateFundExpense(this.form, isSubmit).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addFundExpense(this.form, isSubmit).then(response => {
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
      this.$modal.confirm('是否确认删除选中的支出？').then(function() {
        return delFundExpense(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.upload-demo .el-upload-list--picture-card .el-upload-list__item-actions {
  cursor: default;
}

.amount-limit {
  margin-left: 10px;
  color: #909399;
  font-size: 12px;
}
</style>

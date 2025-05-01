<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="项目名称" prop="projectName">
        <el-input v-model="queryParams.projectName" placeholder="请输入项目名称" clearable size="small" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="支付方式" prop="paymentMethod">
        <el-select v-model="queryParams.paymentMethod" placeholder="请选择支付方式" clearable size="small">
          <el-option v-for="dict in paymentMethodOptions" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="支付日期" prop="paymentDate">
        <el-date-picker
          v-model="queryParams.paymentDate"
          type="date"
          placeholder="选择日期"
          value-format="yyyy-MM-dd"
          clearable
          size="small"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="paymentList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="项目名称" align="center" prop="projectName" :show-overflow-tooltip="true" />
      <el-table-column label="支付金额" align="center" prop="paymentAmount" />
      <el-table-column label="支付方式" align="center" prop="paymentMethod">
        <template slot-scope="scope">
          {{ getDictLabel(paymentMethodOptions, scope.row.paymentMethod) }}
        </template>
      </el-table-column>
      <el-table-column label="支出类型" align="center">
        <template slot-scope="scope">
          <span v-if="scope.row.expense && scope.row.expense.expenseType">
            {{ getExpenseTypeText(scope.row.expense.expenseType) }}
          </span>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="支付日期" align="center" prop="paymentDate" width="100">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.paymentDate, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="支付说明" align="center" prop="paymentDesc" :show-overflow-tooltip="true" />
      <el-table-column label="创建时间" align="center" prop="createTime" width="100">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button size="mini" type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
          <el-button v-if="scope.row.buttonList && scope.row.buttonList.includes('删除')" size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
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

    <!-- 添加支付记录对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="支出申请" prop="expenseId">
          <el-select v-model="form.expenseId" placeholder="请选择支出申请" filterable>
            <el-option
              v-for="item in expenseOptions"
              :key="item.id"
              :label="`${item.projectName} - ${item.expenseType | expenseTypeFilter} - ${item.expenseAmount}元`"
              :value="item.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="支付金额" prop="paymentAmount">
          <el-input-number v-model="form.paymentAmount" :precision="2" :min="0" :step="100" />
        </el-form-item>
        <el-form-item label="支付日期" prop="paymentDate">
          <el-date-picker
            v-model="form.paymentDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd"
          ></el-date-picker>
        </el-form-item>
        <el-form-item label="支付方式" prop="paymentMethod">
          <el-select v-model="form.paymentMethod" placeholder="请选择支付方式">
            <el-option
              v-for="dict in paymentMethodOptions"
              :key="dict.value"
              :label="dict.label"
              :value="dict.value"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="支付说明" prop="paymentDesc">
          <el-input v-model="form.paymentDesc" type="textarea" placeholder="请输入支付说明" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 查看支付记录对话框 -->
    <el-dialog title="支付记录详情" :visible.sync="viewOpen" width="600px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="项目名称">{{ viewForm.projectName }}</el-descriptions-item>
        <el-descriptions-item label="支付金额">{{ viewForm.paymentAmount }}</el-descriptions-item>
        <el-descriptions-item label="支付方式">
          <span>{{ getDictLabel(paymentMethodOptions, viewForm.paymentMethod) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="支付日期">{{ parseTime(viewForm.paymentDate, '{y}-{m}-{d}') }}</el-descriptions-item>
        <el-descriptions-item label="创建人">{{ viewForm.createByName }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ parseTime(viewForm.createTime) }}</el-descriptions-item>
        <el-descriptions-item :span="2" label="支付说明">{{ viewForm.paymentDesc }}</el-descriptions-item>
        <template v-if="viewForm.expense">
          <el-divider content-position="center">相关支出信息</el-divider>
          <el-descriptions-item label="支出类型">
            <span>{{ getExpenseTypeText(viewForm.expense.expenseType) }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="支出金额">{{ viewForm.expense.expenseAmount || '-' }}</el-descriptions-item>
          <el-descriptions-item label="支出日期">
            <span v-if="viewForm.expense.expenseDate">{{ parseTime(viewForm.expense.expenseDate, '{y}-{m}-{d}') }}</span>
            <span v-else>-</span>
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <span>{{ getStatusText(viewForm.expense.status) }}</span>
          </el-descriptions-item>
          <el-descriptions-item :span="2" label="支出说明">{{ viewForm.expense.expenseDesc || '-' }}</el-descriptions-item>
        </template>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
import { listFundPayment, getFundPayment, addFundPayment, delFundPayment } from "@/api/fundPayment";
import { listFundExpense } from "@/api/fundExpense";

export default {
  name: "PaymentTab",
  filters: {
    expenseTypeFilter(type) {
      const typeMap = {
        'MATERIAL': '材料费',
        'TRAVEL': '差旅费',
        'MEETING': '会议费',
        'PRINT': '印刷费',
        'OTHER': '其他费用'
      }
      return typeMap[type] || type
    },
    paymentMethodFilter(method) {
      const methodMap = {
        'CASH': '现金',
        'BANK': '银行转账',
        'OTHER': '其他'
      }
      return methodMap[method] || method
    },
    statusFilter(status) {
      const statusMap = {
        'DRAFT': '草稿',
        'SUBMITTED': '已提交',
        'APPROVED': '已批准',
        'REJECTED': '已拒绝',
        'PAID': '已支付'
      }
      return statusMap[status] || status
    }
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 支付记录表格数据
      paymentList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否显示查看弹出层
      viewOpen: false,
      // 查看表单
      viewForm: {},
      // 支出选项
      expenseOptions: [],
      // 支付方式选项
      paymentMethodOptions: [
        { value: "CASH", label: "现金" },
        { value: "BANK", label: "银行转账" },
        { value: "OTHER", label: "其他" }
      ],
      // 支出类型选项
      expenseTypeOptions: [
        { value: "MATERIAL", label: "材料费" },
        { value: "TRAVEL", label: "差旅费" },
        { value: "MEETING", label: "会议费" },
        { value: "PRINT", label: "印刷费" },
        { value: "OTHER", label: "其他费用" }
      ],
      // 状态选项
      statusOptions: [
        { value: "DRAFT", label: "草稿" },
        { value: "SUBMITTED", label: "已提交" },
        { value: "APPROVED", label: "已批准" },
        { value: "REJECTED", label: "已拒绝" },
        { value: "PAID", label: "已支付" }
      ],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        projectName: null,
        paymentMethod: null,
        paymentDate: null
      },
      // 表单参数
      form: {
        id: null,
        expenseId: null,
        paymentAmount: 0,
        paymentDate: null,
        paymentMethod: null,
        paymentDesc: null
      },
      // 表单校验
      rules: {
        expenseId: [
          { required: true, message: "支出申请不能为空", trigger: "change" }
        ],
        paymentAmount: [
          { required: true, message: "支付金额不能为空", trigger: "blur" }
        ],
        paymentDate: [
          { required: true, message: "支付日期不能为空", trigger: "blur" }
        ],
        paymentMethod: [
          { required: true, message: "支付方式不能为空", trigger: "change" }
        ]
      }
    };
  },
  created() {
    this.getList();
    this.getExpenseOptions();
  },
  methods: {
    /** 查询支付记录列表 */
    getList() {
      this.loading = true;
      listFundPayment(this.queryParams).then(response => {
        this.paymentList = response.rows;
        console.log("支付记录列表:", this.paymentList);
        this.total = response.total;
        this.loading = false;
      }).catch(error => {
        console.error("获取支付记录列表失败:", error);
        this.loading = false;
      });
    },
    /** 获取支出选项 */
    getExpenseOptions() {
      listFundExpense({ status: 'APPROVED' }).then(response => {
        this.expenseOptions = response.rows;
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
        expenseId: null,
        paymentAmount: 0,
        paymentDate: null,
        paymentMethod: null,
        paymentDesc: null
      };
      this.resetForm("form");
    },
    /** 获取字典标签文本 */
    getDictLabel(options, value) {
      if (!value) return '-';
      const option = options.find(opt => opt.value === value);
      return option ? option.label : value;
    },
    /** 获取支出类型文本 */
    getExpenseTypeText(type) {
      return this.$options.filters.expenseTypeFilter(type) || '-';
    },
    /** 获取状态文本 */
    getStatusText(status) {
      return this.$options.filters.statusFilter(status) || '-';
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
      this.ids = selection.map(item => item.id);
      this.multiple = !selection.length;
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加支付记录";
    },
    /** 查看按钮操作 */
    handleView(row) {
      getFundPayment(row.id).then(response => {
        this.viewForm = response.data;
        console.log("支付记录详情：", this.viewForm);
        
        // 确保项目名称显示
        if (!this.viewForm.projectName && row.projectName) {
          this.viewForm.projectName = row.projectName;
        }
        
        // 确保支出信息完整
        if (this.viewForm.expense) {
          // 支出信息已加载，直接显示
          console.log("支出信息已加载:", this.viewForm.expense);
          if (this.viewForm.expense.expenseType) {
            console.log("支出类型:", this.viewForm.expense.expenseType);
          }
          this.viewOpen = true;
        } else if (this.viewForm.expenseId) {
          // 需要加载支出信息
          console.log("加载支出信息，ID:", this.viewForm.expenseId);
          listFundExpense({ id: this.viewForm.expenseId }).then(expResponse => {
            if (expResponse.rows && expResponse.rows.length > 0) {
              this.viewForm.expense = expResponse.rows[0];
              console.log("加载到的支出信息:", this.viewForm.expense);
            } else {
              console.log("未找到支出信息");
            }
            this.viewOpen = true;
          }).catch(error => {
            console.error("获取支出信息失败:", error);
            this.viewOpen = true;
          });
        } else {
          console.log("无支出ID，无法加载支出信息");
          this.viewOpen = true;
        }
      }).catch(error => {
        console.error("获取支付记录详情失败:", error);
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          addFundPayment(this.form).then(response => {
            this.$modal.msgSuccess("新增成功");
            this.open = false;
            this.getList();
          });
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除选中的支付记录？').then(function() {
        return delFundPayment(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>

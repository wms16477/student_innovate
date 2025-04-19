<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="供应商编号" prop="supplierCode">
        <el-input
          v-model="queryParams.supplierCode"
          placeholder="请输入供应商编号"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="供应商名称" prop="supplierName">
        <el-input
          v-model="queryParams.supplierName"
          placeholder="请输入供应商名称"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="供应商类型" prop="supplierType">
        <el-select v-model="queryParams.supplierType" placeholder="请选择供应商类型" clearable size="small">
          <el-option
            v-for="dict in typeOptions"
            :key="dict.dictValue"
            :label="dict.dictLabel"
            :value="dict.dictValue"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="审核状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="请选择审核状态" clearable size="small">
          <el-option
            v-for="dict in statusOptions"
            :key="dict.dictValue"
            :label="dict.dictLabel"
            :value="dict.dictValue"
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
          v-hasPermi="['system:supplier:add']"
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
          v-hasPermi="['system:supplier:edit']"
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
          v-hasPermi="['system:supplier:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="supplierList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="供应商编号" align="center" prop="supplierCode" />
      <el-table-column label="供应商名称" align="center" prop="supplierName" />
      <el-table-column label="联系电话" align="center" prop="phone" />
      <el-table-column label="地址" align="center" prop="address" :show-overflow-tooltip="true" />
      <el-table-column label="供应商类型" align="center" prop="supplierType">
        <template slot-scope="scope">
          <dict-tag :options="typeOptions" :value="scope.row.supplierType"/>
        </template>
      </el-table-column>
      <el-table-column label="审核状态" align="center" prop="status">
        <template slot-scope="scope">
          <dict-tag :options="statusOptions" :value="scope.row.status"/>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:supplier:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:supplier:remove']"
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

    <!-- 添加或修改供应商抽屉 -->
    <el-drawer :title="title" :visible.sync="open" direction="rtl" size="50%" :before-close="handleClose">
      <div class="drawer-container">


        <!-- 基础信息 -->
        <el-form ref="form" :model="form" :rules="rules" label-width="100px">
          <div class="section-title">基础信息</div>
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="供应商名称" prop="supplierName">
                <el-input v-model="form.supplierName" placeholder="请输入供应商名称" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="供应商类型" prop="supplierType">
                <el-select v-model="form.supplierType" placeholder="请选择供应商类型">
                  <el-option
                    v-for="dict in typeOptions"
                    :key="dict.dictValue"
                    :label="dict.dictLabel"
                    :value="dict.dictValue"
                  />
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="公司LOGO" prop="logo">
                <el-upload
                  class="avatar-uploader"
                  action="/dev-api/common/upload"
                  :show-file-list="false"
                  :on-success="handleLogoSuccess"
                  :before-upload="beforeLogoUpload">
                  <img v-if="form.logo" :src="form.logo" class="avatar">
                  <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
              </el-form-item>
            </el-col>
          </el-row>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="统一社会信用代码" prop="creditCode">
                <el-input v-model="form.creditCode" placeholder="请输入统一社会信用代码" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="成立时间" prop="establishTime">
                <el-date-picker v-model="form.establishTime" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" style="width: 100%" />
              </el-form-item>
            </el-col>
          </el-row>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="注册资本" prop="registeredCapital">
                <el-input v-model="form.registeredCapital" placeholder="请输入注册资本">
                  <template slot="append">万元</template>
                </el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="企业性质" prop="enterpriseNature">
                <el-select v-model="form.enterpriseNature" placeholder="请选择企业性质" style="width: 100%">
                  <el-option
                    v-for="item in enterpriseNatureOptions"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="企业规模" prop="enterpriseSize">
                <el-select v-model="form.enterpriseSize" placeholder="请选择企业规模" style="width: 100%">
                  <el-option
                    v-for="item in enterpriseSizeOptions"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="供应商等级" prop="supplierLevel">
                <el-select v-model="form.supplierLevel" placeholder="请选择供应商等级" style="width: 100%">
                  <el-option
                    v-for="item in supplierLevelOptions"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="法人姓名" prop="legalPerson">
                <el-input v-model="form.legalPerson" placeholder="请输入法人姓名" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="法人身份证号" prop="legalPersonId">
                <el-input v-model="form.legalPersonId" placeholder="请输入法人身份证号" />
              </el-form-item>
            </el-col>
          </el-row>

          <el-form-item label="所属区域" prop="region">
            <el-cascader
              v-model="form.region"
              :options="regionOptions"
              :props="{ checkStrictly: true }"
              style="width: 100%"
              clearable
            />
          </el-form-item>

          <el-form-item label="详细地址" prop="businessAddress">
            <el-input v-model="form.businessAddress" type="textarea" :rows="2" placeholder="请输入详细地址" />
          </el-form-item>

          <div class="section-title">联系人信息</div>
          
          <el-table :data="form.contacts" border style="width: 100%">
            <el-table-column label="姓名" align="center" prop="name">
              <template slot-scope="scope">
                <el-form-item :prop="'contacts.' + scope.$index + '.name'" :rules="contactRules.name" style="margin-bottom: 0;">
                  <el-input v-model="scope.row.name" placeholder="请输入姓名" />
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="职务" align="center" prop="position">
              <template slot-scope="scope">
                <el-form-item :prop="'contacts.' + scope.$index + '.position'" :rules="contactRules.position" style="margin-bottom: 0;">
                  <el-input v-model="scope.row.position" placeholder="请输入职务" />
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="手机号码" align="center" prop="phone">
              <template slot-scope="scope">
                <el-form-item :prop="'contacts.' + scope.$index + '.phone'" :rules="contactRules.phone" style="margin-bottom: 0;">
                  <el-input v-model="scope.row.phone" placeholder="请输入手机号码" />
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="邮箱" align="center" prop="email">
              <template slot-scope="scope">
                <el-form-item :prop="'contacts.' + scope.$index + '.email'" :rules="contactRules.email" style="margin-bottom: 0;">
                  <el-input v-model="scope.row.email" placeholder="请输入邮箱" />
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" width="150">
              <template slot-scope="scope">
                <el-button size="mini" type="danger" @click="removeContact(scope.$index)" :disabled="form.contacts.length <= 1">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <div style="text-align: center; margin-top: 10px;">
            <el-button type="primary" @click="addContact">添加联系人</el-button>
          </div>

          <div class="section-title">发票信息</div>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="发票抬头" prop="invoiceTitle">
                <el-input v-model="form.invoiceTitle" placeholder="请输入发票抬头" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="税号" prop="taxNumber">
                <el-input v-model="form.taxNumber" placeholder="请输入税号" />
              </el-form-item>
            </el-col>
          </el-row>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="开户行" prop="bankName">
                <el-input v-model="form.bankName" placeholder="请输入开户行" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="银行账号" prop="bankAccount">
                <el-input v-model="form.bankAccount" placeholder="请输入银行账号" />
              </el-form-item>
            </el-col>
          </el-row>

          <el-form-item label="发票地址" prop="invoiceAddress">
            <el-input v-model="form.invoiceAddress" type="textarea" :rows="2" placeholder="请输入发票地址" />
          </el-form-item>

          <el-form-item label="营业范围" prop="businessScope">
            <el-input v-model="form.businessScope" type="textarea" :rows="3" placeholder="请输入营业范围" />
          </el-form-item>


          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="发票抬头" prop="invoiceTitle">
                <el-input v-model="form.invoiceTitle" placeholder="请输入发票抬头" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="税号" prop="taxNumber">
                <el-input v-model="form.taxNumber" placeholder="请输入税号" />
              </el-form-item>
            </el-col>
          </el-row>

          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="开户行" prop="bankName">
                <el-input v-model="form.bankName" placeholder="请输入开户行" />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="银行账号" prop="bankAccount">
                <el-input v-model="form.bankAccount" placeholder="请输入银行账号" />
              </el-form-item>
            </el-col>
          </el-row>

          <el-form-item label="发票地址" prop="invoiceAddress">
            <el-input v-model="form.invoiceAddress" type="textarea" :rows="2" placeholder="请输入发票地址" />
          </el-form-item>
        </el-form>

        <div class="drawer-footer">
          <el-button @click="handleClose">取 消</el-button>
          <el-button type="primary" @click="submitForm">提 交</el-button>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import { listSupplier, getSupplier, delSupplier, addSupplier, updateSupplier } from "@/api/system/supplier";

export default {
  name: "Supplier",
  data() {
    return {

      // 区域选项
      regionOptions: [],
      // 企业性质选项
      enterpriseNatureOptions: [
        { value: '1', label: '国有企业' },
        { value: '2', label: '民营企业' },
        { value: '3', label: '合资企业' },
        { value: '4', label: '外资企业' }
      ],
      // 企业规模选项
      enterpriseSizeOptions: [
        { value: '1', label: '大型企业' },
        { value: '2', label: '中型企业' },
        { value: '3', label: '小型企业' },
        { value: '4', label: '微型企业' }
      ],
      // 供应商等级选项
      supplierLevelOptions: [
        { value: 'A', label: 'A级' },
        { value: 'B', label: 'B级' },
        { value: 'C', label: 'C级' },
        { value: 'D', label: 'D级' }
      ],
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
      // 供应商表格数据
      supplierList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 供应商类型字典
      typeOptions: [],
      // 状态字典
      statusOptions: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        supplierCode: null,
        supplierName: null,
        supplierType: null,
        status: null
      },
      // 表单参数
      form: {
        contacts: []
      },
      // 联系人表单校验规则
      contactRules: {
        name: [{ required: true, message: "联系人姓名不能为空", trigger: "blur" }],
        position: [{ required: true, message: "职务不能为空", trigger: "blur" }],
        phone: [
          { required: true, message: "联系电话不能为空", trigger: "blur" },
          { pattern: /^1[3|4|5|6|7|8|9][0-9]\d{8}$/, message: "请输入正确的手机号码", trigger: "blur" }
        ],
        email: [
          { required: true, message: "联系邮箱不能为空", trigger: "blur" },
          { type: "email", message: "请输入正确的邮箱地址", trigger: ["blur", "change"] }
        ]
      },
      // 表单校验
      rules: {
        supplierName: [
          { required: true, message: "供应商名称不能为空", trigger: "blur" }
        ],
        supplierType: [
          { required: true, message: "请选择供应商类型", trigger: "change" }
        ],
        creditCode: [
          { required: true, message: "统一社会信用代码不能为空", trigger: "blur" },
          { pattern: /^[0-9A-HJ-NPQRTUWXY]{2}\d{6}[0-9A-HJ-NPQRTUWXY]{10}$/, message: "请输入正确的统一社会信用代码", trigger: "blur" }
        ],
        establishTime: [
          { required: true, message: "成立时间不能为空", trigger: "change" }
        ],
        registeredCapital: [
          { required: true, message: "请输入注册资本", trigger: "blur" },
          { pattern: /^[0-9]+(.[0-9]{1,2})?$/, message: "请输入正确的金额格式", trigger: "blur" }
        ],
        enterpriseNature: [
          { required: true, message: "请选择企业性质", trigger: "change" }
        ],
        legalPerson: [
          { required: true, message: "法人姓名不能为空", trigger: "blur" }
        ],
        legalPersonId: [
          { required: true, message: "法人身份证号不能为空", trigger: "blur" },
          { pattern: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/, message: "请输入正确的身份证号码", trigger: "blur" }
        ],
        region: [
          { required: true, message: "所属区域不能为空", trigger: "change" }
        ],
        businessAddress: [
          { required: true, message: "详细地址不能为空", trigger: "blur" }
        ],
        invoiceTitle: [
          { required: true, message: "发票抬头不能为空", trigger: "blur" }
        ],
        taxNumber: [
          { required: true, message: "税号不能为空", trigger: "blur" }
        ],
        bankName: [
          { required: true, message: "开户行不能为空", trigger: "blur" }
        ],
        bankAccount: [
          { required: true, message: "银行账号不能为空", trigger: "blur" },
          { pattern: /^[0-9]{16,19}$/, message: "请输入正确的银行账号", trigger: "blur" }
        ],
        invoiceAddress: [
          { required: true, message: "发票地址不能为空", trigger: "blur" }
        ],
        businessScope: [
          { required: true, message: "请输入营业范围", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
    this.getDicts("supplier_type").then(response => {
      this.typeOptions = response.data;
    });
    this.getDicts("supplier_status").then(response => {
      this.statusOptions = response.data;
    });
  },
  methods: {
    // 上传文件相关方法
    handlePreview(file) {
      console.log(file);
    },
    handleRemove(file, fileList) {
      console.log(file, fileList);
    },
    handleExceed(files, fileList) {
      this.$message.warning(`当前限制选择 1 个文件`);
    },
    beforeRemove(file, fileList) {
      return this.$confirm(`确定移除 ${file.name}？`);
    },
    // 抽屉关闭前的回调
    handleClose(done) {
      this.$confirm('确认关闭？')
        .then(_ => {
          this.reset();
          this.open = false;
        })
        .catch(_ => {});
    },

    /** 查询供应商列表 */
    getList() {
      this.loading = true;
      listSupplier(this.queryParams).then(response => {
        this.supplierList = response.rows;
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
        supplierId: null,
        supplierName: null,
        supplierType: null,
        creditCode: null,
        establishTime: null,
        registeredCapital: null,
        enterpriseNature: null,
        legalPerson: null,
        legalPersonId: null,
        region: [],
        businessAddress: null,
        contacts: [{
          name: '',
          position: '',
          phone: '',
          email: ''
        }],
        invoiceTitle: null,
        taxNumber: null,
        bankName: null,
        bankAccount: null,
        invoiceAddress: null,
        businessScope: null
      };
      this.resetForm("form");
    },

    // 添加联系人
    addContact() {
      const newContact = {
        name: '',
        position: '',
        phone: '',
        email: ''
      };
      
      // 验证最后一个联系人的信息是否完整
      if (this.form.contacts.length > 0) {
        const lastContact = this.form.contacts[this.form.contacts.length - 1];
        if (!lastContact.name || !lastContact.position || !lastContact.phone || !lastContact.email) {
          this.$modal.msgError('请先完善当前联系人信息');
          return;
        }
        
        // 验证手机号格式
        if (!/^1[3|4|5|6|7|8|9][0-9]\d{8}$/.test(lastContact.phone)) {
          this.$modal.msgError('请输入正确的手机号码');
          return;
        }
        
        // 验证邮箱格式
        if (!/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(lastContact.email)) {
          this.$modal.msgError('请输入正确的邮箱地址');
          return;
        }
      }
      
      this.form.contacts.push(newContact);
    },

    // 删除联系人
    removeContact(index) {
      this.form.contacts.splice(index, 1);
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
      this.ids = selection.map(item => item.supplierId);
      this.single = selection.length!==1;
      this.multiple = !selection.length;
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加供应商";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const supplierId = row.supplierId || this.ids[0];
      getSupplier(supplierId).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改供应商";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.supplierId != null) {
            updateSupplier(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addSupplier(this.form).then(response => {
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
      const supplierIds = row.supplierId || this.ids;
      this.$modal.confirm('是否确认删除供应商编号为"' + supplierIds + '"的数据项？').then(function() {
        return delSupplier(supplierIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.section-title {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
  margin: 0 0 20px;
  position: relative;
  padding-left: 12px;
}

.section-title::before {
  content: '';
  width: 4px;
  height: 16px;
  background: #409EFF;
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
}

.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  line-height: 120px;
  text-align: center;
}

.avatar {
  width: 120px;
  height: 120px;
  display: block;
}

.el-table__empty-block {
  justify-content: center;
  min-height: 60px;
}

.el-table__empty-text {
  line-height: 60px;
}

.drawer-container {
  padding: 20px;
  height: calc(100% - 100px);
  overflow-y: auto;
}

.drawer-footer {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 20px;
  background: #fff;
  text-align: right;
  border-top: 1px solid #e8e8e8;
}
</style>
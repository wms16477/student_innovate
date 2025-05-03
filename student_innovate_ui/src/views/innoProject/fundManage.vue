<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" type="border-card">
      <el-tab-pane label="预算管理" name="budget">
        <budget-tab />
      </el-tab-pane>
      <el-tab-pane label="支出管理" name="expense">
        <expense-tab />
      </el-tab-pane>
      <el-tab-pane label="支付记录" name="payment" v-if="isSchoolRole">
        <payment-tab />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import BudgetTab from './fund/BudgetTab'
import ExpenseTab from './fund/ExpenseTab'
import PaymentTab from './fund/PaymentTab'

export default {
  name: "FundManage",
  components: {
    BudgetTab,
    ExpenseTab,
    PaymentTab
  },
  data() {
    return {
      activeTab: 'budget',
      isSchoolRole: false
    }
  },
  created() {
    this.checkUserRole();
  },
  methods: {
    /** 检查用户角色 */
    checkUserRole() {
      // 通过读取用户角色信息，判断是否为学校角色
      const roles = this.$store.getters && this.$store.getters.roles;
      this.isSchoolRole = roles.includes('school');
    }
  }
}
</script>

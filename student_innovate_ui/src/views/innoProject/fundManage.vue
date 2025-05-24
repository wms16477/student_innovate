<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" type="border-card">
      <el-tab-pane label="预算管理" name="budget">
        <budget-tab />
      </el-tab-pane>
      <el-tab-pane label="支出管理" name="expense">
        <expense-tab />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import BudgetTab from './fund/BudgetTab'
import ExpenseTab from './fund/ExpenseTab'

export default {
  name: "FundManage",
  components: {
    BudgetTab,
    ExpenseTab
  },
  data() {
    return {
      activeTab: 'budget'
    }
  }
}
</script>

<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" type="border-card" @tab-click="handleTabClick">
      <el-tab-pane label="预算管理" name="budget">
        <budget-tab />
      </el-tab-pane>
      <el-tab-pane label="支出管理" name="expense">
        <expense-tab />
      </el-tab-pane>
      <el-tab-pane label="支付记录" name="payment" v-if="isSchoolRole">
        <payment-tab />
      </el-tab-pane>
      <el-tab-pane label="经费分析" name="analysis">
        <analysis-tab ref="analysisTab" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import BudgetTab from './fund/BudgetTab'
import ExpenseTab from './fund/ExpenseTab'
import PaymentTab from './fund/PaymentTab'
import AnalysisTab from './fund/AnalysisTab'

export default {
  name: "FundManage",
  components: {
    BudgetTab,
    ExpenseTab,
    PaymentTab,
    AnalysisTab
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
    },
    
    /** 处理标签页切换 */
    handleTabClick(tab) {
      // 如果切换到经费分析标签
      if (tab.name === 'analysis') {
        // 给分析组件一点时间来准备
        setTimeout(() => {
          // 如果存在分析组件的引用
          if (this.$refs.analysisTab) {
            // 调用分析组件的方法来重新初始化图表
            this.$refs.analysisTab.resizeAndReinitCharts();
          }
        }, 100);
      }
    }
  }
}
</script>

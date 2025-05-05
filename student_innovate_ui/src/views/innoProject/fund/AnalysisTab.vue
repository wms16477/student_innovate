<template>
  <div class="fund-analysis-container">
    <!-- 项目选择器 -->
    <div class="project-selector">
      <el-select v-model="selectedProjectId" placeholder="请选择项目" @change="handleProjectChange">
        <el-option
          v-for="item in projectList"
          :key="item.id"
          :label="item.projectName"
          :value="item.id">
        </el-option>
      </el-select>
    </div>

    <!-- 经费概览卡片 -->
    <el-row :gutter="20" class="overview-cards" v-if="selectedProjectId">
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="card-title">预算总额</div>
          <div class="card-value">{{ formatMoney(overview.totalBudget) }} 元</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="card-title">已支出总额</div>
          <div class="card-value">{{ formatMoney(overview.totalExpense) }} 元</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="card-title">预算余额</div>
          <div class="card-value">{{ formatMoney(overview.remainingBudget) }} 元</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="card-title">预算使用率</div>
          <div class="card-value">{{ formatPercent(overview.budgetUsageRate) }}</div>
          <el-progress :percentage="overview.budgetUsageRate"
                       :color="getColorByRate(overview.budgetUsageRate)"></el-progress>
        </el-card>
      </el-col>
    </el-row>

    <!-- 待处理统计 -->
    <el-row :gutter="20" class="pending-cards" v-if="selectedProjectId">
      <el-col :span="12">
        <el-card shadow="hover">
          <div class="card-title">待审批支出</div>
          <div class="card-value">{{ formatMoney(overview.pendingExpense) }} 元</div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="hover">
          <div class="card-title">待支付支出</div>
          <div class="card-value">{{ formatMoney(overview.unpaidExpense) }} 元</div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 图表分析区域 -->
    <el-row :gutter="20" class="chart-area" v-if="selectedProjectId && isDataLoaded">
      <!-- 预算使用情况 -->
      <el-col :span="12">
        <el-card shadow="hover" class="chart-card">
          <div slot="header">
            <span>预算使用情况</span>
          </div>
          <div class="chart-container" ref="budgetUsageChart"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="hover" class="chart-card">
          <div slot="header">
            <span>支付情况</span>
          </div>
          <div class="chart-container" ref="paymentStatChart"></div>
        </el-card>
      </el-col>

    </el-row>


<!--    <el-row :gutter="20" class="chart-area" v-if="selectedProjectId && isDataLoaded">-->
<!--      &lt;!&ndash; 支出审批情况 &ndash;&gt;-->
<!--      <el-col :span="12">-->
<!--        <el-card shadow="hover" class="chart-card">-->
<!--          <div slot="header">-->
<!--            <span>支出审批情况</span>-->
<!--          </div>-->
<!--          <div class="chart-container" ref="approvalStatChart"></div>-->
<!--        </el-card>-->
<!--      </el-col>-->

<!--      &lt;!&ndash; 支付情况 &ndash;&gt;-->
<!--      <el-col :span="12">-->
<!--        <el-card shadow="hover" class="chart-card">-->
<!--          <div slot="header">-->
<!--            <span>支付情况</span>-->
<!--          </div>-->
<!--          <div class="chart-container" ref="paymentStatChart"></div>-->
<!--        </el-card>-->
<!--      </el-col>-->
<!--    </el-row>-->

    <div class="no-data" v-if="!selectedProjectId">
      <el-empty description="请先选择项目"></el-empty>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import {listInnoProject} from "@/api/innoProject"
import {
  getFundOverview,
  getBudgetUsage,
  getExpenseTypeDistribution,
  getMonthlyExpenseTrend,
  getExpenseApprovalStat
} from "@/api/fundAnalysis"

export default {
  name: "AnalysisTab",
  data() {
    return {
      // 项目列表
      projectList: [],
      selectedProjectId: null,

      // 年份选择
      years: [],
      selectedYear: new Date().getFullYear().toString(),

      // 数据
      overview: {
        totalBudget: 0,
        totalExpense: 0,
        remainingBudget: 0,
        budgetUsageRate: 0,
        pendingExpense: 0,
        unpaidExpense: 0
      },

      // 图表实例
      charts: {
        budgetUsage: null,
        expenseType: null,
        monthlyTrend: null,
        approvalStat: null,
        paymentStat: null
      },

      // 数据加载状态
      isDataLoaded: false,

      // 图表数据
      chartData: {
        budgetUsage: null,
        expenseType: null,
        monthlyTrend: null,
        approvalStat: null
      },

      // 加载计数器
      loadCounter: 0,
      totalLoadItems: 4,

      // 添加一个标志，表示组件是否已经装载
      isMounted: false,

      // 添加一个定时器ID，用于管理延迟初始化
      chartInitTimer: null,

      // 字典映射
      dictMaps: {
        // 支出类型字典
        expenseTypes: {
          'PRINT': '印刷费',
          'TRAVEL': '差旅费',
          'MATERIAL': '材料费',
          'DEVICE': '设备费',
          'TEST': '测试费',
          'CONSULTATION': '咨询费',
          'MEETING': '会议费',
          'OTHER': '其他'
        },
        // 预算类型字典
        budgetTypes: {
          'PRINT': '印刷费',
          'TRAVEL': '差旅费',
          'MATERIAL': '材料费',
          'DEVICE': '设备费',
          'TEST': '测试费',
          'CONSULTATION': '咨询费',
          'MEETING': '会议费',
          'OTHER': '其他'
        },
        // 审批状态字典
        approvalStatus: {
          'DRAFT': '草稿',
          'SUBMITTED': '已提交',
          'APPROVED': '已批准',
          'REJECTED': '已拒绝',
          'SCHOOL_APPROVED': '学校已批准',
          'SCHOOL_REJECTED': '学校已拒绝',
          // 添加可能出现的其他状态
          'PENDING': '待处理',
          'COMPLETED': '已完成',
          'REVIEWING': '审核中'
        },
        // 支付状态字典
        paymentStatus: {
          'PAID': '已支付',
          'UNPAID': '未支付',
          // 添加可能出现的其他状态
          'PROCESSING': '处理中',
          'REFUNDED': '已退款',
          'CANCELLED': '已取消'
        },
        // 排除显示的状态（不应该在审批图表中显示的状态）
        excludeFromApproval: ['PAID', 'UNPAID', 'PROCESSING', 'REFUNDED', 'CANCELLED']
      }
    }
  },
  mounted() {
    this.isMounted = true
    this.loadProjectList()
    this.initYears()
    // 响应式处理
    window.addEventListener('resize', this.resizeCharts)
  },
  activated() {
    // keep-alive组件被激活时，确保图表正确显示
    if (this.isDataLoaded && this.isMounted) {
      this.resizeAndReinitCharts()
    }
  },
  beforeDestroy() {
    // 销毁图表实例
    Object.values(this.charts).forEach(chart => {
      if (chart) {
        chart.dispose()
      }
    })

    // 清除定时器
    if (this.chartInitTimer) {
      clearTimeout(this.chartInitTimer)
    }

    // 移除事件监听
    window.removeEventListener('resize', this.resizeCharts)
  },
  watch: {
    // 监控数据加载状态，当所有数据加载完成后初始化图表
    loadCounter(newVal) {
      if (newVal >= this.totalLoadItems) {
        this.isDataLoaded = true
        this.$nextTick(() => {
          // 确保DOM已经更新
          this.initAllCharts()
        })
      }
    }
  },
  methods: {
    // 重新调整和初始化图表
    resizeAndReinitCharts() {
      // 清除之前的定时器
      if (this.chartInitTimer) {
        clearTimeout(this.chartInitTimer)
      }

      // 使用延迟来确保DOM已完全渲染并可见
      this.chartInitTimer = setTimeout(() => {
        // 重新初始化所有图表
        if (this.chartData.budgetUsage) {
          this.renderBudgetUsageChart(this.chartData.budgetUsage)
        }

        if (this.chartData.expenseType) {
          this.renderExpenseTypeChart(this.chartData.expenseType)
        }

        if (this.chartData.monthlyTrend) {
          this.renderMonthlyTrendChart(this.chartData.monthlyTrend)
        }

        if (this.chartData.approvalStat) {
          this.renderApprovalStatChart(this.chartData.approvalStat)
          if (this.chartData.approvalStat.paymentStatus) {
            this.renderPaymentStatChart(this.chartData.approvalStat.paymentStatus)
          }
        }

        // 手动触发一次 resize 以确保所有图表都能正确渲染
        this.resizeCharts()
      }, 300)
    },

    // 初始化所有图表
    initAllCharts() {
      // 清除之前的定时器
      if (this.chartInitTimer) {
        clearTimeout(this.chartInitTimer)
      }

      this.$nextTick(() => {
        // 使用 setTimeout 确保 DOM 已完全渲染
        this.chartInitTimer = setTimeout(() => {
          if (this.chartData.budgetUsage) {
            this.renderBudgetUsageChart(this.chartData.budgetUsage)
          }

          if (this.chartData.expenseType) {
            this.renderExpenseTypeChart(this.chartData.expenseType)
          }

          if (this.chartData.monthlyTrend) {
            this.renderMonthlyTrendChart(this.chartData.monthlyTrend)
          }

          if (this.chartData.approvalStat) {
            this.renderApprovalStatChart(this.chartData.approvalStat)
            if (this.chartData.approvalStat.paymentStatus) {
              this.renderPaymentStatChart(this.chartData.approvalStat.paymentStatus)
            }
          }

          // 手动触发一次 resize 以确保所有图表都能正确渲染
          this.resizeCharts()
        }, 300)
      })
    },

    // 初始化年份选择器
    initYears() {
      const currentYear = new Date().getFullYear()
      const years = []
      for (let i = 0; i < 5; i++) {
        years.push((currentYear - i).toString())
      }
      this.years = years
      this.selectedYear = currentYear.toString()
    },

    // 加载项目列表
    loadProjectList() {
      listInnoProject().then(response => {
        this.projectList = response.rows || []
        if (this.projectList.length > 0) {
          this.selectedProjectId = this.projectList[0].id
          this.handleProjectChange(this.selectedProjectId)
        }
      })
    },

    // 处理项目变更
    handleProjectChange(projectId) {
      // 重置加载状态
      this.isDataLoaded = false
      this.loadCounter = 0
      this.loadFundOverview(projectId)
      this.loadBudgetUsage(projectId)
      this.loadExpenseTypeDistribution(projectId)
      this.loadMonthlyExpenseTrend(projectId, this.selectedYear)
      this.loadExpenseApprovalStat(projectId)
    },

    // 加载经费概览
    loadFundOverview(projectId) {
      getFundOverview(projectId).then(response => {
        this.overview = response.data || this.overview
      })
    },

    // 加载预算使用情况
    loadBudgetUsage(projectId) {
      getBudgetUsage(projectId).then(response => {
        const data = response.data || {budgetNames: [], budgetAmounts: [], usedAmounts: [], remainingAmounts: []}

        // 转换预算名称为中文
        if (data.budgetNames && data.budgetNames.length > 0) {
          data.budgetNames = data.budgetNames.map(name => this.dictMaps.budgetTypes[name] || name)
        }

        this.chartData.budgetUsage = data
        this.loadCounter++
      })
    },

    // 加载支出类型分布
    loadExpenseTypeDistribution(projectId) {
      getExpenseTypeDistribution(projectId).then(response => {
        const data = response.data || {expenseTypes: [], expenseAmounts: []}

        // 转换支出类型为中文
        if (data.expenseTypes && data.expenseTypes.length > 0) {
          // 保存原始数据，用于图表渲染时使用
          data.originalTypes = [...data.expenseTypes]
          data.expenseTypes = data.expenseTypes.map(type => this.dictMaps.expenseTypes[type] || type)
        }

        this.chartData.expenseType = data
        this.loadCounter++
      })
    },

    // 加载月度支出趋势
    loadMonthlyExpenseTrend(projectId, year) {
      if (typeof projectId !== 'number') {
        year = projectId
        projectId = this.selectedProjectId
      }
      getMonthlyExpenseTrend(projectId, year).then(response => {
        const data = response.data || {months: [], amounts: [], year: year}
        this.chartData.monthlyTrend = data
        this.loadCounter++

        // 如果是通过年份选择器触发的，需要单独渲染图表
        if (typeof projectId !== 'number' && this.isDataLoaded) {
          this.$nextTick(() => {
            this.renderMonthlyTrendChart(data)
          })
        }
      })
    },

    // 加载支出审批统计
    loadExpenseApprovalStat(projectId) {
      getExpenseApprovalStat(projectId).then(response => {
        const data = response.data || {statusCounts: {}, statusAmounts: {}, paymentStatus: {}}

        // 为支付状态添加中文名称
        if (data.paymentStatus) {
          // 保持原有数据
          data.paymentStatus = {
            ...data.paymentStatus,
            paidName: this.dictMaps.paymentStatus.PAID,
            unpaidName: this.dictMaps.paymentStatus.UNPAID
          }
        }

        // 为状态码和状态名称创建映射关系
        data.statusNameMap = {}
        if (data.statusCounts) {
          // 过滤掉不需要显示的状态（如PAID等支付状态不应在审批图中显示）
          const filterOutStatus = this.dictMaps.excludeFromApproval

          // 先移除不需要的状态
          filterOutStatus.forEach(status => {
            if (data.statusCounts[status] !== undefined) {
              delete data.statusCounts[status]
            }
            if (data.statusAmounts[status] !== undefined) {
              delete data.statusAmounts[status]
            }
          })

          // 然后为剩余状态创建映射
          Object.keys(data.statusCounts).forEach(status => {
            data.statusNameMap[status] = this.dictMaps.approvalStatus[status] || status
          })
        }

        this.chartData.approvalStat = data
        this.loadCounter++
      })
    },

    // 渲染预算使用情况图表
    renderBudgetUsageChart(data) {
      const chartDom = this.$refs.budgetUsageChart
      if (!chartDom) return

      // 确保容器有尺寸
      if (chartDom.clientWidth === 0 || chartDom.clientHeight === 0) {
        console.warn('图表容器尺寸为0，延迟初始化')
        setTimeout(() => this.renderBudgetUsageChart(data), 300)
        return
      }

      if (this.charts.budgetUsage) {
        this.charts.budgetUsage.dispose()
      }

      this.charts.budgetUsage = echarts.init(chartDom)

      const option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {type: 'shadow'},
          formatter: (params) => {
            const budgetName = params[0].name
            const budgetAmount = params[0].value
            const usedAmount = params[1].value
            const remainingAmount = params[2].value

            return `${budgetName}<br/>
                    预算金额: ${this.formatMoney(budgetAmount)} 元<br/>
                    已使用: ${this.formatMoney(usedAmount)} 元<br/>
                    剩余预算: ${this.formatMoney(remainingAmount)} 元`
          }
        },
        legend: {
          data: ['预算金额', '已使用', '剩余预算']
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: [
          {
            type: 'category',
            data: data.budgetNames,
            axisLabel: {
              interval: 0,
              rotate: 30
            }
          }
        ],
        yAxis: [
          {
            type: 'value',
            name: '金额 (元)'
          }
        ],
        series: [
          {
            name: '预算金额',
            type: 'bar',
            stack: '预算',
            emphasis: {focus: 'series'},
            data: data.budgetAmounts
          },
          {
            name: '已使用',
            type: 'bar',
            stack: '使用情况',
            emphasis: {focus: 'series'},
            data: data.usedAmounts
          },
          {
            name: '剩余预算',
            type: 'bar',
            stack: '使用情况',
            emphasis: {focus: 'series'},
            data: data.remainingAmounts
          }
        ]
      }

      this.charts.budgetUsage.setOption(option)
    },

    // 渲染支出类型分布图表
    renderExpenseTypeChart(data) {
      const chartDom = this.$refs.expenseTypeChart
      if (!chartDom) return

      // 确保容器有尺寸
      if (chartDom.clientWidth === 0 || chartDom.clientHeight === 0) {
        console.warn('图表容器尺寸为0，延迟初始化')
        setTimeout(() => this.renderExpenseTypeChart(data), 300)
        return
      }

      if (this.charts.expenseType) {
        this.charts.expenseType.dispose()
      }

      this.charts.expenseType = echarts.init(chartDom)

      const pieData = data.expenseTypes.map((type, index) => {
        return {
          name: type, // 已经在加载时转换过了
          value: data.expenseAmounts[index]
        }
      })

      const option = {
        tooltip: {
          trigger: 'item',
          formatter: (params) => {
            return `${params.name}<br/>
                    金额: ${this.formatMoney(params.value)} 元<br/>
                    占比: ${params.percent}%`
          }
        },
        legend: {
          type: 'scroll',
          orient: 'vertical',
          right: 10,
          top: 20,
          bottom: 20
        },
        series: [
          {
            name: '支出类型',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: '16',
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: pieData
          }
        ]
      }

      this.charts.expenseType.setOption(option)
    },

    // 渲染月度支出趋势图表
    renderMonthlyTrendChart(data) {
      const chartDom = this.$refs.monthlyTrendChart
      if (!chartDom) return

      // 确保容器有尺寸
      if (chartDom.clientWidth === 0 || chartDom.clientHeight === 0) {
        console.warn('图表容器尺寸为0，延迟初始化')
        setTimeout(() => this.renderMonthlyTrendChart(data), 300)
        return
      }

      if (this.charts.monthlyTrend) {
        this.charts.monthlyTrend.dispose()
      }

      this.charts.monthlyTrend = echarts.init(chartDom)

      const option = {
        title: {
          text: `${data.year}年月度支出趋势`,
          left: 'center'
        },
        tooltip: {
          trigger: 'axis',
          formatter: (params) => {
            return `${data.year}年${params[0].name}<br/>
                    支出金额: ${this.formatMoney(params[0].value)} 元`
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: data.months
        },
        yAxis: {
          type: 'value',
          name: '金额 (元)'
        },
        series: [
          {
            name: '月度支出',
            type: 'line',
            smooth: true,
            lineStyle: {
              width: 3,
              color: '#5470c6'
            },
            areaStyle: {
              opacity: 0.3,
              color: {
                type: 'linear',
                x: 0,
                y: 0,
                x2: 0,
                y2: 1,
                colorStops: [
                  {offset: 0, color: '#5470c6'},
                  {offset: 1, color: '#fff'}
                ]
              }
            },
            emphasis: {
              focus: 'series'
            },
            data: data.amounts[0],
            markPoint: {
              data: [
                {type: 'max', name: '最大值'},
                {type: 'min', name: '最小值'}
              ]
            }
          }
        ]
      }

      this.charts.monthlyTrend.setOption(option)
    },

    // 渲染支出审批统计图表
    renderApprovalStatChart(data) {
      const chartDom = this.$refs.approvalStatChart
      if (!chartDom) return

      // 确保容器有尺寸
      if (chartDom.clientWidth === 0 || chartDom.clientHeight === 0) {
        console.warn('图表容器尺寸为0，延迟初始化')
        setTimeout(() => this.renderApprovalStatChart(data), 300)
        return
      }

      if (this.charts.approvalStat) {
        this.charts.approvalStat.dispose()
      }

      this.charts.approvalStat = echarts.init(chartDom)

      // 已知的支出审批状态
      const knownApprovalStatus = Object.keys(this.dictMaps.approvalStatus)

      const pieData = Object.entries(data.statusCounts || {})
        .filter(([status, count]) => {
          // 只显示已知的审批状态或者其他有效的状态，排除不应显示的状态
          return count > 0 &&
                 !this.dictMaps.excludeFromApproval.includes(status)
        })
        .map(([status, count]) => {
          return {
            name: data.statusNameMap[status] || ('未知状态:' + status),
            value: count,
            originalStatus: status // 保存原始状态码，用于查找对应金额
          }
        })

      // 如果没有数据，显示一个空状态
      if (pieData.length === 0) {
        pieData.push({
          name: '暂无数据',
          value: 1,
          itemStyle: {
            color: '#909399'
          }
        })
      }

      const option = {
        tooltip: {
          trigger: 'item',
          formatter: (params) => {
            if (params.name === '暂无数据') {
              return '暂无审批数据'
            }

            const status = params.name
            const count = params.value
            const originalStatus = params.data.originalStatus
            const amount = data.statusAmounts[originalStatus] || 0

            return `${status}<br/>
                    数量: ${count} 笔<br/>
                    金额: ${this.formatMoney(amount)} 元<br/>
                    占比: ${params.percent}%`
          }
        },
        legend: {
          type: 'scroll',
          orient: 'vertical',
          right: 10,
          top: 20,
          bottom: 20
        },
        series: [
          {
            name: '审批状态',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            itemStyle: {
              borderRadius: 10,
              borderColor: '#fff',
              borderWidth: 2
            },
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: '16',
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: pieData
          }
        ]
      }

      this.charts.approvalStat.setOption(option)
    },

    // 渲染支付情况图表
    renderPaymentStatChart(paymentStatus) {
      const chartDom = this.$refs.paymentStatChart
      if (!chartDom) return

      // 确保容器有尺寸
      if (chartDom.clientWidth === 0 || chartDom.clientHeight === 0) {
        console.warn('图表容器尺寸为0，延迟初始化')
        setTimeout(() => this.renderPaymentStatChart(paymentStatus), 300)
        return
      }

      if (this.charts.paymentStat) {
        this.charts.paymentStat.dispose()
      }

      this.charts.paymentStat = echarts.init(chartDom)

      const paid = paymentStatus.paid || 0
      const unpaid = paymentStatus.unpaid || 0
      const total = Number(paid) + Number(unpaid)

      // 使用在加载时保存的中文名称
      const paidName = paymentStatus.paidName || this.dictMaps.paymentStatus.PAID
      const unpaidName = paymentStatus.unpaidName || this.dictMaps.paymentStatus.UNPAID

      const paidPercent = total > 0 ? (Number(paid) / total * 100).toFixed(2) : 0

      const option = {
        tooltip: {
          trigger: 'item',
          formatter: (params) => {
            return `${params.name}<br/>
                    金额: ${this.formatMoney(params.value)} 元<br/>
                    占比: ${params.percent}%`
          }
        },
        legend: {
          bottom: '5%',
          left: 'center'
        },
        series: [
          {
            name: '支付情况',
            type: 'pie',
            radius: ['40%', '70%'],
            avoidLabelOverlap: false,
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: true,
                fontSize: '16',
                fontWeight: 'bold'
              }
            },
            labelLine: {
              show: false
            },
            data: [
              {value: paid, name: paidName, itemStyle: {color: '#67C23A'}},
              {value: unpaid, name: unpaidName, itemStyle: {color: '#E6A23C'}}
            ]
          }
        ]
      }

      this.charts.paymentStat.setOption(option)
    },

    // 重新调整图表大小
    resizeCharts() {
      Object.values(this.charts).forEach(chart => {
        if (chart) {
          chart.resize()
        }
      })
    },

    // 格式化金额
    formatMoney(value) {
      return (Number(value) || 0).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    },

    // 格式化百分比
    formatPercent(value) {
      return (Number(value) || 0).toFixed(2) + '%'
    },

    // 根据使用率获取颜色
    getColorByRate(rate) {
      rate = Number(rate) || 0
      if (rate < 50) {
        return '#67C23A' // 绿色
      } else if (rate < 80) {
        return '#E6A23C' // 黄色
      } else {
        return '#F56C6C' // 红色
      }
    }
  }
}
</script>

<style scoped>
.fund-analysis-container {
  padding: 20px;
}

.project-selector {
  margin-bottom: 20px;
}

.overview-cards, .pending-cards {
  margin-bottom: 20px;
}

.card-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 10px;
}

.card-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 5px;
}

.chart-area {
  margin-bottom: 20px;
}

.chart-card {
  margin-bottom: 20px;
}

.chart-container {
  height: 300px;
}

.year-selector {
  float: right;
}

.clearfix:after {
  clear: both;
  content: "";
  display: block;
  height: 0;
}

.no-data {
  margin-top: 100px;
}
</style>

<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="项目名称" prop="projectName">
        <el-input
          v-model="queryParams.projectName"
          placeholder="请输入项目名称"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          v-model="dateRange"
          size="small"
          style="width: 240px"
          value-format="yyyy-MM-dd"
          type="daterange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
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
        >项目申报
        </el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="projectList">
      <el-table-column label="项目名称" align="center" prop="projectName"/>
      <el-table-column label="项目类型" align="center" prop="projectType"/>
      <el-table-column label="导师" align="center" prop="teacherName"/>
      <el-table-column label="状态" align="center" prop="status"/>
      <el-table-column label="申报时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleDetail(scope.row)"
          >详情
          </el-button>
          <el-button
            v-if="scope.row.status === 'DRAFT' || scope.row.status === 'APPROVE_FAIL'"
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
          >修改
          </el-button>
          <el-button
            v-if="scope.row.status === 'DRAFT' || scope.row.status === 'APPROVE_FAIL'"
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
          >删除
          </el-button>
          <el-button
            v-if="scope.row.status === 'DRAFT'"
            size="mini"
            type="text"
            icon="el-icon-upload2"
            @click="handleSubmit(scope.row)"
          >提交
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-check"
            @click="handleApprove(scope.row, true)"
          >通过
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-close"
            @click="handleApprove(scope.row, false)"
          >拒绝
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-document-checked"
            @click="handleMidCheck(scope.row)"
          >中期检查
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-s-claim"
            @click="handleMidCheckScore(scope.row)"
          >中期评分
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

    <!-- 添加或修改大创项目对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="项目名称" prop="projectName">
          <el-input v-model="form.projectName" placeholder="请输入项目名称"/>
        </el-form-item>
        <el-form-item label="项目类型" prop="projectType">
          <el-select v-model="form.projectType" placeholder="请选择项目类型">
            <el-option
              v-for="item in projectTypeList"
              :key="item"
              :label="item"
              :value="item"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="项目简介" prop="projectDesc">
          <el-input v-model="form.projectDesc" type="textarea" placeholder="请输入项目简介"/>
        </el-form-item>
        <el-form-item label="导师" prop="teacherId">
          <el-select v-model="form.teacherId" placeholder="请选择导师">
            <el-option
              v-for="teacher in teacherOptions"
              :key="teacher.id"
              :label="teacher.teacherName"
              :value="teacher.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="项目成员" prop="memberList">
          <el-select
            v-model="selectedMemberCodes"
            multiple
            filterable
            placeholder="请选择项目成员"
            style="width: 100%"
            @change="handleMemberChange"
          >
            <el-option
              v-for="student in studentOptions"
              :key="student.stuNo"
              :label="student.stuName"
              :value="student.stuNo"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="申报材料" prop="submitFileUrl">
          <file-upload
            v-model="form.submitFileUrl"
            :limit="1"
            :fileType="['doc', 'docx' ,'xls', 'xlsx' ,'ppt', 'pptx','txt', 'pdf', 'zip', 'png','jpg']"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="handleSave">暂 存</el-button>
        <el-button type="success" @click="handleSubmitForm">提 交</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 项目详情对话框 -->
    <el-dialog title="项目详情" :visible.sync="detailOpen" width="700px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="项目名称">{{ detail.projectName }}</el-descriptions-item>
        <el-descriptions-item label="项目类型">
          <dict-tag :options="projectTypeList" :value="detail.projectType"/>
        </el-descriptions-item>
        <el-descriptions-item label="项目简介">{{ detail.projectDesc }}</el-descriptions-item>
        <el-descriptions-item label="导师">{{ detail.teacherName }}</el-descriptions-item>
        <el-descriptions-item label="状态">
          <dict-tag :options="statusOptions" :value="detail.status"/>
        </el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ parseTime(detail.createTime) }}</el-descriptions-item>
        <el-descriptions-item label="申报材料" :span="2">
          <el-link :href="baseUrl + detail.submitFileUrl" target="_blank">
            {{ detail.submitFileUrl ? detail.submitFileUrl.split('/').pop() : null }}
          </el-link>
        </el-descriptions-item>

        <template v-if="detail.midCheckFileUrl">
          <el-descriptions-item label="中期检查材料" :span="2">
            <el-link :href="baseUrl + detail.midCheckFileUrl" target="_blank">
              {{ detail.midCheckFileUrl ? detail.midCheckFileUrl.split('/').pop() : null }}
            </el-link>
          </el-descriptions-item>
          <el-descriptions-item label="中期检查说明" :span="2">
            {{ detail.midCheckDesc }}
          </el-descriptions-item>
        </template>

        <template v-if="detail.midScoreXtjz !== null && detail.midScoreXtjz !== undefined">
          <el-descriptions-item label="选题价值分(权重0.2)">{{ detail.midScoreXtjz }}</el-descriptions-item>
          <el-descriptions-item label="研究基础分(权重0.2)">{{ detail.midScoreYjjc }}</el-descriptions-item>
          <el-descriptions-item label="内容设计分(权重0.5)">{{ detail.midScoreNrsj }}</el-descriptions-item>
          <el-descriptions-item label="研究方法分(权重0.1)">{{ detail.midScoreYjff }}</el-descriptions-item>
          <el-descriptions-item label="中期评分总分" :span="2">
            <el-tag type="success">
              {{ (detail.midScoreXtjz * 0.2 + detail.midScoreYjjc * 0.2 + detail.midScoreNrsj * 0.5 + detail.midScoreYjff * 0.1).toFixed(2) }}
            </el-tag>
          </el-descriptions-item>
        </template>
      </el-descriptions>
    </el-dialog>

    <!-- 审批对话框 -->
    <el-dialog :title="approveTitle" :visible.sync="approveOpen" width="500px" append-to-body>
      <el-form ref="approveForm" :model="approveForm" :rules="approveRules" label-width="80px">
        <el-form-item label="审批原因" prop="approveDesc">
          <el-input v-model="approveForm.approveDesc" type="textarea" placeholder="请输入审批原因"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitApprove">确 定</el-button>
        <el-button @click="approveOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 中期检查对话框 -->
    <el-dialog title="中期检查" :visible.sync="midCheckOpen" width="500px" append-to-body>
      <el-form ref="midCheckForm" :model="midCheckForm" :rules="midCheckRules" label-width="80px">
        <el-form-item label="检查说明" prop="midCheckDesc">
          <el-input v-model="midCheckForm.midCheckDesc" type="textarea" placeholder="请输入中期检查说明"/>
        </el-form-item>
        <el-form-item label="检查材料" prop="midCheckFileUrl">
          <file-upload
            v-model="midCheckForm.midCheckFileUrl"
            :limit="1"
            :fileType="['doc', 'docx' ,'xls', 'xlsx' ,'ppt', 'pptx','txt', 'pdf', 'zip', 'png','jpg']"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitMidCheck">提 交</el-button>
        <el-button @click="midCheckOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 中期评分对话框 -->
    <el-dialog title="中期检查评分" :visible.sync="midScoreOpen" width="700px" append-to-body>
      <el-form ref="midScoreForm" :model="midScoreForm" :rules="midScoreRules" label-width="180px">
        <el-alert
          title="评分须知：所有评分项满分为100分，最终得分为加权平均分。"
          type="info"
          :closable="false"
          style="margin-bottom: 20px"
        />
        <el-form-item label="选题价值分 (权重0.2)" prop="midScoreXtjz">
          <el-row>
            <el-col :span="8">
              <el-input-number v-model="midScoreForm.midScoreXtjz" :precision="0" :min="0" :max="100" @change="calculateScore" />
            </el-col>
            <el-col :span="16">
              <div class="score-tips">
                <i class="el-icon-info" /> 评价选题的价值和意义，创新性和实用性
              </div>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="研究基础分 (权重0.2)" prop="midScoreYjjc">
          <el-row>
            <el-col :span="8">
              <el-input-number v-model="midScoreForm.midScoreYjjc" :precision="0" :min="0" :max="100" @change="calculateScore" />
            </el-col>
            <el-col :span="16">
              <div class="score-tips">
                <i class="el-icon-info" /> 评价研究的基础条件和资料收集的充分性
              </div>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="内容设计分 (权重0.5)" prop="midScoreNrsj">
          <el-row>
            <el-col :span="8">
              <el-input-number v-model="midScoreForm.midScoreNrsj" :precision="0" :min="0" :max="100" @change="calculateScore" />
            </el-col>
            <el-col :span="16">
              <div class="score-tips">
                <i class="el-icon-info" /> 评价研究内容的设计合理性和完整性
              </div>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="研究方法分 (权重0.1)" prop="midScoreYjff">
          <el-row>
            <el-col :span="8">
              <el-input-number v-model="midScoreForm.midScoreYjff" :precision="0" :min="0" :max="100" @change="calculateScore" />
            </el-col>
            <el-col :span="16">
              <div class="score-tips">
                <i class="el-icon-info" /> 评价研究方法的选择和应用的合理性
              </div>
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="总分">
          <el-tag type="success" size="medium">{{ totalScore }}</el-tag>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitMidScore">提 交</el-button>
        <el-button @click="midScoreOpen = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  listInnoProject,
  getInnoProject,
  delInnoProject,
  addInnoProject,
  updateInnoProject,
  approveInnoProject,
  submitMidCheck,
  submitMidCheckScore,
  calculateMidScore
} from "@/api/innoProject";
import {listTeacher} from "@/api/person/teacher";
import {listProjectType} from "@/api/system/projectType";
import {listStudentOptions} from "@/api/person/student";

export default {
  name: "InnoProject",
  data() {
    return {
      baseUrl: process.env.VUE_APP_BASE_API,
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 大创项目表格数据
      projectList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否显示详情弹出层
      detailOpen: false,
      // 日期范围
      dateRange: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        projectName: undefined
      },
      // 表单参数
      form: {
        id: undefined,
        projectName: undefined,
        projectType: undefined,
        projectDesc: undefined,
        teacherId: undefined,
        submitFileUrl: undefined,
        memberList: []
      },
      // 表单校验
      rules: {
        projectName: [
          {required: true, message: "项目名称不能为空", trigger: "blur"}
        ],
        projectType: [
          {required: true, message: "项目类型不能为空", trigger: "change"}
        ],
        projectDesc: [
          {required: true, message: "项目简介不能为空", trigger: "blur"}
        ],
        teacherId: [
          {required: true, message: "导师不能为空", trigger: "change"}
        ],
        submitFileUrl: [
          {required: true, message: "申报材料不能为空", trigger: "change"}
        ]
      },
      // 项目类型选项
      projectTypeOptions: [],
      // 状态选项
      statusOptions: [],
      // 导师选项
      teacherOptions: [],
      // 学生选项
      studentOptions: [],
      // 详情数据
      detail: {},
      // 项目类型列表
      projectTypeList: [],
      // 审批对话框标题
      approveTitle: "",
      // 是否显示审批对话框
      approveOpen: false,
      // 审批表单参数
      approveForm: {
        id: undefined,
        approveDesc: undefined,
        isApprove: undefined
      },
      // 审批表单校验
      approveRules: {
        approveDesc: [
          {required: true, message: "审批原因不能为空", trigger: "blur"}
        ]
      },
      // 选中的成员工号
      selectedMemberCodes: [],
      // 中期检查对话框是否显示
      midCheckOpen: false,
      // 中期检查表单参数
      midCheckForm: {
        id: undefined,
        midCheckDesc: undefined,
        midCheckFileUrl: undefined
      },
      // 中期检查表单校验
      midCheckRules: {
        midCheckDesc: [
          {required: true, message: "中期检查说明不能为空", trigger: "blur"}
        ],
        midCheckFileUrl: [
          {required: true, message: "中期检查材料不能为空", trigger: "change"}
        ]
      },
      // 中期评分对话框是否显示
      midScoreOpen: false,
      // 中期评分表单参数
      midScoreForm: {
        id: undefined,
        midScoreXtjz: 0,
        midScoreYjjc: 0,
        midScoreNrsj: 0,
        midScoreYjff: 0
      },
      // 中期评分表单校验
      midScoreRules: {
        midScoreXtjz: [
          {required: true, message: "选题价值分不能为空", trigger: "blur"}
        ],
        midScoreYjjc: [
          {required: true, message: "研究基础分不能为空", trigger: "blur"}
        ],
        midScoreNrsj: [
          {required: true, message: "内容设计分不能为空", trigger: "blur"}
        ],
        midScoreYjff: [
          {required: true, message: "研究方法分不能为空", trigger: "blur"}
        ]
      },
      // 总分
      totalScore: 0
    };
  },
  created() {
    this.getList();
    this.getProjectTypeList();
    this.getDicts("project_status").then(response => {
      this.statusOptions = response.data;
    });
    this.getTeacherList();
    this.getStudentList();
  },
  methods: {
    /** 查询大创项目列表 */
    getList() {
      this.loading = true;
      listInnoProject(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.projectList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 查询项目类型列表 */
    getProjectTypeList() {
      listProjectType().then(response => {
        this.projectTypeList = response.data;
      });
    },
    /** 查询导师列表 */
    getTeacherList() {
      listTeacher().then(response => {
        this.teacherOptions = response.rows;
      });
    },
    /** 查询学生列表 */
    getStudentList() {
      listStudentOptions().then(response => {
        this.studentOptions = response.data;
      });
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
      this.reset();
    },
    /** 表单重置 */
    reset() {
      this.form = {
        id: undefined,
        projectName: undefined,
        projectType: undefined,
        projectDesc: undefined,
        teacherId: undefined,
        submitFileUrl: undefined,
        memberList: []
      };
      this.selectedMemberCodes = [];
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.dateRange = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加大创项目";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getInnoProject(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改大创项目";
      });
    },
    /** 暂存按钮 */
    handleSave() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id !== undefined && this.form.id !== null) {
            updateInnoProject(this.form, false).then(response => {
              this.$modal.msgSuccess("暂存成功");
              this.open = false;
              this.getList();
            });
          } else {
            addInnoProject(this.form, false).then(response => {
              this.$modal.msgSuccess("暂存成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 提交按钮 */
    handleSubmitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id !== undefined && this.form.id !== null) {
            updateInnoProject(this.form, true).then(response => {
              this.$modal.msgSuccess("暂存成功");
              this.open = false;
              this.getList();
            });
          } else {
            addInnoProject(this.form, true).then(response => {
              this.$modal.msgSuccess("暂存成功");
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
      this.$modal.confirm('是否确认删除大创项目编号为"' + ids + '"的数据项？').then(function () {
        return delInnoProject(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
      });
    },
    /** 详情按钮操作 */
    handleDetail(row) {
      getInnoProject(row.id).then(response => {
        this.detail = response.data;
        this.detailOpen = true;
      });
    },
    /** 提交按钮操作 */
    handleSubmit(row) {
      this.$modal.confirm('是否确认提交大创项目编号为"' + row.id + '"的数据项？').then(function () {
        return submitInnoProject(row.id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("提交成功");
      }).catch(() => {
      });
    },
    /** 审批按钮操作 */
    handleApprove(row, isApprove) {
      this.approveForm = {
        id: row.id,
        approveDesc: undefined,
        isApprove: isApprove
      };
      this.approveTitle = isApprove ? "审批通过" : "审批拒绝";
      this.approveOpen = true;
    },
    /** 提交审批 */
    submitApprove() {
      this.$refs["approveForm"].validate(valid => {
        if (valid) {
          const data = {
            id: this.approveForm.id,
            approveDesc: this.approveForm.approveDesc
          };
          approveInnoProject(this.approveForm.isApprove, data).then(response => {
            this.$modal.msgSuccess("审批成功");
            this.approveOpen = false;
            this.getList();
          });
        }
      });
    },
    /** 成员选择变更 */
    handleMemberChange(value) {
      this.form.memberList = value.map(code => ({
        memberUserCode: code,
        memberUserName: this.studentOptions.find(s => s.stuNo === code)?.stuName || '',
        reportFlag: 0
      }));
    },
    /** 中期检查按钮操作 */
    handleMidCheck(row) {
      this.midCheckForm = {
        id: row.id,
        midCheckDesc: row.midCheckDesc,
        midCheckFileUrl: row.midCheckFileUrl
      };
      this.midCheckOpen = true;
    },
    /** 提交中期检查 */
    submitMidCheck() {
      this.$refs["midCheckForm"].validate(valid => {
        if (valid) {
          submitMidCheck(this.midCheckForm).then(response => {
            this.$modal.msgSuccess("中期检查提交成功");
            this.midCheckOpen = false;
            this.getList();
          });
        }
      });
    },
    /** 中期评分按钮操作 */
    handleMidCheckScore(row) {
      getInnoProject(row.id).then(response => {
        const data = response.data;
        this.midScoreForm = {
          id: data.id,
          midScoreXtjz: data.midScoreXtjz || 0,
          midScoreYjjc: data.midScoreYjjc || 0,
          midScoreNrsj: data.midScoreNrsj || 0,
          midScoreYjff: data.midScoreYjff || 0
        };
        this.calculateScore();
        this.midScoreOpen = true;
      });
    },
    /** 计算总分 */
    calculateScore() {
      const params = {
        xtjz: this.midScoreForm.midScoreXtjz,
        yjjc: this.midScoreForm.midScoreYjjc,
        nrsj: this.midScoreForm.midScoreNrsj,
        yjff: this.midScoreForm.midScoreYjff
      };
      calculateMidScore(params).then(response => {
        this.totalScore = response.data;
      });
    },
    /** 提交中期评分 */
    submitMidScore() {
      this.$refs["midScoreForm"].validate(valid => {
        if (valid) {
          submitMidCheckScore(this.midScoreForm).then(response => {
            this.$modal.msgSuccess("中期评分提交成功");
            this.midScoreOpen = false;
            this.getList();
          });
        }
      });
    }
  }
};
</script>

<style scoped>
.score-tips {
  color: #606266;
  font-size: 12px;
  line-height: 32px;
  padding-left: 10px;
}
</style>

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
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-upload2"
          size="mini"
          @click="handleImport"
        >批量导入
        </el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExportTemplate"
        >下载模板
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
            size="mini"
            type="text"
            icon="el-icon-edit"
            v-if="scope.row.buttonList.indexOf('修改') !== -1"
            @click="handleUpdate(scope.row)"
          >修改
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-if="scope.row.buttonList.indexOf('删除') !== -1"
          >删除
          </el-button>
<!--          <el-button-->
<!--            size="mini"-->
<!--            type="text"-->
<!--            icon="el-icon-money"-->
<!--            @click="handleFundManage(scope.row)"-->
<!--          >经费管理-->
<!--          </el-button>-->
<!--          <el-button-->
<!--            size="mini"-->
<!--            type="text"-->
<!--            icon="el-icon-upload2"-->
<!--            @click="handleSubmit(scope.row)"-->
<!--            v-if="scope.row.buttonList.indexOf('提交') !== -1"-->
<!--          >提交-->
<!--          </el-button>-->
          <el-button
            size="mini"
            type="text"
            icon="el-icon-check"
            @click="handleApprove(scope.row, true)"
            v-if="scope.row.buttonList.indexOf('通过') !== -1"
          >通过
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-close"
            @click="handleApprove(scope.row, false)"
            v-if="scope.row.buttonList.indexOf('拒绝') !== -1"
          >拒绝
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-document-checked"
            @click="handleMidCheck(scope.row)"
            v-if="scope.row.buttonList.indexOf('中期检查') !== -1"
          >中期检查
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-s-claim"
            @click="handleMidCheckScore(scope.row)"
             v-if="scope.row.buttonList.indexOf('中期评分') !== -1"
          >中期评分
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-circle-check"
            @click="handleEndProject(scope.row)"
             v-if="scope.row.buttonList.indexOf('结项') !== -1"
          >结项
          </el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-s-check"
            @click="handleEndProjectScore(scope.row)"
             v-if="scope.row.buttonList.indexOf('结项评分') !== -1"
          >结项评分
          </el-button>
          <el-button
            size="mini"
            type="warning"
            plain
            icon="el-icon-check"
            @click="handleSchoolApprove(scope.row, true)"
            v-if="scope.row.status === 'WAIT_SCHOOL_APPROVE'"
          >学校审批通过
          </el-button>
          <el-button
            size="mini"
            type="danger"
            plain
            icon="el-icon-close"
            @click="handleSchoolApprove(scope.row, false)"
            v-if="scope.row.status === 'WAIT_SCHOOL_APPROVE'"
          >学校审批拒绝
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
        <el-form-item label="导师" prop="teacherId">
          <el-select v-model="form.teacherId" placeholder="请选择导师">
            <el-option
              v-for="teacher in filteredTeacherOptions"
              :key="teacher.id"
              :label="teacher.teacherName"
              :value="teacher.id"
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
    <el-dialog title="项目详情" :visible.sync="detailOpen" width="900px" append-to-body>
      <el-tabs type="border-card" v-model="activeName">
        <el-tab-pane label="基础信息" name="basic">
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
            <el-descriptions-item label="审批意见" v-if="detail.approveDesc">
              {{ detail.approveDesc }}
            </el-descriptions-item>
            <el-descriptions-item label="学校审批意见" v-if="detail.schoolApproveDesc">
              {{ detail.schoolApproveDesc }}
            </el-descriptions-item>
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

            <template v-if="detail.endFileUrl">
              <el-descriptions-item label="结项材料" :span="2">
                <el-link :href="baseUrl + detail.endFileUrl" target="_blank">
                  {{ detail.endFileUrl ? detail.endFileUrl.split('/').pop() : null }}
                </el-link>
              </el-descriptions-item>
              <el-descriptions-item label="结项说明" :span="2">
                {{ detail.endDesc }}
              </el-descriptions-item>
            </template>

            <!-- 添加成员列表显示 -->
            <el-descriptions-item label="项目成员" :span="2" v-if="detail.memberList && detail.memberList.length > 0">
              <el-tag v-for="member in detail.memberList" :key="member.memberUserCode" style="margin-right: 5px; margin-bottom: 5px;">
                {{ member.memberUserName }}({{ member.memberUserCode }})
              </el-tag>
            </el-descriptions-item>
          </el-descriptions>
        </el-tab-pane>

        <el-tab-pane label="项目评分" name="projectScore"
                     v-if="detail.midScoreXtjz !== null && detail.midScoreXtjz !== undefined">
          <!-- 中期评分展示 -->
          <div class="score-table-container">
            <div class="score-title">中期评分表 (占总评权重30%)</div>
            <table class="score-table">
              <thead>
              <tr>
                <th rowspan="2" width="80">评审内容</th>
                <th rowspan="2" width="60">权重</th>
                <th colspan="4">评审标准</th>
                <th rowspan="2" width="120">评分<br>(百分制)</th>
              </tr>
              <tr>
                <th width="150">A级<br>(80-100分)</th>
                <th width="150">B级<br>(60-80分)</th>
                <th width="150">C级<br>(40-60分)</th>
                <th width="150">D级<br>(0-40分)</th>
              </tr>
              </thead>
              <tbody>
              <tr>
                <td>选题价值</td>
                <td>0.2</td>
                <td>有重要创新性或应用性。</td>
                <td>有比较重要的创新性或应用性。</td>
                <td>创新性或应用性一般。</td>
                <td>基本属于重复性工作。</td>
                <td>
                  <div class="score-input-wrapper">
                    <el-tag type="info">{{ detail.midScoreXtjz }}</el-tag>
                  </div>
                </td>
              </tr>
              <tr>
                <td>研究基础</td>
                <td>0.2</td>
                <td>熟悉研究现状，所列参考文献具有代表性。</td>
                <td>比较熟悉研究现状，所列参考文献比较有代表性。</td>
                <td>一般了解研究现状，所列参考文献有一定代表性。</td>
                <td>不了解研究现状，所列参考文献没有代表性。</td>
                <td>
                  <div class="score-input-wrapper">
                    <el-tag type="info">{{ detail.midScoreYjjc }}</el-tag>
                  </div>
                </td>
              </tr>
              <tr>
                <td>内容设计</td>
                <td>0.5</td>
                <td>目标明确，内容充实，思路清晰。</td>
                <td>目标比较明确，内容比较充实，思路比较清晰。</td>
                <td>目标基本明确，内容基本充实，思路基本清晰。</td>
                <td>目标不够明确，内容空泛，思路模糊。</td>
                <td>
                  <div class="score-input-wrapper">
                    <el-tag type="info">{{ detail.midScoreNrsj }}</el-tag>
                  </div>
                </td>
              </tr>
              <tr>
                <td>研究方法</td>
                <td>0.1</td>
                <td>方法与手段科学、适切</td>
                <td>方法比较科学、适切</td>
                <td>方法手段基本科学、适切</td>
                <td>方法手段不当</td>
                <td>
                  <div class="score-input-wrapper">
                    <el-tag type="info">{{ detail.midScoreYjff }}</el-tag>
                  </div>
                </td>
              </tr>
              </tbody>
              <tfoot>
              <tr>
                <td colspan="6" style="text-align: right; font-weight: bold;">中期评分总分：</td>
                <td>
                  <el-tag type="success" size="medium">
                    {{
                      (detail.midScoreXtjz * 0.2 + detail.midScoreYjjc * 0.2 + detail.midScoreNrsj * 0.5 + detail.midScoreYjff * 0.1).toFixed(2)
                    }}
                  </el-tag>
                </td>
              </tr>
              </tfoot>
            </table>
          </div>

          <!-- 结项评分展示 -->
          <div class="score-table-container" v-if="detail.endScoreXtjz !== null && detail.endScoreXtjz !== undefined">
            <div class="score-title">结项评分表 (占总评权重70%)</div>
            <table class="score-table">
              <thead>
              <tr>
                <th rowspan="2" width="80">评审内容</th>
                <th rowspan="2" width="60">权重</th>
                <th colspan="4">评审标准</th>
                <th rowspan="2" width="120">评分<br>(百分制)</th>
              </tr>
              <tr>
                <th width="150">A级<br>(80-100分)</th>
                <th width="150">B级<br>(60-80分)</th>
                <th width="150">C级<br>(40-60分)</th>
                <th width="150">D级<br>(0-40分)</th>
              </tr>
              </thead>
              <tbody>
              <tr>
                <td>选题价值</td>
                <td>0.2</td>
                <td>有重要创新性或应用性。</td>
                <td>有比较重要的创新性或应用性。</td>
                <td>创新性或应用性一般。</td>
                <td>基本属于重复性工作。</td>
                <td>
                  <div class="score-input-wrapper">
                    <el-tag type="info">{{ detail.endScoreXtjz }}</el-tag>
                  </div>
                </td>
              </tr>
              <tr>
                <td>研究基础</td>
                <td>0.2</td>
                <td>熟悉研究现状，所列参考文献具有代表性。</td>
                <td>比较熟悉研究现状，所列参考文献比较有代表性。</td>
                <td>一般了解研究现状，所列参考文献有一定代表性。</td>
                <td>不了解研究现状，所列参考文献没有代表性。</td>
                <td>
                  <div class="score-input-wrapper">
                    <el-tag type="info">{{ detail.endScoreYjjc }}</el-tag>
                  </div>
                </td>
              </tr>
              <tr>
                <td>内容设计</td>
                <td>0.5</td>
                <td>目标明确，内容充实，思路清晰。</td>
                <td>目标比较明确，内容比较充实，思路比较清晰。</td>
                <td>目标基本明确，内容基本充实，思路基本清晰。</td>
                <td>目标不够明确，内容空泛，思路模糊。</td>
                <td>
                  <div class="score-input-wrapper">
                    <el-tag type="info">{{ detail.endScoreNrsj }}</el-tag>
                  </div>
                </td>
              </tr>
              <tr>
                <td>研究方法</td>
                <td>0.1</td>
                <td>方法与手段科学、适切</td>
                <td>方法比较科学、适切</td>
                <td>方法手段基本科学、适切</td>
                <td>方法手段不当</td>
                <td>
                  <div class="score-input-wrapper">
                    <el-tag type="info">{{ detail.endScoreYjff }}</el-tag>
                  </div>
                </td>
              </tr>
              </tbody>
              <tfoot>
              <tr>
                <td colspan="6" style="text-align: right; font-weight: bold;">结项评分总分：</td>
                <td>
                  <el-tag type="success" size="medium">
                    {{
                      (detail.endScoreXtjz * 0.2 + detail.endScoreYjjc * 0.2 + detail.endScoreNrsj * 0.5 + detail.endScoreYjff * 0.1).toFixed(2)
                    }}
                  </el-tag>
                </td>
              </tr>
              </tfoot>
            </table>
          </div>

          <!-- 最终评分展示 -->
          <div class="final-score" v-if="detail.endScoreXtjz !== null && detail.endScoreXtjz !== undefined">
            <div class="final-score-title">最终评分（中期30% + 结项70%）</div>
            <div class="final-score-value">
              <el-tag type="danger" size="large">{{ finalScore }}</el-tag>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
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

    <!-- 学校审批对话框 -->
    <el-dialog :title="schoolApproveTitle" :visible.sync="schoolApproveOpen" width="500px" append-to-body>
      <el-form ref="schoolApproveForm" :model="schoolApproveForm" :rules="schoolApproveRules" label-width="120px">
        <el-form-item label="学校审批意见" prop="schoolApproveDesc">
          <el-input v-model="schoolApproveForm.schoolApproveDesc" type="textarea" placeholder="请输入审批意见"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitSchoolApprove">确 定</el-button>
        <el-button @click="schoolApproveOpen = false">取 消</el-button>
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
    <el-dialog title="中期检查评分" :visible.sync="midScoreOpen" width="900px" append-to-body>
      <el-form ref="midScoreForm" :model="midScoreForm" :rules="midScoreRules" label-width="120px">
        <el-alert
          title="评分须知：所有评分项满分为100分，最终得分为加权平均分。请参照下表评分标准进行评分。"
          type="info"
          :closable="false"
          style="margin-bottom: 20px"
        />

        <div class="score-table-container">
          <table class="score-table">
            <thead>
            <tr>
              <th rowspan="2" width="80">评审内容</th>
              <th rowspan="2" width="60">权重</th>
              <th colspan="4">评审标准</th>
              <th rowspan="2" width="120">评分<br>(百分制)</th>
            </tr>
            <tr>
              <th width="150">A级<br>(80-100分)</th>
              <th width="150">B级<br>(60-80分)</th>
              <th width="150">C级<br>(40-60分)</th>
              <th width="150">D级<br>(0-40分)</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>选题价值</td>
              <td>0.2</td>
              <td>有重要创新性或应用性。</td>
              <td>有比较重要的创新性或应用性。</td>
              <td>创新性或应用性一般。</td>
              <td>基本属于重复性工作。</td>
              <td>
                <div class="score-input-wrapper">
                  <el-input-number
                    v-model="midScoreForm.midScoreXtjz"
                    :precision="0"
                    :min="0"
                    :max="100"
                    size="small"
                    @change="calculateScore"
                    controls-position="right"
                  />
                </div>
              </td>
            </tr>
            <tr>
              <td>研究基础</td>
              <td>0.2</td>
              <td>熟悉研究现状，所列参考文献具有代表性。</td>
              <td>比较熟悉研究现状，所列参考文献比较有代表性。</td>
              <td>一般了解研究现状，所列参考文献有一定代表性。</td>
              <td>不了解研究现状，所列参考文献没有代表性。</td>
              <td>
                <div class="score-input-wrapper">
                  <el-input-number
                    v-model="midScoreForm.midScoreYjjc"
                    :precision="0"
                    :min="0"
                    :max="100"
                    size="small"
                    @change="calculateScore"
                    controls-position="right"
                  />
                </div>
              </td>
            </tr>
            <tr>
              <td>内容设计</td>
              <td>0.5</td>
              <td>目标明确，内容充实，思路清晰。</td>
              <td>目标比较明确，内容比较充实，思路比较清晰。</td>
              <td>目标基本明确，内容基本充实，思路基本清晰。</td>
              <td>目标不够明确，内容空泛，思路模糊。</td>
              <td>
                <div class="score-input-wrapper">
                  <el-input-number
                    v-model="midScoreForm.midScoreNrsj"
                    :precision="0"
                    :min="0"
                    :max="100"
                    size="small"
                    @change="calculateScore"
                    controls-position="right"
                  />
                </div>
              </td>
            </tr>
            <tr>
              <td>研究方法</td>
              <td>0.1</td>
              <td>方法与手段科学、适切</td>
              <td>方法比较科学、适切</td>
              <td>方法手段基本科学、适切</td>
              <td>方法手段不当</td>
              <td>
                <div class="score-input-wrapper">
                  <el-input-number
                    v-model="midScoreForm.midScoreYjff"
                    :precision="0"
                    :min="0"
                    :max="100"
                    size="small"
                    @change="calculateScore"
                    controls-position="right"
                  />
                </div>
              </td>
            </tr>
            </tbody>
            <tfoot>
            <tr>
              <td colspan="6" style="text-align: right; font-weight: bold;">总分（加权平均）：</td>
              <td>
                <el-tag type="success" size="medium">{{ totalScore }}</el-tag>
              </td>
            </tr>
            </tfoot>
          </table>
        </div>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitMidScore">提 交</el-button>
        <el-button @click="midScoreOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 结项对话框 -->
    <el-dialog title="结项" :visible.sync="endProjectOpen" width="500px" append-to-body>
      <el-form ref="endProjectForm" :model="endProjectForm" :rules="endProjectRules" label-width="80px">
        <el-form-item label="结项说明" prop="endDesc">
          <el-input v-model="endProjectForm.endDesc" type="textarea" placeholder="请输入结项说明"/>
        </el-form-item>
        <el-form-item label="结项材料" prop="endFileUrl">
          <file-upload
            v-model="endProjectForm.endFileUrl"
            :limit="1"
            :fileType="['doc', 'docx' ,'xls', 'xlsx' ,'ppt', 'pptx','txt', 'pdf', 'zip', 'png','jpg']"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitEndProject">提 交</el-button>
        <el-button @click="endProjectOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 结项评分对话框 -->
    <el-dialog title="结项评分" :visible.sync="endScoreOpen" width="900px" append-to-body>
      <el-form ref="endScoreForm" :model="endScoreForm" :rules="endScoreRules" label-width="120px">
        <el-alert
          title="评分须知：所有评分项满分为100分，最终得分为加权平均分。请参照下表评分标准进行评分。"
          type="info"
          :closable="false"
          style="margin-bottom: 20px"
        />

        <!-- 中期评分展示 -->
        <el-card class="box-card" shadow="hover" style="margin-bottom: 20px">
          <div slot="header" class="clearfix">
            <span style="font-weight: bold">中期检查评分 (占总评权重30%)</span>
          </div>
          <el-descriptions :column="2" border size="small">
            <el-descriptions-item label="选题价值分(权重0.2)">{{ detail.midScoreXtjz || 0 }}</el-descriptions-item>
            <el-descriptions-item label="研究基础分(权重0.2)">{{ detail.midScoreYjjc || 0 }}</el-descriptions-item>
            <el-descriptions-item label="内容设计分(权重0.5)">{{ detail.midScoreNrsj || 0 }}</el-descriptions-item>
            <el-descriptions-item label="研究方法分(权重0.1)">{{ detail.midScoreYjff || 0 }}</el-descriptions-item>
            <el-descriptions-item label="中期评分总分" :span="2">
              <el-tag type="success" size="medium">
                {{
                  (detail.midScoreXtjz * 0.2 + detail.midScoreYjjc * 0.2 + detail.midScoreNrsj * 0.5 + detail.midScoreYjff * 0.1).toFixed(2)
                }}
              </el-tag>
            </el-descriptions-item>
          </el-descriptions>
        </el-card>

        <div class="score-table-container">
          <div class="score-title">结项评分 (占总评权重70%)</div>
          <table class="score-table">
            <thead>
            <tr>
              <th rowspan="2" width="80">评审内容</th>
              <th rowspan="2" width="60">权重</th>
              <th colspan="4">评审标准</th>
              <th rowspan="2" width="120">评分<br>(百分制)</th>
            </tr>
            <tr>
              <th width="150">A级<br>(80-100分)</th>
              <th width="150">B级<br>(60-80分)</th>
              <th width="150">C级<br>(40-60分)</th>
              <th width="150">D级<br>(0-40分)</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>选题价值</td>
              <td>0.2</td>
              <td>有重要创新性或应用性。</td>
              <td>有比较重要的创新性或应用性。</td>
              <td>创新性或应用性一般。</td>
              <td>基本属于重复性工作。</td>
              <td>
                <div class="score-input-wrapper">
                  <el-input-number
                    v-model="endScoreForm.endScoreXtjz"
                    :precision="0"
                    :min="0"
                    :max="100"
                    size="small"
                    @change="calculateEndScoreTotal"
                    controls-position="right"
                  />
                </div>
              </td>
            </tr>
            <tr>
              <td>研究基础</td>
              <td>0.2</td>
              <td>熟悉研究现状，所列参考文献具有代表性。</td>
              <td>比较熟悉研究现状，所列参考文献比较有代表性。</td>
              <td>一般了解研究现状，所列参考文献有一定代表性。</td>
              <td>不了解研究现状，所列参考文献没有代表性。</td>
              <td>
                <div class="score-input-wrapper">
                  <el-input-number
                    v-model="endScoreForm.endScoreYjjc"
                    :precision="0"
                    :min="0"
                    :max="100"
                    size="small"
                    @change="calculateEndScoreTotal"
                    controls-position="right"
                  />
                </div>
              </td>
            </tr>
            <tr>
              <td>内容设计</td>
              <td>0.5</td>
              <td>目标明确，内容充实，思路清晰。</td>
              <td>目标比较明确，内容比较充实，思路比较清晰。</td>
              <td>目标基本明确，内容基本充实，思路基本清晰。</td>
              <td>目标不够明确，内容空泛，思路模糊。</td>
              <td>
                <div class="score-input-wrapper">
                  <el-input-number
                    v-model="endScoreForm.endScoreNrsj"
                    :precision="0"
                    :min="0"
                    :max="100"
                    size="small"
                    @change="calculateEndScoreTotal"
                    controls-position="right"
                  />
                </div>
              </td>
            </tr>
            <tr>
              <td>研究方法</td>
              <td>0.1</td>
              <td>方法与手段科学、适切</td>
              <td>方法比较科学、适切</td>
              <td>方法手段基本科学、适切</td>
              <td>方法手段不当</td>
              <td>
                <div class="score-input-wrapper">
                  <el-input-number
                    v-model="endScoreForm.endScoreYjff"
                    :precision="0"
                    :min="0"
                    :max="100"
                    size="small"
                    @change="calculateEndScoreTotal"
                    controls-position="right"
                  />
                </div>
              </td>
            </tr>
            </tbody>
            <tfoot>
            <tr>
              <td colspan="6" style="text-align: right; font-weight: bold;">结项评分总分：</td>
              <td>
                <el-tag type="success" size="medium">
                  {{ endTotalScore }}
                </el-tag>
              </td>
            </tr>
            </tfoot>
          </table>
        </div>

        <!-- 最终评分展示 -->
        <div class="final-score">
          <div class="final-score-title">最终评分（中期30% + 结项70%）</div>
          <div class="final-score-value">
            <el-tag type="danger" size="large">{{ finalScore }}</el-tag>
          </div>
        </div>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitEndScore">提 交</el-button>
        <el-button @click="endScoreOpen = false">取 消</el-button>
      </div>
    </el-dialog>

    <!-- 导入对话框 -->
    <el-dialog :title="upload.title" :visible.sync="upload.open" width="400px" append-to-body>
      <el-form ref="uploadForm" :model="upload.form" label-width="100px">
        <el-form-item label="Excel文件">
          <el-upload
            ref="excelFileUpload"
            :limit="1"
            accept=".xlsx, .xls"
            :headers="upload.headers"
            :action="baseUrl + '/web/innoProject/importData'"
            :disabled="upload.isUploading"
            :on-progress="handleFileUploadProgress"
            :on-success="handleFileUploadSuccess"
            :on-error="handleFileUploadError"
            :on-exceed="handleFileExceed"
            :before-upload="beforeFileUpload"
            :show-file-list="true">
            <el-button slot="trigger" size="small" type="primary">选取文件</el-button>
            <div slot="tip" class="el-upload__tip">请上传Excel文件，且不超过10MB</div>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="upload.open = false">关 闭</el-button>
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
  schoolApproveInnoProject,
  submitMidCheck,
  submitMidCheckScore,
  calculateMidScore,
  submitEndProject,
  submitEndProjectScore,
  calculateEndScore,
  importTemplate,
  importData
} from "@/api/innoProject";
import {listTeacher, listTeacherBySchool} from "@/api/person/teacher";
import {listProjectType} from "@/api/system/projectType";
import {listStudentOptions} from "@/api/person/student";
import store from '@/store' // 导入store

export default {
  name: "InnoProject",
  data() {
    return {
      activeName: 'basic',
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
        ]
        // 移除 submitFileUrl 的必填验证
      },
      // 项目类型选项
      projectTypeOptions: [],
      // 状态选项
      statusOptions: [],
      // 导师选项
      teacherOptions: [],
      // 筛选后的导师选项
      filteredTeacherOptions: [],
      // 学生选项
      studentOptions: [],
      // 当前选中学生的学校ID
      currentSchoolId: null,
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
      // 学校审批对话框标题
      schoolApproveTitle: "",
      // 是否显示学校审批对话框
      schoolApproveOpen: false,
      // 学校审批表单参数
      schoolApproveForm: {
        id: undefined,
        schoolApproveDesc: undefined,
        isApprove: undefined
      },
      // 审批表单校验
      approveRules: {
        approveDesc: [
          {required: true, message: "审批原因不能为空", trigger: "blur"}
        ]
      },
      // 学校审批表单校验
      schoolApproveRules: {
        schoolApproveDesc: [
          {required: true, message: "学校审批意见不能为空", trigger: "blur"}
        ]
      },
      // 学校审批状态选项
      schoolApproveStatusOptions: [
        { dictValue: "WAIT_APPROVE", dictLabel: "待审批" },
        { dictValue: "APPROVE_SUCCESS", dictLabel: "审批通过" },
        { dictValue: "APPROVE_FAIL", dictLabel: "审批不通过" }
      ],
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
      totalScore: 0,
      // 结项对话框是否显示
      endProjectOpen: false,
      // 结项表单参数
      endProjectForm: {
        id: undefined,
        endDesc: undefined,
        endFileUrl: undefined
      },
      // 结项表单校验
      endProjectRules: {
        endDesc: [
          {required: true, message: "结项说明不能为空", trigger: "blur"}
        ],
        endFileUrl: [
          {required: true, message: "结项材料不能为空", trigger: "change"}
        ]
      },
      // 结项评分对话框是否显示
      endScoreOpen: false,
      // 结项评分表单参数
      endScoreForm: {
        id: undefined,
        endScoreXtjz: 0,
        endScoreYjjc: 0,
        endScoreNrsj: 0,
        endScoreYjff: 0
      },
      // 结项评分表单校验
      endScoreRules: {
        endScoreXtjz: [
          {required: true, message: "选题价值分不能为空", trigger: "blur"}
        ],
        endScoreYjjc: [
          {required: true, message: "研究基础分不能为空", trigger: "blur"}
        ],
        endScoreNrsj: [
          {required: true, message: "内容设计分不能为空", trigger: "blur"}
        ],
        endScoreYjff: [
          {required: true, message: "研究方法分不能为空", trigger: "blur"}
        ]
      },
      // 结项总分
      endTotalScore: 0,
      // 中期评分信息
      midScoreInfo: {},
      // 中期总分信息
      midTotalScoreInfo: 0,
      // 最终评分
      finalScore: 0,
      // 导入对话框参数
      upload: {
        title: "批量导入项目",
        open: false,
        isUploading: false,
        headers: {}
      }
    };
  },
  created() {
    this.getList();
    this.getProjectTypeList();
    this.getTeacherList();
    this.getStatusOptions();
    this.getStudentList();
    // 初始化上传参数
    this.upload.headers = { Authorization: "Bearer " + this.$store.getters.token };
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
    /** 查询学生列表 */
    getStudentList() {
      listStudentOptions().then(response => {
        this.studentOptions = response.data;
      });
    },
    /** 获取老师列表 */
    getTeacherList() {
      listTeacher().then(response => {
        this.teacherOptions = response.rows;
        this.filteredTeacherOptions = this.teacherOptions;
      });
    },
    /** 获取状态选项 */
    getStatusOptions() {
      this.getDicts("project_status").then(response => {
        this.statusOptions = response.data;
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

      // 判断当前用户是否为学生角色
      const roles = store.getters && store.getters.roles;
      // 检测角色列表中是否包含学生角色标识
      const isStudent = roles.some(role => role === '100' || role === 'student');

      if (isStudent) {
        // 如果是学生，获取当前学生信息
        const username = store.getters.name;
        // 查找当前学生的信息以获取学校ID
        listStudentOptions().then(response => {
          const currentStudent = response.data.find(s => s.stuNo === username);
          if (currentStudent && currentStudent.schoolId) {
            this.currentSchoolId = currentStudent.schoolId;
            // 根据学校ID获取教师列表
            this.getTeachersBySchool(currentStudent.schoolId);

            // 如果是学生用户，自动将自己添加为项目成员
            this.selectedMemberCodes = [username];
            this.form.memberList = [{
              memberUserCode: username,
              memberUserName: currentStudent.stuName,
              reportFlag: 1 // 设置为报告人
            }];
          } else {
            // 无法获取学生的学校ID，使用所有教师列表
            this.filteredTeacherOptions = this.teacherOptions;
          }
        });
      } else {
        // 非学生角色，重置筛选的教师列表
        this.filteredTeacherOptions = this.teacherOptions;
        this.currentSchoolId = null;
      }
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getInnoProject(id).then(response => {
        this.form = response.data;
        // 处理成员列表回显
        if (this.form.memberList && this.form.memberList.length > 0) {
          this.selectedMemberCodes = this.form.memberList.map(member => member.memberUserCode);
        }
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
        console.log("详情数据:", this.detail); // 调试日志

        // 计算中期总分
        if (this.detail.midScoreXtjz !== null && this.detail.midScoreXtjz !== undefined) {
          this.midTotalScoreInfo = (
            this.detail.midScoreXtjz * 0.2 +
            this.detail.midScoreYjjc * 0.2 +
            this.detail.midScoreNrsj * 0.5 +
            this.detail.midScoreYjff * 0.1
          ).toFixed(2);
        }

        // 计算结项总分和最终分数
        if (this.detail.endScoreXtjz !== null && this.detail.endScoreXtjz !== undefined) {
          // 计算结项总分
          this.endTotalScore = (
            this.detail.endScoreXtjz * 0.2 +
            this.detail.endScoreYjjc * 0.2 +
            this.detail.endScoreNrsj * 0.5 +
            this.detail.endScoreYjff * 0.1
          ).toFixed(2);

          // 计算最终评分
          this.finalScore = (parseFloat(this.midTotalScoreInfo) * 0.3 + parseFloat(this.endTotalScore) * 0.7).toFixed(2);
        }

        // 设置默认显示基础信息标签
        this.activeName = 'basic';
        this.detailOpen = true;
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
    /** 学校审批按钮操作 */
    handleSchoolApprove(row, isApprove) {
      this.schoolApproveForm = {
        id: row.id,
        schoolApproveDesc: undefined,
        isApprove: isApprove
      };
      this.schoolApproveTitle = isApprove ? "学校审批通过" : "学校审批拒绝";
      this.schoolApproveOpen = true;
    },
    /** 提交学校审批 */
    submitSchoolApprove() {
      this.$refs["schoolApproveForm"].validate(valid => {
        if (valid) {
          const data = {
            id: this.schoolApproveForm.id,
            schoolApproveDesc: this.schoolApproveForm.schoolApproveDesc
          };
          schoolApproveInnoProject(this.schoolApproveForm.isApprove, data).then(response => {
            this.$modal.msgSuccess("学校审批成功");
            this.schoolApproveOpen = false;
            this.getList();
          });
        }
      });
    },
    /** 成员选择变更 */
    handleMemberChange(value) {
      if (!value || value.length === 0) {
        this.form.memberList = [];
        this.filteredTeacherOptions = [];
        this.currentSchoolId = null;
        return;
      }

      // 获取第一个学生的学校ID
      const firstStudent = this.studentOptions.find(s => s.stuNo === value[0]);
      if (firstStudent && firstStudent.schoolId) {
        this.currentSchoolId = firstStudent.schoolId;
        // 根据学校ID获取教师列表
        this.getTeachersBySchool(firstStudent.schoolId);
      } else {
        this.filteredTeacherOptions = this.teacherOptions;
      }

      // 判断是否为学生角色
      const roles = store.getters && store.getters.roles;
      const isStudent = roles.some(role => role === '100' || role === 'student');
      const username = store.getters.name;

      // 设置成员列表，对于学生用户，确保自己始终是项目成员
      this.form.memberList = value.map(code => {
        const student = this.studentOptions.find(s => s.stuNo === code);
        const reportFlag = isStudent && code === username ? 1 : 0; // 如果是当前学生，设置为报告人
        return {
          memberUserCode: code,
          memberUserName: student?.stuName || '',
          reportFlag: reportFlag
        };
      });
    },

    /** 根据学校ID获取教师列表 */
    getTeachersBySchool(schoolId) {
      listTeacherBySchool(schoolId).then(response => {
        this.filteredTeacherOptions = response.rows;
        // 如果当前选中的教师不在筛选后的列表中，则清空选择
        if (this.form.teacherId && !this.filteredTeacherOptions.some(t => t.id === this.form.teacherId)) {
          this.form.teacherId = undefined;
        }
      });
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
    },
    /** 结项按钮操作 */
    handleEndProject(row) {
      this.endProjectForm = {
        id: row.id,
        endDesc: row.endDesc,
        endFileUrl: row.endFileUrl
      };
      this.endProjectOpen = true;
    },
    /** 提交结项 */
    submitEndProject() {
      this.$refs["endProjectForm"].validate(valid => {
        if (valid) {
          submitEndProject(this.endProjectForm).then(response => {
            this.$modal.msgSuccess("结项提交成功");
            this.endProjectOpen = false;
            this.getList();
          });
        }
      });
    },
    /** 结项评分按钮操作 */
    handleEndProjectScore(row) {
      getInnoProject(row.id).then(response => {
        const data = response.data;

        // 将完整的项目数据保存到detail对象中，以便显示中期评分信息
        this.detail = data;

        // 保存中期评分信息
        this.midScoreInfo = {
          midScoreXtjz: data.midScoreXtjz || 0,
          midScoreYjjc: data.midScoreYjjc || 0,
          midScoreNrsj: data.midScoreNrsj || 0,
          midScoreYjff: data.midScoreYjff || 0
        };

        // 计算中期总分
        this.midTotalScoreInfo = (
          this.midScoreInfo.midScoreXtjz * 0.2 +
          this.midScoreInfo.midScoreYjjc * 0.2 +
          this.midScoreInfo.midScoreNrsj * 0.5 +
          this.midScoreInfo.midScoreYjff * 0.1
        ).toFixed(2);

        // 保存结项评分表单
        this.endScoreForm = {
          id: data.id,
          endScoreXtjz: data.endScoreXtjz || 0,
          endScoreYjjc: data.endScoreYjjc || 0,
          endScoreNrsj: data.endScoreNrsj || 0,
          endScoreYjff: data.endScoreYjff || 0
        };

        // 计算结项总分和最终评分
        this.calculateEndScoreTotal();
        this.endScoreOpen = true;
      });
    },

    /** 计算结项总分 */
    calculateEndScoreTotal() {
      const params = {
        xtjz: this.endScoreForm.endScoreXtjz,
        yjjc: this.endScoreForm.endScoreYjjc,
        nrsj: this.endScoreForm.endScoreNrsj,
        yjff: this.endScoreForm.endScoreYjff
      };
      calculateEndScore(params).then(response => {
        this.endTotalScore = response.data;
        // 计算最终评分
        this.calculateFinalScore();
      });
    },

    /** 计算最终评分 */
    calculateFinalScore() {
      this.finalScore = (parseFloat(this.midTotalScoreInfo) * 0.3 + parseFloat(this.endTotalScore) * 0.7).toFixed(2);
    },
    /** 提交结项评分 */
    submitEndScore() {
      this.$refs["endScoreForm"].validate(valid => {
        if (valid) {
          submitEndProjectScore(this.endScoreForm).then(response => {
            this.$modal.msgSuccess("结项评分提交成功");
            this.endScoreOpen = false;
            this.getList();
          });
        }
      });
    },
    /** 经费管理按钮操作 */
    handleFundManage(row) {
      this.$router.push({
        path: '/project/fee',
        query: {
          projectId: row.id,
          projectName: row.projectName
        }
      });
    },
    // /** 新增按钮操作 */
    // handleAdd() {
    //   this.reset();
    //   this.open = true;
    //   this.title = "添加大创项目";
    // },
    /** 重置表单 */
    // reset() {
    //   this.form = {
    //     id: undefined,
    //     projectName: undefined,
    //     projectType: undefined,
    //     projectDesc: undefined,
    //     teacherId: undefined,
    //     submitFileUrl: undefined,
    //     memberList: []
    //   };
    //   this.selectedMemberCodes = [];
    //   this.resetForm("form");
    // },
    /** 处理成员变更 */
    // handleMemberChange(value) {
    //   // 根据学生工号更新memberList
    //   const memberList = [];
    //   value.forEach(studentCode => {
    //     const student = this.studentOptions.find(item => item.stuNo === studentCode);
    //     if (student) {
    //       memberList.push({
    //         memberUserCode: student.stuNo,
    //         memberUserName: student.stuName
    //       });
    //     }
    //   });
    //   this.form.memberList = memberList;
    // },
    /** 提交表单 */
    submitForm(submit = false) {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateInnoProject(this.form, submit).then(response => {
              this.$modal.msgSuccess(submit ? "提交成功" : "保存成功");
              this.open = false;
              this.getList();
            });
          } else {
            addInnoProject(this.form, submit).then(response => {
              this.$modal.msgSuccess(submit ? "提交成功" : "保存成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 下载模板操作 */
    handleExportTemplate() {
      // importTemplate().then(response => {
      //   this.download(response);
      // });
      this.download('/web/innoProject/importTemplate', {
      }, `项目导入模版.xlsx`)
    },
    /** 导入按钮操作 */
    handleImport() {
      this.upload.open = true;
      this.upload.isUploading = false;
    },
    /** 文件上传前的钩子 */
    beforeFileUpload(file) {
      const isExcel = file.type === 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ||
                     file.type === 'application/vnd.ms-excel';
      const isLt10M = file.size / 1024 / 1024 < 10;

      if (!isExcel) {
        this.$message.error('上传文件只能是Excel文件!');
        return false;
      }
      if (!isLt10M) {
        this.$message.error('上传文件大小不能超过10MB!');
        return false;
      }
      this.upload.isUploading = true;
      this.$message.info('开始上传文件，请稍候...');
      return true;
    },
    /** 文件上传中处理 */
    handleFileUploadProgress(event, file, fileList) {
      this.upload.isUploading = true;
    },
    /** 文件上传成功处理 */
    handleFileUploadSuccess(response, file, fileList) {
      this.upload.isUploading = false;

      if (response.code === 200) {
        this.$modal.msgSuccess(response.msg || '导入成功');
        this.upload.open = false;
        this.getList();
      } else {
        this.$modal.msgError(response.msg || '导入失败');
      }
      this.$refs.excelFileUpload.clearFiles();
    },
    /** 文件上传失败处理 */
    handleFileUploadError(error, file, fileList) {
      this.upload.isUploading = false;

      let errorMsg = '导入失败，请重试';
      if (error && error.message) {
        errorMsg = '导入失败：' + error.message;
      } else if (error && error.response && error.response.data) {
        errorMsg = '导入失败：' + (error.response.data.msg || error.response.statusText);
      }

      this.$modal.msgError(errorMsg);
      console.error('文件上传失败：', error);
    },
    /** 文件数量超出限制处理 */
    handleFileExceed() {
      this.$message.warning("最多只能上传一个文件");
    },
    /** 导入按钮操作 */
    handleImport() {
      this.upload.open = true;
      this.upload.isUploading = false;
      // 如果有上传的文件，清空
      if (this.$refs.excelFileUpload) {
        this.$refs.excelFileUpload.clearFiles();
      }
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

.score-table-container {
  max-width: 800px;
  margin: 0 auto;
  overflow-x: auto;
}

.score-table {
  width: 100%;
  border-collapse: collapse;
  border: 1px solid #dcdfe6;
  margin-bottom: 20px;
}

.score-table th,
.score-table td {
  padding: 12px 8px;
  text-align: center;
  border: 1px solid #dcdfe6;
  font-size: 14px;
  vertical-align: middle;
}

.score-table th {
  background-color: #f5f7fa;
  font-weight: bold;
  color: #303133;
}

.score-table thead th {
  position: sticky;
  top: 0;
  z-index: 1;
}

.score-table tbody tr:hover {
  background-color: #f5f7fa;
}

.score-table tbody td {
  color: #606266;
}

.score-table tfoot td {
  background-color: #f5f7fa;
  font-weight: 500;
}

.score-table .el-input-number {
  width: 100%;
}

.score-input-wrapper {
  width: 120px;
  margin: 0 auto;
}

.score-input-wrapper .el-input-number {
  width: 120px;
}

/* 自定义Element UI输入框样式 */
.score-input-wrapper .el-input-number .el-input__inner {
  text-align: center;
}

.box-card {
  margin-bottom: 20px;
}

.final-score {
  margin-top: 20px;
  text-align: right;
}

.final-score-title {
  font-weight: bold;
  margin-right: 10px;
}

.final-score-value {
  display: inline-block;
}

.score-title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 15px;
  color: #303133;
  text-align: center;
}
</style>

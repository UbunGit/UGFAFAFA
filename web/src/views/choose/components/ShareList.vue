<template>
  <div>
    <el-card>
      <el-form
        :model="formdata"
        ref="formdata"
        size="mini"
      >
        <el-col >
          <el-form-item label="选择时间">
            <el-date-picker
              type="date"
              format="yyyy-MM-dd"
              value-format="yyyy-MM-dd"
              placeholder="选择日期"
              v-model="formdata.date"
              @change="handledatachange"
              style="width: 100%;"
            ></el-date-picker>
          </el-form-item>
        </el-col>
      </el-form>
    </el-card>
    <el-tabs>
      <el-tab-pane label="股价">
        <span> {{size}}</span>  
        <el-table :data="shareList" 
        @cell-click="handleCellClick"
        height="400px">
          <el-table-column width="180">
            <template slot-scope="scope">
              <span>{{scope.row.code}}</span>
              <span>{{scope.row.name}}</span>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
import { fitterList } from "@/api/share";
export default {
  name: "ShareList",
  created() {
    this.fitterList();
  },
  data() {
    return {
      formdata: {
        date: "2020-03-02"
      },
      shareList: [],
      size:0
    };
  },
  methods: {
    // 获取股票列表
    fitterList() {
      this.loading = true;
      fitterList(this.formdata).then(response => {
        this.shareList = response.data.data;
        this.size = this.shareList.length
        this.loading = false;
      });
    },
    handleCellClick(row) {
      this.$emit("cell-click", row.code);
    },
    handledatachange(){
        this.shareList = []
        this.fitterList()
    }
  }
};
</script>
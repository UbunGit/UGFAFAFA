<template>
  <div>
    <el-container>
      <el-header></el-header>
      <el-container>
        <el-aside :span="4">
          <el-card>
            <share-list @cell-click="handleCellClick"></share-list>
          </el-card>
        </el-aside>
        <el-main :span="12">
          <el-card>
            <el-form
              :model="formdata"
              ref="formdata"
              label-width="100px"
              class="demo-ruleForm"
              size="mini"
            >
              <el-col :span="4">
                <el-form-item label="股票代码">
                  <span >{{formdata.code}}</span>
                  <span >{{formdata.name}}</span>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="开始时间">
                  <el-date-picker
                    type="date"
                    format="yyyy-MM-dd"
                    value-format="yyyy-MM-dd"
                    placeholder="选择日期"
                    v-model="formdata.begin"
                    @change="handledatachange"
                    style="width: 100%;"
                  ></el-date-picker>
                </el-form-item>
              </el-col>

              <el-col :span="8">
                <el-form-item label="结束时间">
                  <el-date-picker
                    type="date"
                    format="yyyy-MM-dd"
                    value-format="yyyy-MM-dd"
                    placeholder="选择日期"
                    v-model="formdata.end"
                    @change="handledatachange"
                    style="width: 100%;"
                  ></el-date-picker>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="股价">
                  <span >{{lastData.close}}</span>
                </el-form-item>
              </el-col>
            </el-form>
          </el-card>
          <el-card style="wigth=100%">
            <ve-candle :data="chartData" 
            :settings="chartSettings" 
            @ready-once="readyOnve"
            height="180pt"
            v-loading="loading"></ve-candle>
            <ve-histogram
              :data="amountdata"
              :settings="amountSettings"
              @ready-once="readyOnve"
              height="160pt"
            ></ve-histogram>
          </el-card>
          <el-card>{{chartData.rows}}</el-card>
        </el-main>
      </el-container>
    </el-container>

    <el-drawer
      title="选择策略"
      :visible.sync="drawer"
      :direction="direction"
      :before-close="handleClose"
    ></el-drawer>
  </div>
</template>
<script>
import { sharehistory, fitterList } from "@/api/share";
import ShareList from "./components/ShareList";
import { str2Date ,addDate} from "@/utils/date";
export default {
  components: { ShareList },
  created() {
    // this.getresult();
  },
  data() {
    return {
      loading: false,
      formdata: {
        begin: "2019-03-01",
        end: null,
        code: "000100"
      },
      lastData: {
        close:0.00
      },
      result: null,
      shareList: [],
      drawer: false,
      direction: "ltr",
      chartSettings: {
        showMA: true,
        showVol: true,
        downColor: "#00da3c",
        upColor: "#ec0000",
      },
      chartData: {
        columns: ["date", "open", "close", "low", "high", "volume"],
        rows: []
      },
      amountdata: {
          columns: ['date', 'MACD','DIFF','DEA'],
          rows: [],
          
      },
      amountSettings: {
        showDataZoom: true,
        scale:[true,true],
        smooth: false,
        showLine: ['DIFF','DEA'],
      },
    };
  },
  methods: {
    onSubmit() {},
    //获取股票交易数据
    getresult() {
      this.loading = true;
      sharehistory(this.formdata).then(response => {
        this.result = response.data.data;
        this.chartData.rows = this.result;
        this.amountdata.rows = this.result;
        this.lastData = this.result[this.result.length-1]
        this.loading = false;
      });
    },

    handlePreview(file) {
      var reader = new FileReader();
      reader.onload = () => {
        this.formdata.code = reader.result;
      };
      reader.readAsText(file.raw);
    },
    handleClose() {},
    handleCellClick(code, date) {
      this.formdata.code = code;
      this.formdata.begin = addDate(date,-15)
      this.formdata.end = addDate(date,15)
      this.getresult();
    },
    handledatachange(){
        this.getresult();
    },
    readyOnve(echart, options, echartsLib){
      echart.group = "group1";
      echartsLib.connect("group1");
    }
  }
};
</script>
<style>
.el-header {
  background-color: #b3c0d1;
  padding: 10pt;
}
.el-footer {
  color: #333;
}

.el-aside {
  color: #333;
}

.el-main {
  color: #333;
}
</style>
  <template>
  <div>
    <van-cell>
      <div style="float:right">
        <van-button icon="replay" text="刷新" size="mini" @click="onexit" />
        <van-button icon="edit" text="参数" size="mini" />
      </div>
    </van-cell>
    <van-cell>
      <van-collapse v-model="activeNames">
        <van-collapse-item title="总览" name="1">
          <ve-line
            :data="resultdata"
            :settings="resultSettings"
            :data-zoom="dataZoom"
            :events="chartEvents"
            :tooltip="tooltip"
            @ready-once="readyOnve"
            :colors=resultSettings.colors
            height="300px"
          ></ve-line>
        </van-collapse-item>
        <van-collapse-item title="日线图" name="2">
          <ve-candle
            :data="chartData"
            :events="chartEvents"
            height="300px"
            :settings="chartSettings"
            @ready-once="readyOnve"
            :data-zoom="dataZoom"
          ></ve-candle>
        </van-collapse-item>
        <van-collapse-item title="MACD" name="3">
          <ve-histogram
            :data="histogramdata"
            :events="chartEvents"
            :settings="histogramSettings"
            :data-zoom="dataZoom"
            @ready-once="readyOnve"
            height="300px"
          ></ve-histogram>
        </van-collapse-item>

        <van-collapse-item title="资产评估" name="4">
          <ve-line
            :data="amountdata"
            :settings="amountSettings"
            :data-zoom="dataZoom"
            :events="chartEvents"
            @ready-once="readyOnve"
            height="300px"
          ></ve-line>
        </van-collapse-item>
      </van-collapse>

      <el-row>
        <el-col :span="12">
          <h1>买入信息</h1>
          <div>
            <span>价格：</span>
            <span>{{selectDara.buy}}</span>
          </div>
          <div>{{selectDara.buymsg}}</div>
        </el-col>
        <el-col :span="12">
          <h1>买出信息</h1>
          <div>
            <span>价格：</span>
            <span>{{selectDara.sell}}</span>
          </div>
          <div>{{selectDara.sellmsg}}</div>
          <span></span>
        </el-col>
      </el-row>
      <el-row>
        <h1>买卖计划{{selectDara.date}}</h1>
         <van-cell 
        v-for="item in this.plant" :key="item.input" 
        :title="item.input" 
        :value="item.store"
       >
        <template #title>
            <span>买入：{{item.input}}</span>
        </template>
        <template #label>
            <span>欲卖：{{item.out}}</span>
            <span>收益：{{item.tem}}</span>
        </template>
        <template #default>
            <span>持仓：{{item.store}}</span>
        </template>
         </van-cell>
      </el-row>
    </van-cell>
  </div>
</template>

<script>
import { exit as tactucexit } from "@/api/tactucs";
export default {
  created: function () {},
  props: {
    value: [],
  },
  watch: {
    value: {
      handler(newValue, oldValue) {
        if (newValue != null) {
          this.chartData.rows = newValue;
          this.amountdata.rows = newValue;
          this.histogramdata.rows = newValue;
          this.resultdata.rows = newValue;
        }
      },
      immediate: true,
    },
  },
  computed:{
    plant:function(){
      if(this.selectDara.plandf == undefined){
        return []
      }
      let tplant = JSON.parse(this.selectDara.plandf)
 
      return tplant
    }
  },
  data() {
    var self = this;
    this.chartEvents = {
      click: function (e) {
        self.selectDara = self.amountdata.rows[e.dataIndex];
        console.log(self.selectDara);
      },
    };
    this.tooltip = {
      trigger: "axis",
      position: function (point, params, dom, rect, size) {
        self.selectDara = self.amountdata.rows[params[0].dataIndex];
        return;
      },
    };

    return {
      param: {},
      selectDara: {},
      activeNames: ["1"],
      dataZoom: [
        {
          type: "slider",
          start: 0,
          end: 100,
        },
      ],
      chartSettings: {
        showMA: true,
        showVol: true,
        showDataZoom: true,
        downColor: "#00da3c",
        upColor: "#ec0000",
      },
      chartData: {
        columns: ["date", "open", "close", "low", "high", "volume"],
        rows: [],
        selectedDepIndex: 1,
      },

      amountdata: {
        columns: ["date", "store", "all"],
        rows: [],
        showDataZoom: true,
      },
      amountSettings: {
        smooth: false,
        axisSite: { right: ["store"] },
        yAxisName: ["总资产", "持股数"],
        labelMap: {
          all: "总资产",
          store: "持股数",
          sellmsg: "持股数",
        },
      },

      histogramdata: {
        columns: ["date", "MACD", "DIFF", "DEA"],
        rows: [],
      },
      histogramSettings: {
        showDataZoom: true,
        scale: [true, true],
        smooth: false,
        showLine: ["DIFF", "DEA"],
        yAxisType: ["KMB", "KMB"],
        yAxisName: ["数值", "比率"],
      },

      resultdata: {
        columns: ["date", "rate", "vrate"],
        rows: [
          {
            ts_code: "300022.SZ",
            date: "20200508",
            rate: "0.0",
            vrate: "0.2539267016",
            all: 10000.0,
          },
          {
            ts_code: "300022.SZ",
            date: "20200509",
            rate: "0.0",
            vrate: "0.2539267016",
            all: 10000.0,
          },
        ],
      },
      resultSettings: {
        colors:['#c23531','#2f4554'],
        smooth: false,
        labelMap: {
          'rate': '预测收益',
          'vrate': '股票收益'
        },
      },
    };
  },
  methods: {
    readyOnve(echart, options, echartsLib) {
      echart.group = "group1";
      echartsLib.connect("group1");
    },
    onexit() {

      this.$emit("runexit");
    },
  },
};
</script>
<style>
</style>
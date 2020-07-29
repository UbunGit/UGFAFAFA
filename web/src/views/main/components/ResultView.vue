  <template>
  <div>
    <van-cell>
      <div style="float:right">
        <van-button icon="replay" text="刷新" size="mini" @click="onexit" />
        <van-button icon="edit" text="参数" size="mini" />
      </div>
    </van-cell>
    <van-cell>
      <ve-candle
        :data="chartData"
        :events="chartEvents"
        height="140pt"
        :settings="chartSettings"
        @ready-once="readyOnve"
      ></ve-candle>

      <ve-histogram
        :data="histogramdata"
        :events="chartEvents"
        :settings="histogramSettings"
        @ready-once="readyOnve"
        height="140pt"
      ></ve-histogram>

      <ve-line
        :data="amountdata"
        :settings="amountSettings"
        :events="chartEvents"
        @ready-once="readyOnve"
        height="140pt"
      ></ve-line>

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
    </van-cell>
  </div>
</template>

<script>
import { exit as tactucexit } from "@/api/tactucs";
export default {
  created: function() {},

  data() {
    var self = this;
    this.chartEvents = {
      click: function(e) {
        self.selectDara = self.amountdata.rows[e.dataIndex];
        console.log(self.selectDara);
      }
    };
    return {
      param: {},
      selectDara: {},
      chartSettings: {
        showMA: true,
        showVol: true,
        downColor: "#00da3c",
        upColor: "#ec0000"
      },
      chartData: {
        columns: ["date", "open", "close", "low", "high", "volume"],
        rows: [],
        selectedDepIndex: 1
      },

      amountdata: {
        columns: ["date", "store", "all"],
        rows: [],
        showDataZoom: true
      },
      amountSettings: {
        smooth: false,
        axisSite: { right: ["store"] },
        yAxisName: ["总资产", "持股数"],
        labelMap: {
          all: "总资产",
          store: "持股数",
          sellmsg: "持股数"
        }
      },

      histogramdata: {
        columns: ["date", "MACD", "DIFF", "DEA", "k", "d", "j"],
        rows: []
      },
      histogramSettings: {
        showDataZoom: true,
        scale: [true, true],
        smooth: false,
        showLine: ["DIFF", "DEA", "k", "d", "j"],
        axisSite: { right: ["k", "d", "j"] },
        yAxisType: ["KMB", "KMB"],
        yAxisName: ["数值", "比率"]
      }
    };
  },
  methods: {
    readyOnve(echart, options, echartsLib) {
      echart.group = "group1";
      echartsLib.connect("group1");
    },
    onexit() {
      tactucexit(this.$route.query.id).then(response => {
        this.chartData.rows = response;
        this.amountdata.rows = response;
        this.histogramdata.rows = response;
      }).catch(error=>{
        alert(JSON.stringify(error))
      })
    }
  }
};
</script>
<style>
</style>
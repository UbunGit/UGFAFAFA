<template>
  <div>
    <div slot="header" class="clearfix">
      <span>回测分析</span>
    </div>

    <el-form ref="form" :model="data" label-width="80px" class="table">
      <el-form-item :label="item.name" v-for="item in data.params" :key="item.id">
        <el-input v-model="item.name"></el-input>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="onSubmit">执行</el-button>
      </el-form-item>
    </el-form>
    <div>
      <div>bsecharts</div>
      <BS-echarts v-model="result"></BS-echarts>
    </div>
    <!-- <div>{{JSON.stringify(result)}}</div> -->
  </div>
</template>

<script>
import { detailed as tactic ,exit} from "@/api/tactucs";
import  BSEcharts from "./components/BSEcharts";
export default {
  components: { BSEcharts },
  created() {
    this.loadData(this.$route.query.id)
    
  },
  data(){
      return{
          data:{

          },
          result:[]
      }
  },
  methods: {
    loadData(tacticId) {
 
      tactic(tacticId)
        .then((response) => {
          this.data = response.data;
        })
        .catch(() => {});
    },
    onSubmit(){
 
       exit(this.data)
        .then((response) => {
          this.result = response.data;
        })
        .catch((error) => {
          this.$message.error(JSON.stringify(error))
        });
    }
    
  },
};
</script>
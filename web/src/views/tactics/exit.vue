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
  </div>
</template>

<script>
import { detailed as tactic ,exit} from "@/api/tactucs";
export default {
  created() {
    this.loadData(this.$route.query.id)
    
  },
  data(){
      return{
          data:{

          }
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
          this.data = response.data;
        })
        .catch((error) => {
          this.$message.error(JSON.stringify(error))
        });
    }
    
  },
};
</script>
<template>
	<div class="footer">
	      <div class="result">
	        <label>收益：10000.00</label></br>
			<label>收益率：0.00%</label>
	      </div>
	      <div class="active">
	        <button round type="info" class="settle">结算</button>
	        <button round type="info" class="buy">买入</button>
	        <button round type="info" class="seller">卖出</button>
	      </div>
	</div>
</template>

<script>
</script>

<style>
	.footer {
	  position: fixed;
	  bottom: 0px;
	  background-color: #EEEEEE;
	  width: 100%;
	  flex-direction: row;
	  justify-content: space-between;
	  height: 80px;
	  
	}
	
	.footer button {
		position: absolute;
			  display: inline-block;
	  font-size: 10px;
	  
	  width: 60px;
	  height: 30px;
	  bottom: 4px;
	  color: #FFFFFF;
	}
	.settle {
	  border: 1px solid crimson;
	  background-color: crimson;

	  
	  left: 50%;
	  transform: translateX(-50%);
	}
	.buy {

	  border: 1px solid crimson;
	  background-color: crimson;
	  left: 15px;
	}
	.seller {

	  border: 1px solid rgb(101, 59, 201);
	  background-color: rgb(101, 59, 201);
	  right: 15px;
	}
	
	.active {

	}
	.result {
		position: absolute;
		left: 12px;
		font-size: 12px;
		color: #333333;
	}
</style>

var PAZU_Config = { 
        prot:"http",              
        server: 'localhost',   
        port: 6894,            
        license:'8F34B771723DCC171F931EA900F9967E'              
    }
function pageSetup(){
	PAZU.TPrinter.paperName= "dayin";
	PAZU.TPrinter.marginTop= 0;                  //属性 上边距   数据类型：数字   单位：毫米 
	PAZU.TPrinter.marginBottom= 3;
	PAZU.TPrinter.marginLeft= 0;                 //属性 左边距   数据类型：数字   单位：毫米 
	PAZU.TPrinter.marginRight= 0;                //属性 右边距   数据类型：数字   单位：毫米 

}
function printContent(io){
	var space = "&nbsp;&nbsp;&nbsp;";
	var s = "<font size='5pt'>成都朴与素</font><br/>";
        s += "单据号 : " + io.id + space + "<br/>客户名字 : " + io.clientName  + "<br/>地区: " + io.clientArea + "<br/>"; 
        s += "单据日期  : " + io.orderTime + "<br/>";
    	s += "单据种类 : " + io.orderType + "<br/>";
    	s += "上欠 : " + io.preAcctAmt + space + "下欠  : " + io.postAcctAmt + "<br/>";
		s += "---------------单据明细 -------------<br/>";
	var products = io.products;

	var j =1;
	var k = 1; //每页多少行了
 	for (var i = 1; i <= products.length; i++){
	  	var product = products[i-1];
	  	s += i + space + product.productCode + product.color + space +product.quantity + space + product.wholeSales + space + product.totalWholeSales + "<br/>";

 	  	if (i == products.length){
	  		s += "<b>总数 : " + io.totalQ + space +  "总金额 : " + io.totalWholeSales + "</b><br/>";
	  		if (io.cash != 0)
	  		  s += "现金 :" + io.cash;
	  		if (io.card != 0)
	  		  s += " 刷卡 :" +io.card;
		    if (io.alipay != 0)
			  s += "支付宝 :" + io.alipay;
		  	if (io.card != 0)
			  s += " 微信 :" + io.wechat;
		  	s +=  "<br/><br/>展厅电话 : 028-65775577"+ "<br/>"; 
		  	s +=  "加盟热线 : 13880949886/18981987974"+ "<br/>";
		  	s +=  "展厅地址  : 大成市场2期3楼52号";

	  		printOut(s);
	  	}
  	}
	
	
}
function printOrderBackProcess(data){
    var response = data;
	var returnCode = response.returnCode;

	if (returnCode != SUCCESS){
		$.messager.progress('close'); 
		$.messager.alert('操作失败', response.message, 'error');
	} else {
        var returnValue = response.returnValue;
        var inventoryOrder = returnValue.inventoryOrder;
       
        if (inventoryOrder != null && inventoryOrder != ""){
        	pageSetup();
        	printContent(inventoryOrder);
        }
	}
 }
function printOut(data){

	PAZU.print("<p>" + data);
}


